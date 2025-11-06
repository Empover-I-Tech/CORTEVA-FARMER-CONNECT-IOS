//
//  GoogleSearchViewController.swift
//  Yawo
//
//  Created by Admin on 09/01/17.
//  Copyright © 2017 Empover. All rights reserved.
//

import UIKit
import GooglePlaces
import MapKit
import GoogleMapsBase

class GoogleSearchViewController: BaseViewController,UISearchControllerDelegate {

    var addressCompletionBlock : ((_ selectedlocation : CLLocationCoordinate2D,_ address : String,_ isFromAddress: Bool,_ isFromHomeNav: Bool, _ coordinateBounds: GMSCoordinateBounds?) -> (Void))?
    var addressCancelationBlock : (() -> (Void))?

    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var searchLocation: CLLocationCoordinate2D?
    var isFromAddress : Bool = false
    var isToAddress : Bool = false
    var isFromHomeNavigation : Bool = false
    var searchBarPlaceHolder = "Search"
    var searchBounds : GMSCoordinateBounds?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        resultsViewController = GMSAutocompleteResultsViewController()
        //let filter = GMSAutocompleteFilter()
        //filter.type = .geocode  //suitable filter type
        //filter.country = "IN"  //appropriate country code
        //resultsViewController?.autocompleteFilter = filter
        if Validations.checkUserEnabledLocationServiceOrNot(viewController: self as UIViewController,showAlert: false) == true{
            //AppDelegate.previousSearchLocation = nil
        }
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        if Validations.checkUserEnabledLocationServiceOrNot(viewController: self as UIViewController,showAlert: false) == false{
            if Validations.checkUserEnabledLocationServiceOrNot(viewController: self as UIViewController,showAlert: true) == true{
                if LocationService.sharedInstance.currentLocation?.coordinate != nil{
                    center  = (LocationService.sharedInstance.currentLocation?.coordinate)!
                }
            }
        }
        else if Validations.checkUserEnabledLocationServiceOrNot(viewController: self as UIViewController,showAlert: false) == true{
            if Validations.checkUserEnabledLocationServiceOrNot(viewController: self as UIViewController,showAlert: true) == true{
                if LocationService.sharedInstance.currentLocation?.coordinate != nil{
                    center  = (LocationService.sharedInstance.currentLocation?.coordinate)!
                }
            }
        }
        else{
            /*if AppDelegate.previousSearchLocation != nil {
                center = AppDelegate.previousSearchLocation!
            }*/
        }
        let radius : CGFloat = sqrt(2.0)*1000; //radius in meters (25km)
        let region :MKCoordinateRegion  = MKCoordinateRegionMakeWithDistance(center, Double(radius ), Double(radius))
        
        let  northEast : CLLocationCoordinate2D = CLLocationCoordinate2DMake(region.center.latitude - region.span.latitudeDelta/2, region.center.longitude - region.span.longitudeDelta/2);
        let  southWest : CLLocationCoordinate2D = CLLocationCoordinate2DMake(region.center.latitude + region.span.latitudeDelta/2, region.center.longitude + region.span.longitudeDelta/2);
        //let northEast = CLLocationCoordinate2D(latitude: 17.4474,longitude: 78.3762)
        //let southWest = CLLocationCoordinate2D(latitude: 17.4474,longitude: 78.3762)
        let coordinateBounds = GMSCoordinateBounds(coordinate: southWest, coordinate: northEast);
        print("South Bounds \(southWest)")
        print("Nort Bounds \(northEast)")

        self.searchBounds = coordinateBounds
        if searchBounds != nil{
           // resultsViewController?.autocompleteBounds = searchBounds
        }
        //resultsViewController?.autocompleteFilter?.type = .region
        //resultsViewController?.autocompleteFilter?.country = "IN"
        resultsViewController?.delegate = self
        searchController?.isActive = true
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchController?.searchBar.placeholder = searchBarPlaceHolder
        searchController?.searchBar.searchBarStyle = .minimal
        searchController?.searchBar.tintColor = UIColor.white
        searchController?.searchBar.showsCancelButton = false
        searchController?.searchBar.backgroundColor = UIColor.clear
        //searchController?.searchBar.textField?.backgroundColor = UIColor.white
        
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        /*var bounds: CGRect = searchController!.searchBar.textField!.frame
        bounds.origin.y = 0
        bounds.size.height = 35 //(set height whatever you want)
        searchController!.searchBar.textField!.bounds = bounds
        searchController?.searchBar.textField?.tintColor = UIColor.white
        searchController?.searchBar.textField?.textColor = UIColor.white
        searchController!.searchBar.textField!.borderStyle = UITextBorderStyle.none
        searchController?.searchBar.textField?.font = UIFont(name: "Roboto-Regular", size:18)*/
        if let textField = searchController?.searchBar.value(forKey: "searchField") as? UITextField,let iconView = textField.leftView as? UIImageView {
            //iconView.image = UIImage(named: "Search")//iconView.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            //iconView.tintColor = UIColor.white
            //let imageView = UIImageView()
            let image = UIImage(named: "Search")
            iconView.image = image;
            iconView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            //textField.leftView = imageView
            textField.leftViewMode = UITextFieldViewMode.always
            textField.tintColor = UIColor.white
            textField.textColor = UIColor.white
            textField.backgroundColor = UIColor.clear
            textField.borderStyle = UITextBorderStyle.none
            var bounds: CGRect = textField.frame
            bounds.origin.y = 0
            bounds.size.height = 35
            textField.frame = bounds
            if let textFieldInsideSearchBarLabel = textField.value(forKey: "placeholderLabel") as? UILabel{
                textFieldInsideSearchBarLabel.textColor = UIColor.white
            }
        }
        //searchController?.searchBar.setImage(UIImage(named: "Search"), for: .search, state: .normal)

        //textField.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        //searchController!.searchBar.textField!.backgroundColor = UIColor.clear
        //searchController!.searchBar.textField!.setNeedsDisplay()
        searchController?.delegate = self

        //let roomInfoSearchBarFrame = searchController?.searchBar.frame
        let subView = UIView(frame: CGRect(x: 45, y: 0.0, width: self.view.frame.size.width - 50, height: 45.0))
        subView.backgroundColor = UIColor.clear
        subView.layer.cornerRadius = 3
        subView.layer.masksToBounds = true
        subView.addSubview((searchController?.searchBar)!)
        self.topView?.addSubview(subView)
        
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.topView?.isHidden = false
       
    }
    override func viewDidAppear(_ animated: Bool) {
        //super.viewDidAppear(true)
        if isFromAddress == true {
            //self.recordScreenView("GoogleSearchViewController", Home_Place_Search_Screen,screenId:Home_Place_Search_Screen_Id)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            //self.searchController?.searchBar.becomeFirstResponder()
            self.searchController?.searchBar.setShowsCancelButton(false, animated: true)
            //self.searchController?.searchBar.setImage(UIImage(named: "SearchbarSearch"), for: .search, state: .normal)
        }
    }
    override func backButtonClick(_ sender: UIButton) {
        searchController?.dismiss(animated: true, completion: nil)
        if addressCancelationBlock != nil {
            addressCancelationBlock!()
        }
        self.dismiss(animated: true, completion: nil)
        //self.dismiss(animated: true, completion: nil)
    }
    func willPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.setShowsCancelButton(false, animated: true)
        //searchController.searchBar.setImage(UIImage(named: "SearchbarSearch"), for: .search, state: .normal)
        searchController.searchBar.becomeFirstResponder()
    }
    func didPresentSearchController(_ searchController: UISearchController) {
        //searchController.searchBar.setShowsCancelButton(false, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            searchController.searchBar.becomeFirstResponder()
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
extension GoogleSearchViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        
        /*var address = ""
        address = place.name
        if Validations.isNullString(address as NSString) == false {
            address = String(format: "%@, %@", address,place.formattedAddress!)
        }
        else{
            address = place.formattedAddress!
        }*/
        //lblSelectedLocation.text = place.formattedAddress
        searchLocation = place.coordinate
        if Validations.checkUserEnabledLocationServiceOrNot(viewController: self as UIViewController,showAlert: false) == false {
            //AppDelegate.previousSearchLocation = searchLocation
        }
        if addressCompletionBlock != nil {
            if isFromHomeNavigation == true {
                addressCompletionBlock!(place.coordinate,place.formattedAddress!,true,isFromHomeNavigation,place.viewport ?? nil)
            }
            else if isFromAddress == true {
                addressCompletionBlock!(place.coordinate,place.formattedAddress!,true,isFromHomeNavigation,place.viewport ?? nil)
            }
            else{
                addressCompletionBlock!(place.coordinate,place.formattedAddress!,false,isFromHomeNavigation,place.viewport ?? nil)
            }
        }
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        searchController?.searchBar.showsCancelButton = false
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
