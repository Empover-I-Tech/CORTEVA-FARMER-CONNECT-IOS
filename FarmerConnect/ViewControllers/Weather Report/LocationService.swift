//
//  LocationService.swift
//
//
//  Created by Anak Mirasing on 5/18/2558 BE.
//
//

import Foundation
import CoreLocation
import GoogleMaps
import GooglePlaces

protocol LocationServiceDelegate {
    func tracingLocation(_ currentLocation: CLLocation)
    func tracingLocationDidFailWithError(_ error: NSError)
}

class LocationService: NSObject, CLLocationManagerDelegate {
    
    /*private static var __once: () = {
            static.instance = LocationService()
        }()
    
    class var sharedInstance: LocationService {
        struct Static {
            static var onceToken: Int = 0
            
            static var instance: LocationService? = nil
        }
        _ = LocationService.__once
        return Static.instance!
    }*/
    class var sharedInstance: LocationService {
        struct Static {
            static let instance: LocationService = LocationService()
        }
        return Static.instance
    }
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var delegate: LocationServiceDelegate?
    var currentAddress : NSString?
    let geocoder = GMSGeocoder()

    override init() {
        super.init()

        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else {
            return
        }
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            // you have 2 choice 
            // 1. requestAlwaysAuthorization
            // 2. requestWhenInUseAuthorization
            //locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // The accuracy of the location data
        locationManager.distanceFilter = 50 // The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
        locationManager.delegate = self
    }
    func updateCurrenteAddress(_ location: CLLocation?){
        if location != nil{
            geocoder.reverseGeocodeCoordinate((location?.coordinate)!) { response, error in
                if let address = response?.firstResult() {
                    let lines = address.lines
                    self.currentAddress = lines?.joined(separator: ",") as NSString!
                }
            }
        }
        else{
            if let coordinate = CLLocationManager().location?.coordinate as CLLocationCoordinate2D?{
                geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
                    if let address = response?.firstResult() {
                        let lines = address.lines
                        self.currentAddress = lines?.joined(separator: ",") as NSString!
                    }
                }
            }
 
        }

    }
    func startUpdatingLocation() {
        self.locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        self.locationManager?.stopUpdatingLocation()
    }
    
    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        // singleton for get last(current) location
        self.currentLocation = location
        // use for real time update location
        //print("Updated Location \(location.coordinate)!)")
        updateLocation(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // do on error
        updateLocationDidFailWithError(error as NSError)
    }
    
    // Private function
    fileprivate func updateLocation(_ currentLocation: CLLocation){
        guard let delegate = self.delegate else {
            return
        }
        delegate.tracingLocation(currentLocation)
    }
    
    fileprivate func updateLocationDidFailWithError(_ error: NSError) {
        guard let delegate = self.delegate else {
            return
        }
        delegate.tracingLocationDidFailWithError(error)
    }
}
