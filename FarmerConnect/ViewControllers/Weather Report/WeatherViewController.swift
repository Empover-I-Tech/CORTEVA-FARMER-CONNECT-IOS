//
//  ViewController.swift
//  Weather Plugin
//
//  Created by Admin on 08/08/17.
//  Copyright © 2017 Empover. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

extension UIImageView {
    func downloadImageFrom(link:String, contentMode: UIViewContentMode) {
        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
}

var Base_Url =  "http://api.openweathermap.org/data/2.5/"
var Weather_Image_Url = "http://openweathermap.org/img/w/"
var APP_ID = "7574fa662db029239e9cac49a769aa83"
var ThreeHoursForecastWeatherRequest = "forecast?lat=%@&lon=%@&APPID=%@"

class WeatherViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate,LocationServiceDelegate {

    @IBOutlet weak var lblCurrentDayTemp: UILabel!
    @IBOutlet weak var lblCurrentLocation: UILabel!
    @IBOutlet weak var lblCurrentDayTempReport1: UILabel!
    @IBOutlet weak var lblCurrentDayTempReport2: VerticalAlignLabel!
    @IBOutlet weak var lblCurrentDayTempRange: UILabel!
    @IBOutlet weak var lblCurrentDaySunriseTime: UILabel!
    @IBOutlet weak var lblCurrentDaySunsetTime: UILabel!
    @IBOutlet weak var lblCurrentDayHumidity: UILabel!
    @IBOutlet weak var imgCurrentDayWeather: UIImageView!
    @IBOutlet weak var tblForecastWeather: UITableView!

    var todayWeatherRequest = "weather?lat=%@&lon=%@&APPID=%@"
    var forecastWeatherRequest = "forecast/daily?lat=%@&lon=%@&cnt=6&APPID=%@"
    let locationService : LocationService = LocationService()
    var featureDaysArray = NSMutableArray()
    var isFromHome : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        tblForecastWeather.tableFooterView = UIView()
        
        tblForecastWeather.separatorInset = UIEdgeInsets.zero
                
        //using attributed string to get degree symbol
        //  let myString = "30"+"\u{00b0}"
        //  let myAttribute = [NSForegroundColorAttributeName: UIColor.white,  NSFontAttributeName: UIFont(name: "Helvetica", size: 65.0)!]
        //  let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
        
        /*lblCurrentDayTemp.adjustsFontSizeToFitWidth = true
        lblCurrentDayTemp.text = "30"+"\u{00b0}"
        lblCurrentDayTempRange.text = "29"+" ~ "+"31"+"\u{00b0}"
        lblCurrentDaySunriseTime.text = "05:10 AM"
        lblCurrentDaySunsetTime.text = "06:10 PM"
        lblCurrentDayHumidity.text = "70%"*/
        //self.refreshTodayWeatherData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        lblTitle?.text = NSLocalizedString("weather_report", comment: "") //"Weather Report"
       self.isFromHome = (UserDefaults.standard.value(forKey: "isFromHome") as? Bool)!
       if isFromHome == false {
           self.backButton?.setImage(UIImage(named: "Menu"), for: .normal)
       }else {
            self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
       }
        self.refreshTodayWeatherData()
        self.recordScreenView("WeatherViewController", Weather_Report)
        self.registerFirebaseEvents(PV_Weather_Day_wise_Report, "", "", "", parameters: nil)
    }
    
    override func backButtonClick(_ sender: UIButton) {
        if isFromHome == true {
            self.navigationController?.popViewController(animated: true)
        }else {
            self.findHamburguerViewController()?.showMenuViewController()
        }
        
    }
    
    func refreshTodayWeatherData(){
        if let prevLocation = CLLocationManager().location as CLLocation?{
            self.getCurrentDayWeatherReportServiceCall(String(format : "%f",prevLocation.coordinate.latitude), String(format : "%f",prevLocation.coordinate.longitude))
            self.getForecastDayWeatherReportServiceCall(String(format : "%f",prevLocation.coordinate.latitude), String(format : "%f",prevLocation.coordinate.longitude))
        }
        if (!CLLocationManager.locationServicesEnabled() || CLLocationManager.authorizationStatus() == .denied)
        {
            let alert : UIAlertController = UIAlertController(title: "Location access", message: "In order to be notified, please open this app's settings and enable location access", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(url as URL)
                }
            }
            alert.addAction(openAction)
            self.present(alert, animated: true, completion: nil)
        }
        else{
            locationService.delegate = self
            locationService.locationManager?.requestLocation()
            guard let currentLocation = LocationService.sharedInstance.currentLocation?.coordinate else {
                return
            }
            self.getCurrentDayWeatherReportServiceCall(String(format : "%f",currentLocation.latitude), String(format : "%f",currentLocation.longitude))
            self.getForecastDayWeatherReportServiceCall(String(format : "%f",currentLocation.latitude), String(format : "%f",currentLocation.longitude))
        }
    }
    
    func getCurrentDayWeatherReportServiceCall(_ latitude: String?, _ longitude:String?){
        SwiftLoader.show(animated: true)
        let currentDayTempUrl = String(format: "%@%@", Base_Url,String(format: todayWeatherRequest, latitude ?? 0.0, longitude ?? 0.0, APP_ID))
        Alamofire.request(currentDayTempUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
           SwiftLoader.hide()
           // print("Result:\(String(describing: response.result.value))")
            let responseDic = response.result.value as? NSDictionary
            if response.result.error == nil{
                let todayWeather = Weather(dict: responseDic!)
                self.lblCurrentDayTemp.text =  String(format: "%@\u{00b0}", Constatnts.getTemparatureFromValue(tempDouble: todayWeather.currentTemparature))
               // print((todayWeather.currentTemparature ?? 0.0 - 273.15))
                self.lblCurrentLocation.text =  todayWeather.cityName as String!
                self.lblCurrentDayTempReport1.text = todayWeather.w_main as String!
                self.lblCurrentDayTempReport2.text = todayWeather.w_description as String!
                self.lblCurrentDayTempReport2.verticalAlignment = .top
                self.lblCurrentDaySunriseTime.text = ((todayWeather.sunriseTime)! * 1000).dateFromMilliseconds(format: "hh:mm a")
                self.lblCurrentDaySunsetTime.text = ((todayWeather.sunsetTime)! * 1000).dateFromMilliseconds(format: "hh:mm a")
                self.lblCurrentDayHumidity.text = String(format: "%d%%", todayWeather.humidity!)
                self.lblCurrentDayTempRange.text = String(format: "%@ ~ %@\u{00b0}",Constatnts.getTemparatureFromValue(tempDouble: todayWeather.minTemparature),Constatnts.getTemparatureFromValue(tempDouble: todayWeather.maxTemparature))
                let imageUrl = String(format: "%@%@.png", Weather_Image_Url,(todayWeather.w_icon)!)
                self.imgCurrentDayWeather.downloadImageFrom(link: imageUrl, contentMode: .scaleToFill)
            }
        }
    }
    
    func getForecastDayWeatherReportServiceCall(_ latitude: String?, _ longitude:String?){
        SwiftLoader.show(animated: true)
        let currentDayTempUrl = String(format: "%@%@", Base_Url,String(format: forecastWeatherRequest, latitude ?? 0.0, longitude ?? 0.0, APP_ID))
       // print(currentDayTempUrl)
        Alamofire.request(currentDayTempUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
          SwiftLoader.hide()
           // print("Result:\(String(describing: response.result.value))")
            let responseDic = response.result.value as? NSDictionary
            if response.result.error == nil{
                if let dayListArray = Validations.checkKeyNotAvailForArray(responseDic!, key: "list") as? NSArray{
                    if dayListArray.count > 1{
                        self.featureDaysArray.removeAllObjects()
                        if let todayWeatherDic = dayListArray.object(at: 0) as? NSDictionary{
                            let todayWeather = Weather(dict: todayWeatherDic)
                            self.lblCurrentDayTempRange.text = String(format: "%@ ~ %@\u{00b0}",Constatnts.getTemparatureFromValue(tempDouble: todayWeather.minTemparature),Constatnts.getTemparatureFromValue(tempDouble: todayWeather.maxTemparature))
                        }
                        for index in 1..<dayListArray.count{
                            if let weatherDic =  dayListArray.object(at: index) as? NSDictionary{
                                let nextDayWeather = Weather(dict: weatherDic)
                                self.featureDaysArray.add(nextDayWeather)
                            }
                        }
                    }
                }
            }
            self.tblForecastWeather.reloadData()
        }
    }

    //MARK: tableView dataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return featureDaysArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "WeatherCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        //cell.layer.backgroundColor = UIColor.clear.cgColor
        let nextDayWeather = featureDaysArray.object(at: indexPath.row) as? Weather
        let lblDate : UILabel = cell.viewWithTag(100) as! UILabel
        let lblRainFall : UILabel = cell.viewWithTag(102) as! UILabel
        let lblTemparatureRange : UILabel = cell.viewWithTag(103) as! UILabel
        let imgWeather : UIImageView = cell.viewWithTag(101) as! UIImageView
        let imageUrl = String(format: "%@%@.png", Weather_Image_Url,(nextDayWeather?.w_icon)!)
        imgWeather.downloadImageFrom(link: imageUrl, contentMode: .scaleToFill)
        lblDate.text = ((nextDayWeather?.date ?? 0) * 1000).dateFromMilliseconds(format: "EEE dd MMM")
        lblRainFall.text = nextDayWeather?.w_main as String!
        lblTemparatureRange.text = String(format: "%@ ~ %@\u{00b0}",Constatnts.getTemparatureFromValue(tempDouble: nextDayWeather?.minTemparature),Constatnts.getTemparatureFromValue(tempDouble: nextDayWeather?.maxTemparature))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(white: 0.0, alpha: 0.65)
        
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 10, width: tableView.bounds.size.width - 10, height: 26))
        headerLabel.font = UIFont(name: "Helvetica Neue", size: 22)
        headerLabel.textColor = UIColor.white
        headerLabel.text = NSLocalizedString("muti", comment: "")  //"Multi-day forecast"
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    //MARK- tableView delegate methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: Location service delegate methods
    func tracingLocation(_ currentLocation: CLLocation) {
        self.getCurrentDayWeatherReportServiceCall(String(format : "%f",currentLocation.coordinate.latitude), String(format : "%f",currentLocation.coordinate.longitude))
        self.getForecastDayWeatherReportServiceCall(String(format : "%f",currentLocation.coordinate.latitude), String(format : "%f",currentLocation.coordinate.longitude))
        locationService.stopUpdatingLocation()
    }
    
    func tracingLocationDidFailWithError(_ error: NSError) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

public class VerticalAlignLabel: UILabel {
    enum VerticalAlignment {
        case top
        case middle
        case bottom
    }
    
    var verticalAlignment : VerticalAlignment = .top {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public func textRect(forBounds bounds: CGRect, limitedToNumberOfLines: Int) -> CGRect {
        let rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: limitedToNumberOfLines)
        if UIView.userInterfaceLayoutDirection(for: .unspecified) == .rightToLeft {
            switch verticalAlignment {
            case .top:
                return CGRect(x: self.bounds.size.width - rect.size.width, y: bounds.origin.y, width: rect.size.width, height: rect.size.height)
            case .middle:
                return CGRect(x: self.bounds.size.width - rect.size.width, y: bounds.origin.y + (bounds.size.height - rect.size.height) / 2, width: rect.size.width, height: rect.size.height)
            case .bottom:
                return CGRect(x: self.bounds.size.width - rect.size.width, y: bounds.origin.y + (bounds.size.height - rect.size.height), width: rect.size.width, height: rect.size.height)
            }
        }
        else {
            switch verticalAlignment {
            case .top:
                return CGRect(x: bounds.origin.x, y: bounds.origin.y, width: rect.size.width, height: rect.size.height)
            case .middle:
                return CGRect(x: bounds.origin.x, y: bounds.origin.y + (bounds.size.height - rect.size.height) / 2, width: rect.size.width, height: rect.size.height)
            case .bottom:
                return CGRect(x: bounds.origin.x, y: bounds.origin.y + (bounds.size.height - rect.size.height), width: rect.size.width, height: rect.size.height)
            }
        }
    }
}
