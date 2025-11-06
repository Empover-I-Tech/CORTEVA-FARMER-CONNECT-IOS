//
//  RequesterViewController.swift
//  FarmerConnect
//
//  Created by Empover on 22/12/17.
//  Copyright © 2017 ABC. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import Firebase

@objc class POIItem: NSObject, GMUClusterItem {
    @objc var position: CLLocationCoordinate2D
    @objc var equipmentObj: Equipment?
    
    init(position: CLLocationCoordinate2D, markerEquipment: Equipment) {
        self.position = position
        self.equipmentObj = markerEquipment
    }
    
    init(position: CLLocationCoordinate2D) {
        self.position = position
        //self.name = name
        //self.image = image
    }
    
}
let kClusterItemCount = 10000
let kCameraLatitude = -33.8
let kCameraLongitude = 151.2

class RequesterViewController: RequesterBaseViewController, GMSMapViewDelegate,GMUClusterManagerDelegate,GMUClusterRendererDelegate ,CLLocationManagerDelegate{

    @IBOutlet var googleMapView : GMSMapView?
    @IBOutlet var  lblSelectedLocation : UILabel?
    @IBOutlet weak var selectedLocationChkBox: VKCheckbox!
    
    var isLocationSelectedToStopUpdates : Bool = false
    
    var isChangedPosition = false
    var isFromHome = false
    var isFilterApply = false

    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var selectLocation: CLLocationCoordinate2D?
    var currentLocation : CLLocationCoordinate2D?
    var closeWhite = UIButton()
    var placeMarker = GMSMarker()
    var selectedMarker : GMSMarker?
    let geocoder = GMSGeocoder()
    let imgLocationAnimation = UIImageView()
    var arrEquipmentList = NSMutableArray()
    //var arrClusterEquipmentList = NSMutableArray()
    var locationManager: CLLocationManager?
    var customInfoView : EquipmentInfoView?
    //var tappedMarker : GMSMarker?
    var mapTapGesturerecognizer : UILongPressGestureRecognizer?
    var lblMyOrdersCount : UILabel?
    //var currentLocation: CLLocation?
    
    var btnRatings = UIButton()
    var lblRatingCount = UILabel()
    var clusterManager: GMUClusterManager?
    var renderer : GMUDefaultClusterRenderer?
    var placesClient: GMSPlacesClient?
    //var customInfoWindow : EquipmentInfoView?
      var loginAlertView = UIView()
    var isFromDeeplink : Bool = false
    var cropID : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = false
        
        //googleMapView?.isUserInteractionEnabled = true
        //googleMapView?.settings.setAllGesturesEnabled(true)
        
        btnRatings = UIButton(frame: CGRect(x:UIScreen.main.bounds.size.width-140,y: 5,width: 40,height: 40))
        btnRatings.setImage( UIImage(named: "WhiteStar"), for: UIControlState())
        btnRatings.addTarget(self, action: #selector(RequesterViewController.ratingsButtonClick(_:)), for: UIControlEvents.touchUpInside)
        self.topView?.addSubview(btnRatings)
        btnRatings.isHidden = true
        
        lblRatingCount = UILabel(frame: CGRect(x: UIScreen.main.bounds.size.width-140, y: 7, width: 40, height: 38))
        lblRatingCount.font = UIFont.boldSystemFont(ofSize:10.0)
        lblRatingCount.textColor = UIColor.black
        lblRatingCount.textAlignment = .center
        self.topView?.addSubview(lblRatingCount)
         lblRatingCount.isHidden = true
        
        googleMapView?.delegate = self
        currentLocation = LocationService.sharedInstance.currentLocation?.coordinate
        if self.selectLocation == nil{
            if Validations.checkUserEnabledLocationServiceOrNot(viewController: self as UIViewController,showAlert: true) == true{
                self.googleMapView?.isMyLocationEnabled = true
                if LocationService.sharedInstance.currentLocation?.coordinate != nil{
                    let tempCurrentLocation = LocationService.sharedInstance.currentLocation?.coordinate
                    if tempCurrentLocation != nil {
                        self.selectLocation = tempCurrentLocation
                    }
                    else{
                        self.selectLocation = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
                    }
                }
            }
            else{
                self.selectLocation = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
            }
        }

        //self.selectLocation = CLLocationCoordinate2D(latitude: 17.4474, longitude: 78.3762)
        
        if Validations.checkUserEnabledLocationServiceOrNot(viewController: self as UIViewController,showAlert: true) == true{
            if LocationService.sharedInstance.currentLocation?.coordinate != nil{
                self.googleMapView?.camera = GMSCameraPosition.camera(withTarget: (LocationService.sharedInstance.currentLocation?.coordinate)!, zoom: 17)
                self.placeMarker.map = nil
                self.placeMarker = GMSMarker(position: (LocationService.sharedInstance.currentLocation?.coordinate)!)
                self.placeMarker.map = self.googleMapView!
                self.placeMarker.icon = UIImage(named: "NavigationMarker")
                self.selectLocation = (LocationService.sharedInstance.currentLocation?.coordinate)!
                self.reverseGeocodeCoordinate(coordinate: (LocationService.sharedInstance.currentLocation?.coordinate)!)
            }
        }
        
        DispatchQueue.main.async {
            self.googleMapView?.camera = GMSCameraPosition.camera(withTarget: self.selectLocation!, zoom: 17)
            self.placeMarker = GMSMarker(position: self.selectLocation!)
            self.placeMarker.map = self.googleMapView!
            self.placeMarker.icon = UIImage(named: "NavigationMarker")
        }
        //googleMapView?.settings.consumesGesturesInView = false;
        if self.selectLocation != nil{
            self.geocoder.reverseGeocodeCoordinate(self.selectLocation!) { response, error in
                if let address = response?.firstResult() {
                    DispatchQueue.main.async {
                        let lines = address.lines
                        self.lblSelectedLocation?.text = lines?.joined(separator: ",")
                        self.lblSelectedLocation?.sizeToFit()
                        //self.selectLocationHeightConstraint?.constant = 30 + (self.lblSelectedLocation?.frame.size.height)! + 5
                        self.view.layoutIfNeeded()
                        self.view.updateConstraintsIfNeeded()
                    }
                }
            }
        }

        selectedLocationChkBox.checkboxValueChangedBlock = {
            isOn in
           // print("checkbox is \(isOn ? "ON" : "OFF")")
            if self.mapTapGesturerecognizer != nil{
                self.googleMapView?.removeGestureRecognizer(self.mapTapGesturerecognizer!)
                self.mapTapGesturerecognizer = nil
            }
            if isOn == true{
                self.isLocationSelectedToStopUpdates = true
                self.selectedLocationChkBox.backgroundColor = App_Theme_Blue_Color
            }
            else{
              self.isLocationSelectedToStopUpdates = false
                self.selectedLocationChkBox.backgroundColor = UIColor.white
                self.mapTapGesturerecognizer = UILongPressGestureRecognizer(target: self, action: #selector(RequesterViewController.mapViewSelectAnimationTapGesture(_:)))
                self.mapTapGesturerecognizer?.minimumPressDuration = 0.0
                self.googleMapView?.addGestureRecognizer(self.mapTapGesturerecognizer!)
            }
            self.registerFirebaseEvents(FSR_Freez_Location, "", "", "", parameters: nil)
        }
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        renderer = GMUDefaultClusterRenderer(mapView: self.googleMapView!, clusterIconGenerator: iconGenerator)
        renderer?.delegate = self
        clusterManager = GMUClusterManager(map: self.googleMapView!, algorithm: algorithm, renderer: renderer!)
        clusterManager?.setDelegate(self, mapDelegate: self)
        self.sendRequestToGetEquipmentDetails(self.isFilterApply)

        imgLocationAnimation.frame = CGRect(x: Int((self.view.frame.size.width - 25)/2), y: Int((self.view.frame.size.height - 80)/2), width: 25, height: 80)
        imgLocationAnimation.image = UIImage(named: "LocationAnimation")
        imgLocationAnimation.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 29)
        imgLocationAnimation.isHidden = true
        self.view.addSubview(imgLocationAnimation)

        mapTapGesturerecognizer = UILongPressGestureRecognizer(target: self, action: #selector(RequesterViewController.mapViewSelectAnimationTapGesture(_:)))
        mapTapGesturerecognizer?.minimumPressDuration = 0.0
        //mapTapGesturerecognizer?.numberOfTapsRequired = 1
        self.googleMapView?.addGestureRecognizer(mapTapGesturerecognizer!)
        
        lblMyOrdersCount = UILabel(frame: CGRect(x: UIScreen.main.bounds.size.width - 28, y: 3, width: 22, height: 22))
        lblMyOrdersCount?.font = UIFont.systemFont(ofSize: 11.0)
        lblMyOrdersCount?.backgroundColor = UIColor(red: 255.0/255.0, green: 176.0/255.0, blue: 14.0/255.0, alpha: 1.0)
        lblMyOrdersCount?.cornerRadius = 11
        lblMyOrdersCount?.textAlignment = .center
        lblMyOrdersCount?.isHidden = true
        self.topView?.addSubview(lblMyOrdersCount!)
        let requesterInfoView = RequesterInfoView.instanceFromNib()
        if AppDelegate.isRequesterHelpShow == false {
            AppDelegate.isRequesterHelpShow = true
            requesterInfoView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            let appdelegate = UIApplication.shared.delegate as? AppDelegate
            appdelegate?.window?.addSubview(requesterInfoView)
        }
        self.recordScreenView("RequesterViewController", FSR_MapView)
        self.registerFirebaseEvents(PV_FSR_MapView, "", "", "", parameters: nil)
        let userObj = Constatnts.getUserObject()
        if userObj.userLogsAllPrint == "true"{
        self.saveUserLogEventsDetailsToServer()
        }
    }
    func saveUserLogEventsDetailsToServer(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMddHHmmss" //"dd/MM/yyyy HH:mm:ss"
        var todaysDate = dateFormatter.string(from: Date())
        let userObj = Constatnts.getUserObject()
        
        let dict: NSDictionary = ["userModuleUsageLogs":[[
            "mobileNumber": userObj.mobileNumber,
            "deviceId": userObj.deviceId,
            "deviceType": "iOS",
            "customerId": userObj.customerId,
            "logTimeStamp": todaysDate as? NSString,
            "pincode": userObj.pincode,
            "districtLoggedin":userObj.districtName,
            "stateLoggedin":userObj.stateName,
            "stateName": userObj.stateName,
            "marketName":"",
            "commodity":"",
            
            "eventName": Home_Requester,
            "className":"RequesterViewController",
            "moduleName":"Requester",
            
            "healthCardId":"",
            "productId":"",
            "cropId":"",
            "seasonId":"",
            "isOnlineRecord": "true"]] as? [NSDictionary]
        ]
        
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            userLogEventsSingletonClass.sendUserLogEventsDetailsToServer(dictionary: dict ?? NSDictionary()){ (status, statusMessage) in
                if status == true{
                }else{
                    self.view.makeToast(statusMessage as String? ?? "")
                }
            }
        }else{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let userLogEvents = dict["userModuleUsageLogs"] as! [NSDictionary]
                for eachLogEvent in userLogEvents {
                var userLogEvent: UserLogEvents = UserLogEvents(dict: eachLogEvent)
                userLogEvent.isOnlineRecord = "false"
                appDelegate.saveUserLogEventsModulewise(userLogEvent)
                }
        }
        
    }
    
    @objc func ratingsButtonClick(_ sender: UIButton){
        let toRequesterRatingVC = self.storyboard?.instantiateViewController(withIdentifier: "RequesterRatingViewController") as! RequesterRatingViewController
        self.navigationController?.pushViewController(toRequesterRatingVC, animated: true)
    }
    
    //MARK: sendRequestToGetEquipmentDetails
    func sendRequestToGetEquipmentDetails(_ isApplyFilter: Bool){
        let net = NetworkReachabilityManager(host: "www.google.com")
        let userObj = Constatnts.getUserObject()
        let fromDate = Date()
        let FromDateStr = FarmServicesConstants.getDateStringFromDate(serverDate: fromDate) ?? ""
        let tommorrow = Calendar.current.date(byAdding: .day, value: 30, to: Date())
        let toDateStr = FarmServicesConstants.getDateStringFromDate(serverDate: tommorrow) ?? ""
        let parameters = ["customerId":userObj.customerId!,"latitude":Double((self.selectLocation?.latitude)!),"longitude":Double((self.selectLocation?.longitude)!),"location":"","distance":3,"price":500,"withDriver":true,"pickAndDrop":false,"fromDate":FromDateStr,"toDate":toDateStr,"fromTime":"","toTime":"","equipmentClassification":0,"noOfHours":0,"applyFilter":false,"maxPrice":0,"maxDistance":0] as NSDictionary
        if net?.isReachable == true{
            let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
            var params =  ["data" : paramsStr]
            print(params)
            if isApplyFilter == true{
                let appdelegate = UIApplication.shared.delegate as? AppDelegate
                if let paramsDic = appdelegate?.tempDictToSaveReqDetails as NSDictionary? {
                    let filterParamStr = Constatnts.nsobjectToJSON(paramsDic as NSDictionary)
                    params = ["data" : filterParamStr]
                }
            }
            self.requestToGetEquipmentDetails(equipmentParams:params as [String:String])
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
    }
    
    //MARK: requestToGetEquipmentDetails
    func requestToGetEquipmentDetails (equipmentParams : [String:String]){
        SwiftLoader.show(animated: true)
        
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,GET_EQUIPMENT_LIST])
        
        let userObj = Constatnts.getUserObject()
        
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String]
        print(headers)
        
        Alamofire.request(urlString, method: .post, parameters: equipmentParams, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        //print("Response after decrypting data:\(decryptData)")
                        if let equipmentsArray = Validations.checkKeyNotAvailForArray(decryptData, key: "equipmentList") as? NSArray{
                            self.arrEquipmentList.removeAllObjects()
                            for index in 0..<equipmentsArray.count{
                                if let equipDic = equipmentsArray.object(at: index) as? NSDictionary{
                                    let equipment = Equipment(dict: equipDic)
                                    self.arrEquipmentList.add(equipment)
                                }
                            }
                            self.updateEquipmentsOnMapView()
                        }
                        if let unseenCount = Validations.checkKeyNotAvail(decryptData, key: "unSeenCount") as? Int64{
                            if unseenCount > 0{
                                self.lblMyOrdersCount?.isHidden = false
                                self.lblMyOrdersCount?.text = String(format: "%d", unseenCount)
                            }
                        }
                        if let reqRating = Validations.checkKeyNotAvail(decryptData, key: "rate") as? String{
                            if Validations.isNullString(reqRating as NSString) == false{
                                if reqRating == "0.0"{
                                    self.btnRatings.isHidden = true
                                    self.lblRatingCount.isHidden = true
                                }
                                else{
                                    self.btnRatings.isHidden = false
                                    self.lblRatingCount.isHidden = false
                                    self.lblRatingCount.text = reqRating
                                }
                            }
                        }
                    }
                    else if responseStatusCode == STATUS_CODE_804{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        //print("Response after decrypting data:\(decryptData)")
                        self.arrEquipmentList.removeAllObjects()
                        self.updateEquipmentsOnMapView()
                        self.view.makeToast((json as! NSDictionary).value(forKey: "message") as! String)
                    }
                    else if responseStatusCode == STATUS_CODE_601{
                         Constatnts.logOut()
                        if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                            self.view.makeToast(msg as String)
                        }
                    }
                    else{
                        self.arrEquipmentList.removeAllObjects()
                        self.updateEquipmentsOnMapView()
                    }
                }
            }
        }
    }
    //MARK: Update Equipment Available locations On Map
    func updateEquipmentsOnMapView(){
        self.googleMapView?.clear()
        self.clusterManager?.clearItems()
        var bounds = GMSCoordinateBounds()
        if self.selectLocation != nil{
            self.placeMarker = GMSMarker(position: self.selectLocation!)
            self.placeMarker.icon = UIImage(named: "NavigationMarker")
            //self.placeMarker.isDraggable = true
            self.placeMarker.map = self.googleMapView!
            bounds = bounds.includingCoordinate(self.selectLocation!)
        }
        for index in 0..<arrEquipmentList.count {
            if let equipment = arrEquipmentList.object(at: index) as? Equipment{
                let coordinates = CLLocationCoordinate2D(latitude: (equipment.latitude?.doubleValue ?? 0.0), longitude: (equipment.longitude?.doubleValue ?? 0.0)) as CLLocationCoordinate2D?
                    if coordinates != nil && (coordinates?.latitude != 0.0 || coordinates?.longitude != 0.0){
                        let clusterItem = POIItem(position: coordinates!, markerEquipment: equipment)
                        clusterManager?.add(clusterItem)
                        /*let marker = GMSMarker(position: coordinates!)
                        marker.userData = equipment
                        marker.map = self.googleMapView
                        let markerView = MarkerView.instanceFromNib()
                        if UIScreen.main.bounds.size.width > 320{
                            var frame = markerView.frame
                            frame.size.width = 50
                            frame.size.height = 50
                            markerView.frame = frame
                        }
                        let imageUrl = URL(string: equipment.iconImage! as String!)
                        markerView.imageEquipment?.kf.setImage(with: imageUrl as Resource!, placeholder: UIImage(named: "image_placeholder.png"), options: nil, progressBlock: nil, completionHandler: nil)
                        marker.iconView = markerView*/
                        //marker.title = equipment.classification as String!
                        bounds = bounds.includingCoordinate(coordinates!)
                    }
            }
        }
        let update = GMSCameraUpdate.fit(bounds, withPadding: 30)
        self.googleMapView?.animate(with: update)
        clusterManager?.cluster()
    }
    @objc func mapViewSelectAnimationTapGesture(_ tapgesture: UILongPressGestureRecognizer){
        if self.isLocationSelectedToStopUpdates == false {
            if tapgesture.state == .began {
                //self.placeMarker.icon = UIImage()
                self.googleMapView?.clear()
                imgLocationAnimation.isHidden = false
            }
            else if tapgesture.state == .changed{
                isChangedPosition = true
            }
            else if tapgesture.state == .ended{
                imgLocationAnimation.isHidden = true
                if selectLocation != nil{
                    var mapCenterPoint = imgLocationAnimation.center
                    mapCenterPoint.y = (mapCenterPoint.y) - 30
                    let centerLocation = self.googleMapView?.projection.coordinate(for: mapCenterPoint)
                    self.imgLocationAnimation.isHidden = true
                    self.lblSelectedLocation?.text = "Getting Location..."
                    self.selectLocation = centerLocation
                    DispatchQueue.main.async
                        {
                            //let zoomLevel : Float = (self.googleMapView?.camera.zoom)!
                            self.googleMapView?.clear()
                            self.googleMapView?.camera = GMSCameraPosition.camera(withTarget: centerLocation!, zoom: 17)
                            self.placeMarker = GMSMarker(position: centerLocation!)
                            self.placeMarker.icon = UIImage(named: "NavigationMarker")
                            //self.placeMarker.isDraggable = true
                            self.placeMarker.map = self.googleMapView!
                    }
                    reverseGeocodeCoordinate(coordinate: centerLocation!)
                    
                    self.sendRequestToGetEquipmentDetails(self.isFilterApply)
                    
                    if isChangedPosition == false {
                        //self.placeMarker.icon = UIImage(named: "NavigationMarker")
                    }
                    isChangedPosition = false
                }
            }
        }
        else{
            /*if tapgesture.state == .began || tapgesture.state == .changed {
                let translation = tapgesture.location(in: self.googleMapView)
                if self.customInfoView != nil{
                    for subview in (self.googleMapView?.subviews)!{
                        if subview.isKind(of: EquipmentInfoView.self){
                            
                        }
                    }
                    let infoViewPoint = self.googleMapView?.convert(translation, to: self.customInfoView)
                    print(infoViewPoint)
                }
                
            }*/
        }
    }
    
    func getCenterLocationDetailsFromMapCenter(_ mapCenterPoint: CGPoint, centerLocation: CLLocationCoordinate2D){
        /*var mapCenterPoint = imgLocationAnimation.center
        mapCenterPoint.y = (mapCenterPoint.y) - 30
        let centerLocation = self.googleMapView?.projection.coordinate(for: mapCenterPoint)
        self.imgLocationAnimation.isHidden = true
        self.lblSelectedLocation?.text = "Getting Location..."
        self.selectLocation = centerLocation*/
        //self.lblSelectedLocation?.sizeToFit()
        // self.selectLocationHeightConstraint?.constant = 30 + (self.lblSelectedLocation?.frame.size.height)! + 5
        //self.view.layoutIfNeeded()
        // self.view.updateConstraintsIfNeeded()
        DispatchQueue.main.async
            {
                //let zoomLevel : Float = (self.googleMapView?.camera.zoom)!
                self.googleMapView?.clear()
                self.googleMapView?.camera = GMSCameraPosition.camera(withTarget: centerLocation, zoom: 17)
                self.placeMarker = GMSMarker(position: centerLocation)
                self.placeMarker.icon = UIImage(named: "NavigationMarker")
                //self.placeMarker.isDraggable = true
                self.placeMarker.map = self.googleMapView!
        }
        reverseGeocodeCoordinate(coordinate: centerLocation)
        
        self.sendRequestToGetEquipmentDetails(self.isFilterApply)
        
        if isChangedPosition == false {
            //self.placeMarker.icon = UIImage(named: "NavigationMarker")
        }
        isChangedPosition = false
    }
    @IBAction func btnEquipment_Touch_Up_Inside(_ sender: Any) {
   
    }
    
    @IBAction func btnGetCurrentLocation_Touch_Up_Inside(_ sender:Any){
        DispatchQueue.main.async {
            if Validations.checkUserEnabledLocationServiceOrNot(viewController: self as UIViewController,showAlert: true) == true{
                if LocationService.sharedInstance.currentLocation?.coordinate != nil{
                    self.googleMapView?.camera = GMSCameraPosition.camera(withTarget: (LocationService.sharedInstance.currentLocation?.coordinate)!, zoom: 17)
                    self.placeMarker.map = nil
                    self.placeMarker = GMSMarker(position: (LocationService.sharedInstance.currentLocation?.coordinate)!)
                    self.placeMarker.map = self.googleMapView!
                    self.placeMarker.icon = UIImage(named: "NavigationMarker")
                    self.selectLocation = (LocationService.sharedInstance.currentLocation?.coordinate)!
                    self.reverseGeocodeCoordinate(coordinate: (LocationService.sharedInstance.currentLocation?.coordinate)!)
                    if self.isLocationSelectedToStopUpdates == false{
                        self.sendRequestToGetEquipmentDetails(self.isFilterApply)
                    }
                    self.registerFirebaseEvents(FSR_CurrentLocation, "", "", "", parameters: nil)
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.topView?.isHidden = false
        self.hideCartButton(false)
        self.hideResetButton(true)
        self.hideFilterButton(false)
        self.lblTitle?.text = NSLocalizedString("requester", comment: "")
        if isFromHome == false {
            self.backButton?.setImage(UIImage(named: "Menu"), for: .normal)
        }
    }
    
    override func backButtonClick(_ sender: UIButton) {
        if isFromHome == true {
             let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                              self.navigationController?.pushViewController(toSelectPayVC!, animated: false)
        }else if isFromDeeplink == true {
                let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                    self.navigationController?.pushViewController(toSelectPayVC!, animated: false)
        }else if isFromBookingStages == true {
            let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "SprayServicesStagesViewController") as? SprayServicesStagesViewController
            toSelectPayVC?.isFromRequestor = true
                self.navigationController?.pushViewController(toSelectPayVC!, animated: false)
        }
            
        else{
            self.findHamburguerViewController()?.showMenuViewController()
        }
    }
    
    override func filterButtonClick(_ sender: UIButton) {
        
        let toFilterVC = self.storyboard?.instantiateViewController(withIdentifier: "FilterDetailsViewController") as! FilterDetailsViewController
        toFilterVC.getLocationCoordinate = self.selectLocation
        toFilterVC.getLocationAddress = self.lblSelectedLocation?.text
        toFilterVC.filterDetailsHandler = {(dataDict, isFromFilterVC) in
            //print(dataDict)
            //print(isFromFilterVC)
            if isFromFilterVC == true{
                self.isFilterApply = true
                self.selectLocation = CLLocationCoordinate2D(latitude: dataDict["latitude"] as! CLLocationDegrees, longitude: dataDict["longitude"] as! CLLocationDegrees)
                DispatchQueue.main.async {
                    self.googleMapView?.camera = GMSCameraPosition.camera(withTarget: self.selectLocation!, zoom: 17)
                    self.placeMarker = GMSMarker(position: self.selectLocation!)
                    self.placeMarker.map = self.googleMapView!
                    self.placeMarker.icon = UIImage(named: "NavigationMarker")
                }
                //self.googleMapView?.settings.consumesGesturesInView = true
                self.geocoder.reverseGeocodeCoordinate(self.selectLocation!) { response, error in
                    if let address = response?.firstResult() {
                        DispatchQueue.main.async {
                            let lines = address.lines
                            self.lblSelectedLocation?.text = lines?.joined(separator: ",")
                            self.lblSelectedLocation?.sizeToFit()
                            self.view.layoutIfNeeded()
                            self.view.updateConstraintsIfNeeded()
                        }
                    }
                }
                
                let net = NetworkReachabilityManager(host: "www.google.com")
                if net?.isReachable == true{
                    let parameters = dataDict as NSDictionary
                    let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
                    let params =  ["data" : paramsStr]
                    print(params)
                    //self.requestToGetEquipmentDetails(equipmentParams:params as [String:String])
                    self.sendRequestToGetEquipmentDetails(self.isFilterApply)
                }
                else{
                    self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                }
            }
            else{
                self.isFilterApply = false
                self.sendRequestToGetEquipmentDetails(self.isFilterApply)
            }

        }
        self.navigationController?.pushViewController(toFilterVC, animated: true)
    }
    @IBAction func nearByListButtonClick(_ sender: UIButton) {
        if arrEquipmentList.count > 0{
            self.registerFirebaseEvents(FSR_ShowList, "", "", "", parameters: nil)
            let nearbyEquipListController = self.storyboard?.instantiateViewController(withIdentifier: "NearByEquipmentsViewController") as? NearByEquipmentsViewController
            nearbyEquipListController?.arrEquipments = arrEquipmentList
            nearbyEquipListController?.cropID = cropID
            nearbyEquipListController?.isFromBookingStages = self.isFromBookingStages
            let navController = UINavigationController(rootViewController: nearbyEquipListController!)
            self.navigationController?.present(navController, animated: true, completion: nil)
        }
        else{
            self.view.makeToast(No_Equipment_Available)
        }
    }
    override func cartButtonClick(_ sender: UIButton) {
        let requesterOrdersController = self.storyboard?.instantiateViewController(withIdentifier: "RequesterOrdersViewController") as? RequesterOrdersViewController
        self.lblMyOrdersCount?.text = ""
        self.lblMyOrdersCount?.isHidden = true
        self.navigationController?.pushViewController(requesterOrdersController!, animated: true)
    }
    @IBAction func closeCustomInfoWindow(_ sender: UIButton){
        self.googleMapView?.selectedMarker = nil
        if self.customInfoView != nil{
            self.customInfoView?.removeFromSuperview()
            self.customInfoView = nil
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - GMUClusterManagerDelegate
    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,zoom: self.googleMapView!.camera.zoom + 0.5)
        let update = GMSCameraUpdate.setCamera(newCamera)
        self.googleMapView!.moveCamera(update)
        return false
    }
    private func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) {
        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,zoom: self.googleMapView!.camera.zoom + 0.5)
        let update = GMSCameraUpdate.setCamera(newCamera)
        self.googleMapView!.moveCamera(update)
    }
    // MARK: - GMUClusterManager Render Delegate

    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        if customInfoView != nil{
            customInfoView?.removeFromSuperview()
            customInfoView = nil
        }
        if self.selectedMarker != nil{
            self.selectedMarker?.map = nil
            self.selectedMarker = nil
        }
    }
    //MARK: Google MapView Delegate Methods
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {

        if selectedMarker != nil && customInfoView != nil{
            if renderer?.markers.contains(selectedMarker!) == true {
                
            }
        }
        else{
            if customInfoView != nil{
                customInfoView?.removeFromSuperview()
                customInfoView = nil
            }
        }
    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        //reverseGeocodeCoordinate(coordinate: position.target)
        if selectedMarker != nil {
            let position = selectedMarker?.position
            customInfoView?.center = mapView.projection.point(for: position!)
            if let iconView = selectedMarker?.iconView as UIView?{
                customInfoView?.center.y -= iconView.frame.size.height+83
            }
            else{
                customInfoView?.center.y -= 100
            }
        }
        else{
            if self.customInfoView != nil{
                self.customInfoView?.removeFromSuperview()
            }
            self.customInfoView = nil
        }
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        //reverseGeocodeCoordinate(coordinate: coordinate)
        customInfoView?.removeFromSuperview()
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let poiItem = marker.userData as? POIItem {
            if poiItem.equipmentObj != nil {
                if self.customInfoView != nil{
                    self.customInfoView?.removeFromSuperview()
                }
                self.customInfoView = nil
                if selectedMarker != nil {
                    if marker.isEqual(selectedMarker) {
                        if self.customInfoView != nil{
                            self.customInfoView?.removeFromSuperview()
                            self.customInfoView = nil
                        }
                        else{
                            selectedMarker = marker
                            self.createCustomEquipmentInfoPopupView(equipment: poiItem.equipmentObj)
                        }
                    }
                    else{
                        selectedMarker = marker
                        self.createCustomEquipmentInfoPopupView(equipment: poiItem.equipmentObj)
                    }

                }
                else{
                    selectedMarker = marker
                    self.createCustomEquipmentInfoPopupView(equipment: poiItem.equipmentObj)
                }
                //get position of tapped marker
                let position = marker.position
                mapView.animate(toLocation: position)
                let point = mapView.projection.point(for: position)
                let newPoint = mapView.projection.coordinate(for: point)
                let camera = GMSCameraUpdate.setTarget(newPoint)
                mapView.animate(with: camera)
                if customInfoView != nil && selectedMarker != nil{
                    customInfoView?.center = mapView.projection.point(for: position)
                    if let iconView = marker.iconView as UIView?{
                        customInfoView?.center.y -= iconView.frame.size.height+83
                    }
                    else{
                        customInfoView?.center.y -= 100
                    }
                    self.googleMapView?.addSubview(customInfoView!)
                }
            }
            NSLog("Did tap marker for cluster item")
        } else {
            NSLog("Did tap a normal marker")
        }
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        //reverseGeocodeCoordinate(coordinate: marker.position)
    }
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        //reverseGeocodeCoordinate(coordinate: marker.position)
    }
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
        //reverseGeocodeCoordinate(coordinate: location)
    }
    // MARK: Needed to create the custom info window
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        /*if let poiItem = marker.userData as? POIItem {
            if poiItem.equipmentObj != nil {
                if let equipment = poiItem.equipmentObj as? Equipment {
                    self.createCustomEquipmentInfoPopupView(equipment: equipment)
                    if self.customInfoView != nil{
                        return self.customInfoView
                    }
                    else{
                        UIView()
                    }
                }
            }
            NSLog("Did tap marker for cluster item")
        }
        else {
            NSLog("Did tap a normal marker")
        }*/

        return UIView()
    }
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if let poiItem = marker.userData as? POIItem {
            if poiItem.equipmentObj != nil {
                let userObj = Constatnts.getUserObject()
                let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber,USER_ID:userObj.customerId,EQUIPMENT_ID:poiItem.equipmentObj?.equipmentId!]
                self.registerFirebaseEvents(PV_FSR_View_Equipment_Full_Details, "", "", "", parameters: fireBaseParams as NSDictionary)
                if Validations.isNullString((poiItem.equipmentObj?.equipmentId) ?? "") == false{
                    let viewEquipmentController = self.storyboard?.instantiateViewController(withIdentifier: "ViewEquipmentViewController") as? ViewEquipmentViewController
                    //addEquipmentController?.isFromEdit = true
                    viewEquipmentController?.selectedEquipment = poiItem.equipmentObj
                    viewEquipmentController?.isFromRequester = true
                    viewEquipmentController?.cropId = cropID
                    self.navigationController?.pushViewController(viewEquipmentController!, animated: true)
                }
            }
        }
    }
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        
    }
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        return nil
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        print("Gesture",gestureRecognizer)
        if (gestureRecognizer is UITapGestureRecognizer && gestureRecognizer.state == UIGestureRecognizerState.ended) {
            return true
            
        } else {
            return false
            
        }
    }
    // MARK: Needed to create the custom info window
    func createCustomEquipmentInfoPopupView(equipment: Equipment?){
        if equipment != nil {
            let infoWindow = EquipmentInfoView.instanceFromNib()
            infoWindow.frame = CGRect(x: 0, y: 15, width: UIScreen.main.bounds.size.width - 30, height: 170)
            infoWindow.equipmentObj = equipment
            infoWindow.reloadInfoViewData()
            infoWindow.btnClose?.addTarget(self, action: #selector(RequesterViewController.closeCustomInfoWindow(_:)), for: .touchUpInside)
            infoWindow.isUserInteractionEnabled = true
            infoWindow.viewEquipmentDetailsHandler = nil
            let userObj = Constatnts.getUserObject()
            let fireBaseParams = [MOBILE_NUMBER: userObj.mobileNumber!,USER_ID: userObj.customerId,EQUIPMENT_ID:equipment?.equipmentId]
            self.registerFirebaseEvents(PV_FSR_View_Details_About_Equipment, "", "", "", parameters: fireBaseParams as NSDictionary)
            infoWindow.viewEquipmentDetailsHandler = {(equipment) in
                if equipment != nil{
                    if Validations.isNullString((equipment?.equipmentId) ?? "") == false{
                        let userObj = Constatnts.getUserObject()
                        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber,USER_ID:userObj.customerId,EQUIPMENT_ID:equipment?.equipmentId!]
                        self.registerFirebaseEvents(FSR_Equipment_Full_Details, "", "", "", parameters: fireBaseParams as NSDictionary)
                        let viewEquipmentController = self.storyboard?.instantiateViewController(withIdentifier: "ViewEquipmentViewController") as? ViewEquipmentViewController
                        //addEquipmentController?.isFromEdit = true
                        viewEquipmentController?.selectedEquipment = equipment
                        viewEquipmentController?.isFromRequester = true
                        viewEquipmentController?.cropId = self.cropID
                        self.navigationController?.pushViewController(viewEquipmentController!, animated: true)
                    }
                }
            }
            infoWindow.bookEquipmentHandler = nil
            infoWindow.bookEquipmentHandler = {(equipment) in
                if equipment?.equipmentClassificationId == "5" {
                if equipment?.sprayRequestDone == true && equipment?.billUploadDone == true {
                if equipment != nil{
                    if Validations.isNullString((equipment?.equipmentId) ?? "") == false{
                        let userObj = Constatnts.getUserObject()
                        let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber,USER_ID:userObj.customerId,EQUIPMENT_ID:equipment?.equipmentId!]
                        self.registerFirebaseEvents(FSR_Available_Date_selection, "", "", "", parameters: fireBaseParams as NSDictionary)
                        let bookNowController = self.storyboard?.instantiateViewController(withIdentifier: "BookNowViewController") as? BookNowViewController
                        bookNowController?.selectedEquipId = equipment!.equipmentId as String?
                        bookNowController?.isFromProvider = false
                        bookNowController?.isFromEditOrder = false
                        bookNowController?.cropId = self.cropID
                        self.navigationController?.pushViewController(bookNowController!, animated: true)
                    }
                }
                }else if !(equipment?.sprayRequestDone)! {
                    let notYetSubscribedMessage = NSLocalizedString("Not_yet_subscribe_to_Spray_servcies_message", comment: "")
                                  self.loginAlertView = CustomAlert.alertPopUpView(self, frame: self.view.frame, title: NSLocalizedString("alert", comment: "") as NSString, message: notYetSubscribedMessage as NSString, okButtonTitle: NSLocalizedString("Subscribe", comment: ""), cancelButtonTitle: NSLocalizedString("cancel", comment: "")) as! UIView
                                  self.view.addSubview(self.loginAlertView)
                    
//                    let alertController = UIAlertController(title: "Alert!", message: "You have not yet subscribe to Spray servcies. Please subscribe to avail.", preferredStyle: .alert)
                          
//                          let backButtonAction = UIAlertAction(title: "OK", style: .cancel, handler: {
//                              alert -> Void in
//                              let SprayServiceVC = self.storyboard?.instantiateViewController(withIdentifier: "SprayServiceViewController") as? SprayServiceViewController
//                              self.navigationController?.pushViewController(SprayServiceVC!, animated: true)
//                          })
//                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//                          alertController.addAction(backButtonAction)
//                         alertController.addAction(cancelAction)
//                          self.present(alertController, animated: true, completion: nil)
                     
                }else if !(equipment?.billUploadDone)! {
                    let notYetPuchasedMessage =  NSLocalizedString("Not_yet_done_purchase_register", comment: "")
                    self.loginAlertView = CustomAlert.alertNewPopView(self, frame: self.view.frame, title:NSLocalizedString("alert", comment: "") as NSString, message: notYetPuchasedMessage as NSString , okButtonTitle: NSLocalizedString("go_home", comment: ""), cancelButtonTitle: NSLocalizedString("cancel", comment: "")) as! UIView
                    self.view.addSubview(self.loginAlertView)
   
                    
                    
//                    let alertController = UIAlertController(title: "Alert!", message: "You are not yet done purchase register.Please go to home and genunity check to register", preferredStyle: .alert)
//                    
//                    let backButtonAction = UIAlertAction(title: "OK", style: .cancel, handler: {
//                        alert -> Void in
//                        let RetailerInformationVC = self.storyboard?.instantiateViewController(withIdentifier: "RetailerInformationViewController") as? RetailerInformationViewController
//                        self.navigationController?.pushViewController(RetailerInformationVC!, animated: true)
//                    })
//                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//                    alertController.addAction(backButtonAction)
//                    alertController.addAction(cancelAction)
//                    self.present(alertController, animated: true, completion: nil)

                }
                }else {
                    let userObj = Constatnts.getUserObject()
                               let fireBaseParams = [MOBILE_NUMBER:userObj.mobileNumber,USER_ID:userObj.customerId,EQUIPMENT_ID:equipment?.equipmentId!]
                               self.registerFirebaseEvents(FSR_Available_Date_selection, "", "", "", parameters: fireBaseParams as NSDictionary)
                               let bookNowController = self.storyboard?.instantiateViewController(withIdentifier: "BookNowViewController") as? BookNowViewController
                               bookNowController?.selectedEquipId = equipment!.equipmentId as String?
                               bookNowController?.isFromProvider = false
                               bookNowController?.isFromEditOrder = false
                               bookNowController?.cropId = self.cropID
                               self.navigationController?.pushViewController(bookNowController!, animated: true)
                }
            }
            //self.googleMapView?.bringSubview(toFront: infoWindow)
            self.customInfoView = infoWindow
        }
    }
    //MARK: popUpNoBtnAction
    @objc func popUpNoBtnAction(){
        loginAlertView.removeFromSuperview()
    }
    //MARK: popUpYesBtnAction

    @objc func popUpYesBtnAction(){
        loginAlertView.removeFromSuperview()
        let toSelectPayVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        self.navigationController?.pushViewController(toSelectPayVC!, animated: true)
       
    }
    @objc func alertYesBtnAction(){
            loginAlertView.removeFromSuperview()
        let SprayServiceVC = self.storyboard?.instantiateViewController(withIdentifier: "SprayServiceViewController") as? SprayServiceViewController
               self.navigationController?.pushViewController(SprayServiceVC!, animated: true)
    }
    
    //MARK: alertNoBtnAction
    /**
     NO button action of the alertView which is displayed to the user
        */
    @objc func alertNoBtnAction(){
        loginAlertView.removeFromSuperview()
    }

    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        // 1
        // 2
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let address = response?.firstResult() {
                // 3
                //print("Location \(address.coordinate)!)")
                let lines = address.lines
                self.selectLocation = coordinate
                self.lblSelectedLocation?.text = lines?.joined(separator: ",")
                //self.view.layoutIfNeeded()
                //self.view.updateConstraintsIfNeeded()
                // 4
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
