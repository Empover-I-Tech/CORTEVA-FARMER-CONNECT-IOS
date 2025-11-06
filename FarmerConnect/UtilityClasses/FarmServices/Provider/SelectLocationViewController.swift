//
//  SelectLocationViewController.swift
//  Yawo
//
//  Created by Admin on 26/12/16.
//  Copyright © 2016 Empover. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import Firebase

extension UISearchBar {
    var textField: UITextField? {
        
        func findInView(_ view: UIView) -> UITextField? {
            for subview in view.subviews {
                print("checking \(subview)")
                if let textField = subview as? UITextField {
                    return textField
                }
                else if let v = findInView(subview) {
                    return v
                }
            }
            return nil
        }
        
        return findInView(self)
    }
}

class SelectLocationViewController: BaseViewController, GMSMapViewDelegate {

    var addressCompletionBlock : ((_ selectedlocation : CLLocationCoordinate2D,_ address : String,_ postalCode : String,_ isFromAddress: Bool,_ isFromHomeNav: Bool) -> (Void))?
    var addressCancelationBlock : (() -> (Void))?
    
    @IBOutlet var googleMapView : GMSMapView?
    @IBOutlet var  lblLocation : UILabel?
    @IBOutlet var  lblSelectedLocation : UILabel?
    @IBOutlet var btnNext : UIButton?
    @IBOutlet var  viewselectLocation : UIView?
    @IBOutlet var  selectLocationHeightConstraint : NSLayoutConstraint?
    var isChangedPosition = false

    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var selectLocation: CLLocationCoordinate2D?
    var currentLocation : CLLocationCoordinate2D?
    var closeWhite = UIButton()
    var placeMarker = GMSMarker()
    let geocoder = GMSGeocoder()
    let imgLocationAnimation = UIImageView()
    var isFromPublishStory : Bool = false
    var strPostalCode : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.lblTitle?.text = NSLocalizedString("select_location", comment: "")
        googleMapView?.isUserInteractionEnabled = true
        googleMapView?.delegate = self
        currentLocation = LocationService.sharedInstance.currentLocation?.coordinate
        if self.selectLocation == nil{
            if Validations.checkUserEnabledLocationServiceOrNot(viewController: self as UIViewController,showAlert: true) == true{
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
        DispatchQueue.main.async {
            if self.selectLocation != nil{
                self.googleMapView?.camera = GMSCameraPosition.camera(withTarget: self.selectLocation!, zoom: 17)
                self.placeMarker = GMSMarker(position: self.selectLocation!)
                self.placeMarker.map = self.googleMapView!
                self.placeMarker.icon = UIImage(named: "NavigationMarker")
            }
        }
        googleMapView?.settings.consumesGesturesInView = false;
        if self.selectLocation != nil{
            self.geocoder.reverseGeocodeCoordinate(self.selectLocation!) { response, error in
                if let address = response?.firstResult() {
                    DispatchQueue.main.async {
                        let lines = address.lines
                        self.strPostalCode = address.postalCode
                        self.lblSelectedLocation?.text = lines?.joined(separator: ",")
                        self.lblSelectedLocation?.sizeToFit()
                        self.selectLocationHeightConstraint?.constant = 30 + (self.lblSelectedLocation?.frame.size.height)! + 5
                        self.view.layoutIfNeeded()
                        self.view.updateConstraintsIfNeeded()
                    }
                }
            }
        }


        /*resultsViewController = GMSAutocompleteResultsViewController()
        //resultsViewController?.autocompleteFilter?.type = .establishment
        resultsViewController?.autocompleteFilter?.country = "IN"
        resultsViewController?.autocompleteFilter?.type = .region
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchController?.searchBar.placeholder = "Selected location"
        searchController?.searchBar.searchBarStyle = .minimal
        searchController?.searchBar.backgroundColor = UIColor.white
        //searchController?.searchBar.setSearchFieldBackgroundImage(UIImage(), for: .normal)
        searchController?.searchBar.textField?.backgroundColor = UIColor.white
        
        //let roomInfoSearchBarFrame = searchController?.searchBar.frame
        let subView = UIView(frame: CGRect(x: 10, y: 95.0, width: self.view.frame.size.width - 20, height: 65.0))
        subView.backgroundColor = UIColor.white
        subView.layer.cornerRadius = 3
        subView.layer.masksToBounds = true
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        
        //searchController?.searchBar.contentins
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        var bounds: CGRect = searchController!.searchBar.textField!.frame
        bounds.origin.y = 0
        bounds.size.height = 35 //(set height whatever you want)
        searchController!.searchBar.textField!.bounds = bounds
        searchController!.searchBar.textField!.borderStyle = UITextBorderStyle.roundedRect
        //textField.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        searchController!.searchBar.textField!.backgroundColor = UIColor.white
        searchController!.searchBar.textField!.setNeedsDisplay()

        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true*/
        
        self.closeWhite = UIButton(type: .custom)
        self.closeWhite.frame = CGRect(x: self.view.frame.size.width - 38, y: 5, width: 35, height: 45)
        self.closeWhite.setImage(UIImage(named: "CloseWhite"), for: UIControlState())
        self.closeWhite.addTarget(self, action: #selector(SelectLocationViewController.exitButtonClick(_:)), for: .touchUpInside)
        topView?.addSubview(closeWhite)
        
        imgLocationAnimation.frame = CGRect(x: Int((self.view.frame.size.width - 25)/2), y: Int((self.view.frame.size.height - 80)/2), width: 25, height: 80)
        imgLocationAnimation.image = UIImage(named: "LocationAnimation")
        imgLocationAnimation.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 29)
        imgLocationAnimation.isHidden = true
        self.view.addSubview(imgLocationAnimation)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SelectLocationViewController.selectLocationSearchviewTapGesture(tapgesture:)))
        viewselectLocation?.addGestureRecognizer(tapGesture)
        
        let mapTapGesturerecognizer = UILongPressGestureRecognizer(target: self, action: #selector(SelectLocationViewController.mapViewSelectAnimationTapGesture(_:)))
        mapTapGesturerecognizer.minimumPressDuration = 0.0
        self.googleMapView?.addGestureRecognizer(mapTapGesturerecognizer)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.topView?.isHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    
    @objc func selectLocationSearchviewTapGesture(tapgesture: UITapGestureRecognizer){
        let addressSearchViewController = GoogleSearchViewController()
        addressSearchViewController.isFromAddress = true
        //var mapCenterPoint = imgLocationAnimation.center
        //mapCenterPoint.y = (mapCenterPoint.y) - 35
        addressSearchViewController.addressCompletionBlock = {(selectedlocation ,address,isFromAddress,fromHomeNav,viewBounds) in
            if Validations.isNullString(address as NSString) == false{
                //self.searchLocation = selectedlocation
                //self.searchTextField?.text = address
                self.dismiss(animated: true, completion: nil)
                self.lblSelectedLocation?.text = address
                self.lblSelectedLocation?.sizeToFit()
                self.selectLocationHeightConstraint?.constant = 30 + (self.lblSelectedLocation?.frame.size.height)! + 5
                self.view.layoutIfNeeded()
                self.view.updateConstraintsIfNeeded()
                self.selectLocation = selectedlocation
                DispatchQueue.main.async
                    {
                        self.googleMapView?.clear()
                        self.googleMapView?.camera = GMSCameraPosition.camera(withTarget: selectedlocation, zoom: 17)
                        self.placeMarker = GMSMarker(position: selectedlocation)
                        self.placeMarker.icon = UIImage(named: "NavigationMarker")
                        self.placeMarker.isDraggable = true
                        self.placeMarker.map = self.googleMapView!
                }
                //self.btnCurrentLocation?.isHidden = true
            }
        }
        let navController = UINavigationController(rootViewController: addressSearchViewController)
        navController.navigationBar.tintColor = self.navigationController?.navigationBar.tintColor
        navController.navigationBar.barTintColor = self.navigationController?.navigationBar.tintColor
        self.present(navController, animated: true, completion: nil)
    }

    @objc func mapViewSelectAnimationTapGesture(_ tapgesture: UILongPressGestureRecognizer){
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
                self.lblSelectedLocation?.sizeToFit()
                self.selectLocationHeightConstraint?.constant = 30 + (self.lblSelectedLocation?.frame.size.height)! + 5
                self.view.layoutIfNeeded()
                self.view.updateConstraintsIfNeeded()
                DispatchQueue.main.async
                    {
                        let zoomLevel : Float = (self.googleMapView?.camera.zoom)!
                        self.googleMapView?.clear()
                        self.googleMapView?.camera = GMSCameraPosition.camera(withTarget: centerLocation!, zoom: zoomLevel)
                        self.placeMarker = GMSMarker(position: centerLocation!)
                        self.placeMarker.icon = UIImage(named: "NavigationMarker")
                        self.placeMarker.isDraggable = true
                        self.placeMarker.map = self.googleMapView!
                }
                reverseGeocodeCoordinate(coordinate: centerLocation!)
                if isChangedPosition == false {
                    //self.placeMarker.icon = UIImage(named: "NavigationMarker")
                }
                isChangedPosition = false
            }
        }
    }
    @IBAction func exitButtonClick(_ sender: UIButton){
        self.present(Validations.showModalAlertView("Confirm?", "Do you want to exit?", cancelTitle: "No", okTitle: "Yes", cancelHandler: { (alertControl) in}, okHandler: { (alertControl) in
            _ = self.navigationController?.popViewController(animated: true)
        }), animated: true, completion: nil)

    }
    @IBAction func nextButtonClick(sender: UIButton){
        if selectLocation != nil && lblSelectedLocation?.text != "Getting Location..."{
            if addressCompletionBlock != nil && selectLocation != nil{
                addressCompletionBlock!(selectLocation!,(lblSelectedLocation?.text)!,strPostalCode ?? "0",true,false)
            }
            /*let createStoryView = self.storyboard?.instantiateViewController(withIdentifier: "CreateStoryViewController") as? CreateStoryViewController
            createStoryView?.selectLocation = selectLocation
            createStoryView?.storyAddress = lblSelectedLocation?.text
            self.navigationController?.pushViewController(createStoryView!, animated: true)*/
        }
        else{
            self.view.makeToast(Please_Select_Location)
        }
    }
    
    @IBAction func currentLocationButtonClick(sender: UIButton){
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
                }
            }
        }
    }
    
    @IBAction func zoomPlusAndMinusButtonClick(sender: UIButton){
        var zoomLevel : Float = (self.googleMapView?.camera.zoom)!
        if sender.tag == 1000 {
            if(zoomLevel < 22){
                zoomLevel = zoomLevel + 0.75
                self.googleMapView?.animate(toZoom: zoomLevel)
            }
        }
        else{
            if(zoomLevel > 1){
                zoomLevel = zoomLevel - 0.5
                self.googleMapView?.animate(toZoom: zoomLevel)
            }
        }
    }
    
    override func backButtonClick(_ sender: UIButton) {
        searchController?.dismiss(animated: true, completion: nil)
        if addressCancelationBlock != nil {
            addressCancelationBlock!()
        }
        self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)
    }
    //MARK: Google MapView Delegate Methods
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        //self.imgLocationAnimation.isHidden = true
        //reverseGeocodeCoordinate(coordinate: position.target)
    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        //reverseGeocodeCoordinate(coordinate: position.target)
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        //reverseGeocodeCoordinate(coordinate: coordinate)
    }
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        reverseGeocodeCoordinate(coordinate: marker.position)
    }
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        reverseGeocodeCoordinate(coordinate: marker.position)
    }
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
        reverseGeocodeCoordinate(coordinate: location)
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
                self.lblSelectedLocation?.sizeToFit()
                self.selectLocationHeightConstraint?.constant = 30 + (self.lblSelectedLocation?.frame.size.height)! + 5
                self.view.layoutIfNeeded()
                self.view.updateConstraintsIfNeeded()
                // 4
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

// Handle the user's selection.
extension SelectLocationViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        lblSelectedLocation?.text = place.formattedAddress
        selectLocation = place.coordinate
        DispatchQueue.main.async
            {
                self.googleMapView?.clear()
                self.googleMapView?.camera = GMSCameraPosition.camera(withTarget: place.coordinate, zoom: 14)
                self.placeMarker = GMSMarker(position: place.coordinate)
                self.placeMarker.icon = UIImage(named: "NavigationMarker")
                self.placeMarker.isDraggable = true
                self.placeMarker.map = self.googleMapView!
        }

    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
