//
//  FAW_FieldBoundaryViewController.swift
//  FarmerConnect
//
//  Created by EMPOVER-049 on 09/08/21.
//  Copyright © 2021 ABC. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation
let kEarthRadius = 6378137.0


//Step one
protocol AreaEntryDelegate: AnyObject {
    func getArea(_ text: String , hintText : String)
    func getAreaCoordinates(_ cordinates: NSMutableArray)
}

class FAW_FieldBoundaryViewController: BaseViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet var mapView : MKMapView!
    var locationManager : CLLocationManager?
    var arrLocations : [CLLocationCoordinate2D] = []
    let regionRadius: CLLocationDistance = 100
    var areaViewObj = BPHAlertsViewController()
    var areaViewObjSample = SampleTrackingDetailsViewController()
    weak var delegate: AreaEntryDelegate?
    var arrayLocations = NSMutableArray()
    var arrayLocationsTest = NSMutableArray()
    var isFromAreaValidation = false
    var txtFldChangesAlert : UIView?
    
    //MARK:- LOAD THE ARE ON VIEW POP NAVIGATION
    override func backButtonClick(_ sender: UIButton){
        let area = calculateAreaFromLatLongs()
        if area > 0.0{
            isFromAreaValidation = true
            self.txtFldChangesAlert = CustomAlert.alertPopUpView(self, frame: self.view.frame, title: "Alert!" as NSString, message: String(format: "You have captured some field boundaries data. Area is \(area). Do you want to Submit") as NSString, okButtonTitle: "YES", cancelButtonTitle: "NO") as? UIView
            self.view.addSubview(self.txtFldChangesAlert!)
            
        }else{
            sendDataBack()
            
        }
    }
    
    func sendDataBack(){
        let area = calculateAreaFromLatLongs()
        let hintString =  String(format: "%.3f",(area*0.000247105))
        let inKilomter = area ///1000
        let str = String(format: "%.3f",inKilomter)
        self.delegate?.getArea("\(str)" , hintText : hintString) //textPlateform.text ?? ""
        let arra = NSMutableArray()
      //  arra.addObjects(from: arrayLocations)
        self.delegate?.getAreaCoordinates(arrayLocations)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: alertYesBtnAction
    @objc func alertYesBtnAction(){
        if self.txtFldChangesAlert != nil {
            self.txtFldChangesAlert?.removeFromSuperview()
        }
        sendDataBack()
    }
    
    //MARK: alertNoBtnAction
    @objc func alertNoBtnAction(){
        isFromAreaValidation = false
        if txtFldChangesAlert != nil{
            txtFldChangesAlert?.removeFromSuperview()
            txtFldChangesAlert = nil
        }
        
    }
    
    
    //MARK:- Calulate Effected field area
    @IBAction func calculateAreaAndGoBack(_ sender: Any){
        let area = calculateAreaFromLatLongs()
        let k = distance(unit : "K")
        //  print("distance : \(k)")
        // self.view.makeToast("\(k)")
        let hintString =  String(format: "%.3f",(area*0.000247105))
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        //  appDelegate?.window?.makeToast("distance : in k : \(k), \(area)")
        print(area)//ARea in sq meters calculated
        
        let inKilomter = area ///1000
        let str = String(format: "%.3f",inKilomter)
        self.navigationController?.popViewController(animated: true)
        self.delegate?.getArea("\(str)" , hintText : hintString) //textPlateform.text ?? ""
        self.delegate?.getAreaCoordinates(arrayLocations)
        
    }
    
    func radians(degrees: Double) -> Double {
        return degrees * .pi / 180
    }
    
    func rad2deg(rad:Double) -> Double {
        return rad * 180.0 / M_PI
    }
    
    //MARK;- CALCULATE THE AREA IN SQUARE METERS
    func calculateAreaFromLatLongs() -> Double{
        guard arrLocations.count > 2 else { return 0 }
        var area = 0.0
        
        for i in 0..<arrLocations.count {
            let p1 = arrLocations[i > 0 ? i - 1 : arrLocations.count - 1]
            let p2 = arrLocations[i]
            
            area += radians(degrees: p2.longitude - p1.longitude) * (2 + sin(radians(degrees: p1.latitude)) + sin(radians(degrees: p2.latitude)) )
            // print("\(i) - \(area)")
        }
        
        area = -(area * kEarthRadius * kEarthRadius / 2)
        return max(area, -area) // In order not to worry about is polygon clockwise or counterclockwise defined.
        
    }
    
    /*Passed to function:                                                     ///
     ///    lat1, lon1 = Latitude and Longitude of point 1 (in decimal degrees)   ///
     ///    lat2, lon2 = Latitude and Longitude of point 2 (in decimal degrees)   ///
     ///    unit = the unit you desire for results                                ///
     ///           where: 'M' is statute miles (default)                          ///
     ///                  'K' is kilometers                                       ///
     ///                  'N' is nautical miles  */
    
    func distance( unit:String) -> Double {
        
        var area = 0.0
        guard arrLocations.count > 2 else { return 0 }
        
        for i in 0..<arrLocations.count {
            let p1 = arrLocations[i > 0 ? i - 1 : arrLocations.count - 1]
            let p2 = arrLocations[i]
            let theta = p1.longitude - p2.longitude
            
            
            area = sin(radians(degrees:  p1.latitude)) * sin(radians(degrees: p2.latitude)) + cos(radians(degrees: p1.latitude)) * cos(radians(degrees: p2.latitude)) * cos(radians(degrees: theta))
            area = acos(area)
            
            print("distance: area : \(area)")
            area = rad2deg(rad: area)
            print("rad2deg(rad: area): area : \(area)")
            area = area * 60 * 1.1515
            print("area * 60 * 1.1515 == area : \(area)")
            if (unit == "K") {
                area = area * 1.609344
            }
            else if (unit == "N") {
                area = area * 0.8684
            }
        }
        return area
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.lblTitle?.text = "Calculate Area"
        isFromAreaValidation = false
        // Do any additional setup after loading the view.
        arrayLocations = NSMutableArray()
        arrayLocationsTest = NSMutableArray()
        getUserCurrentLocation()
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType(rawValue: 0)!
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)! //followWithHeading
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // ---------------------------------//
    // MARK:- GET CURRENT LOACTION
    // ---------------------------------//
    func getUserCurrentLocation(){
        var geoLocation = ""
        if Validations.checkUserEnabledLocationServiceOrNot(viewController: self as UIViewController,showAlert: true) == true{
            if let currentLocation = LocationService.sharedInstance.currentLocation as CLLocation?{
                if let coordinates = currentLocation.coordinate as CLLocationCoordinate2D?{
                    geoLocation = String(format: "%f,%f", coordinates.latitude,coordinates.longitude)
                    arrLocations.append(CLLocationCoordinate2DMake(coordinates.latitude, coordinates.longitude))
                    let dateFormatter: DateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                    let  submittedDate = dateFormatter.string(from: Date())
                    let dic : NSDictionary = ["latitude" : "\(coordinates.latitude)" ,
                        "longitude" : "\(coordinates.longitude)" ,
                        "capturedTime" : submittedDate]
                    let dic1 : NSDictionary = ["latitude" : "\(coordinates.latitude)" ,
                        "longitude" : "\(coordinates.longitude)" ]
                    // arrayLocations.addObjects(from: [dic])
                    arrayLocations.add(dic)
                    arrayLocationsTest.add(dic1)
                    locationManager = CLLocationManager()
                    
                    //                    if #available(iOS 9.0, *)
                    //                           {
                    //                            self.locationManager?.allowsBackgroundLocationUpdates = true
                    //                           } else
                    //                           {
                    //                               // Fallback on earlier versions
                    //                           }
                    locationManager?.delegate = self
                    locationManager?.startUpdatingLocation()
                    locationManager?.distanceFilter = kCLDistanceFilterNone
                    
                    let status = CLLocationManager.authorizationStatus()
                    if status == .notDetermined || status == .denied || status == .authorizedWhenInUse {
                        // present an alert indicating location authorization required
                        // and offer to take the user to Settings for the app via
                        // UIApplication -openUrl: and UIApplicationOpenSettingsURLString
                        locationManager?.requestAlwaysAuthorization()
                        locationManager?.requestWhenInUseAuthorization()
                    }
                    locationManager?.startUpdatingLocation()
                    locationManager?.startUpdatingHeading()
                    addBoundry(locations: arrLocations)
                    
                    let initialLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
                    centerMapOnLocation(location: initialLocation)
                    
                }
            }
        }
    }
    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("New location is \(location)")
            
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
            let  submittedDate = dateFormatter.string(from: Date())
            
            let dic : NSDictionary = ["latitude" : "\(location.coordinate.latitude)" ,
                "longitude" : "\(location.coordinate.longitude)" ,
                "capturedTime" : submittedDate]
            
            let dic1 : NSDictionary = ["latitude" : "\(location.coordinate.latitude)" ,
                "longitude" : "\(location.coordinate.longitude)" ]
            
            if arrayLocationsTest.count>2 && arrayLocationsTest.contains(dic1){
                //  print("contains")
            }else{
                //   print("==== not contains ===========")
                arrLocations.append(CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude))
                arrayLocations.add(dic)
                arrayLocationsTest.add(dic1)
            }
            
            
            let initialLocation = CLLocation(latitude: arrLocations[0].latitude, longitude: arrLocations[0].longitude)
            let currentLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            // centerMapOnLocation(location: initialLocation)
            addBoundry(locations: arrLocations)
            
            if initialLocation == currentLocation{
                print("location matches : Stoped updating")
                locationManager?.stopUpdatingHeading()
                locationManager?.stopUpdatingLocation()
            }
        }
    }
    func addBoundry(locations: [CLLocationCoordinate2D])
    {
        
        let polygon = MKPolyline(coordinates: locations, count: locations.count)
        mapView.add(polygon)
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = .orange
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        } else if overlay is MKPolygon {
            let polygonView = MKPolygonRenderer(overlay: overlay)
            polygonView.fillColor = .magenta
            return polygonView
        }
        return MKPolylineRenderer(overlay: overlay)
    }
    
}


