//
//  HourlyForecastViewController.swift
//  Weather Plugin
//
//  Created by Admin on 14/08/17.
//  Copyright © 2017 Empover. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

extension UILabel {
    
    func sizeToFitHeight() {
        let maxHeight : CGFloat = CGFloat.greatestFiniteMagnitude
        let size = CGSize.init(width: self.frame.size.width, height: maxHeight)
        let rect = self.attributedText?.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil)
        var frame = self.frame
        frame.size.height = (rect?.size.height)!
        self.frame = frame
    }
}

class HourlyForecastViewController: UIViewController,LocationServiceDelegate,UITableViewDataSource,UITableViewDelegate,BEMSimpleLineGraphDataSource,BEMSimpleLineGraphDelegate {

    @IBOutlet weak var lblCurrentTemp: UILabel!
    @IBOutlet weak var lblCurrentLocation: UILabel!
    @IBOutlet weak var lblCurrentDayTempReport1: UILabel!
    @IBOutlet weak var lblCurrentDayTempReport2: UILabel!
    //@IBOutlet weak var lblCurrentDayTempRange: UILabel!
    @IBOutlet weak var lblCurrentDay: UILabel!
    @IBOutlet weak var lblCurrentDayHumidity: UILabel!
    @IBOutlet weak var imgCurrentDayWeather: UIImageView!
    @IBOutlet weak var tblHourlyForecast: UITableView!
    
    var todayWeatherRequest = "weather?lat=%@&lon=%@&APPID=%@"
    var forecastWeatherRequest = "forecast/daily?lat=%@&lon=%@&cnt=6&APPID=%@"
    let locationService : LocationService = LocationService()
    @IBOutlet var hourlyLineChart : BEMSimpleLineGraphView?
    var forecastHourlyDataArray = NSMutableArray()
    var filteredByDateArray = NSMutableArray()
    var daysArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hourlyLineChart?.backgroundColor = UIColor.clear
        let colorspace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let num_locations:size_t = 2
        let locations: [CGFloat] = [0.0, 1.0]
        let components: [CGFloat] = [
            1.0, 1.0, 1.0, 1.0,
            1.0, 1.0, 1.0, 0.0
        ]
        let gradient = CGGradient(colorSpace: colorspace, colorComponents: components, locations: locations, count: num_locations)
        //self.hourlyLineChart?.gradientBottom = gradient!
        
        // Enable and disable various graph properties and axis displays
        self.hourlyLineChart?.enableTouchReport = true;
        self.hourlyLineChart?.enablePopUpReport = false;
        self.hourlyLineChart?.enableYAxisLabel = false;
        self.hourlyLineChart?.autoScaleYAxis = true;
        self.hourlyLineChart?.alwaysDisplayDots = false;
        self.hourlyLineChart?.enableReferenceXAxisLines = true;
        self.hourlyLineChart?.enableReferenceYAxisLines = true;
        self.hourlyLineChart?.enableReferenceAxisFrame = true;
        
        // Draw an average line
        let color = UIColor(red: 31.0/255.0, green: 187.0/255.0, blue: 166.0/255.0, alpha: 1.0)
        self.hourlyLineChart?.colorTop = UIColor.clear//color;
        self.hourlyLineChart?.colorBottom = UIColor.clear//color;
        self.hourlyLineChart?.backgroundColor = UIColor.clear//color;
        //self.view.tintColor = color;

        // Enable and disable various graph properties and axis displays
        self.hourlyLineChart?.averageLine.alpha = 0.6;
        self.hourlyLineChart?.averageLine.color = UIColor.darkGray
        self.hourlyLineChart?.colorPoint = UIColor.red
        self.hourlyLineChart?.averageLine.width = 2.5;
        self.hourlyLineChart?.graphSpacing = 40;
        self.hourlyLineChart?.widthLine = 3.0;
        self.hourlyLineChart?.sizePoint = 15;
        self.hourlyLineChart?.averageLine.dashPattern = [(2),(2)]
        self.hourlyLineChart?.colorXaxisLabel = UIColor.white
        self.hourlyLineChart?.labelFont = UIFont.boldSystemFont(ofSize: 12.0)
        
        // Set the graph's animation style to draw, fade, or none
        self.hourlyLineChart?.animationGraphStyle = .draw;
        // Dash the y reference lines
        self.hourlyLineChart?.lineDashPatternForReferenceYAxisLines = [(2),(2)]
        
        // Show the y axis values with this format string
        self.hourlyLineChart?.formatStringForValues = "%.1f";
        // Setup initial curve selection segment
        //self.curveChoice.selectedSegmentIndex = self.hourlyLineChart.enableBezierCurve;
        
        // The labels to report the values of the graph when the user touches it
        //self.labelValues.text = [NSString stringWithFormat:@"%i", [[self.myGraph calculatePointValueSum] intValue]];
        //self.labelDates.text = @"between now and later";
        self.hourlyLineChart?.backgroundColor = UIColor.clear//self.hourlyLineChart?.colorBackgroundXaxis;
        tblHourlyForecast.tableFooterView = UIView()
        tblHourlyForecast.separatorInset = UIEdgeInsets.zero
        
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
        
        //self.hourlyLineChart = BEMSimpleLineGraphView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 200))
        //self.refreshHourlyForecastWeather()
        self.recordScreenView("HourlyForecastViewController", Weather_Report)
        self.registerFirebaseEvents(PV_Weather_Hourly_Report, "", "", "", parameters: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.refreshHourlyForecastWeather()
    }
    
    func refreshHourlyForecastWeather(){
        if let prevLocation = CLLocationManager().location as CLLocation?{
            self.getForecastThreeDaysHourlyWeatherReportServiceCall(String(format : "%f",prevLocation.coordinate.latitude), String(format : "%f",prevLocation.coordinate.longitude))
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
            //self.getCurrentDayWeatherReportServiceCall(String(format : "%f",currentLocation.latitude), String(format : "%f",currentLocation.longitude))
            self.getForecastThreeDaysHourlyWeatherReportServiceCall(String(format : "%f",currentLocation.latitude), String(format : "%f",currentLocation.longitude))
        }
    }
    
    func settingLineChartGraphProperties(){
        let colorspace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let num_locations:size_t = 2
        let locations: [CGFloat] = [0.0, 1.0]
        let components: [CGFloat] = [
            1.0, 1.0, 1.0, 1.0,
            1.0, 1.0, 1.0, 0.0
        ]
        let gradient = CGGradient(colorSpace: colorspace, colorComponents: components, locations: locations, count: num_locations)
        self.hourlyLineChart?.gradientBottom = gradient!

        // Enable and disable various graph properties and axis displays
        self.hourlyLineChart?.enableTouchReport = true;
        self.hourlyLineChart?.enablePopUpReport = false;
        self.hourlyLineChart?.enableYAxisLabel = false;
        self.hourlyLineChart?.autoScaleYAxis = true;
        self.hourlyLineChart?.alwaysDisplayDots = false;
        self.hourlyLineChart?.enableReferenceXAxisLines = true;
        self.hourlyLineChart?.enableReferenceYAxisLines = true;
        self.hourlyLineChart?.enableReferenceAxisFrame = true;
        
        // Draw an average line
        //let color = UIColor(red: 31.0/255.0, green: 187.0/255.0, blue: 166.0/255.0, alpha: 1.0)
        self.hourlyLineChart?.colorTop = UIColor.clear//color;
        self.hourlyLineChart?.colorBottom = UIColor.clear//color;
        self.hourlyLineChart?.backgroundColor = UIColor.clear//color;

        // Enable and disable various graph properties and axis displays
        self.hourlyLineChart?.averageLine.alpha = 0.6;
        self.hourlyLineChart?.averageLine.color = UIColor.darkGray
        self.hourlyLineChart?.colorPoint = UIColor.white
        self.hourlyLineChart?.averageLine.width = 2.5;
        self.hourlyLineChart?.graphSpacing = 75;
        self.hourlyLineChart?.widthLine = 0.0;
        self.hourlyLineChart?.sizePoint = 15;
        self.hourlyLineChart?.labelFont = UIFont.boldSystemFont(ofSize: 12.0)
        self.hourlyLineChart?.averageLine.dashPattern = [(2),(2)]
        
        // Set the graph's animation style to draw, fade, or none
        self.hourlyLineChart?.animationGraphStyle = .draw;
        
        // Dash the y reference lines
        self.hourlyLineChart?.lineDashPatternForReferenceYAxisLines = [(1),(1)]
        
        // Show the y axis values with this format string
        self.hourlyLineChart?.formatStringForValues = "%.1f";
        
        // Setup initial curve selection segment
        //self.curveChoice.selectedSegmentIndex = self.hourlyLineChart.enableBezierCurve;
        
        // The labels to report the values of the graph when the user touches it
        //self.labelValues.text = [NSString stringWithFormat:@"%i", [[self.myGraph calculatePointValueSum] intValue]];
        //self.labelDates.text = @"between now and later";
        self.hourlyLineChart?.backgroundColor = UIColor.clear//self.hourlyLineChart?.colorBackgroundXaxis;
    }
    
    func getCurrentDayWeatherReportServiceCall(_ latitude: String?, _ longitude:String?){
        SwiftLoader.show(animated: true)
        let currentDayTempUrl = String(format: "%@%@", Base_Url,String(format: todayWeatherRequest, latitude ?? 0.0, longitude ?? 0.0, APP_ID))
        Alamofire.request(currentDayTempUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            SwiftLoader.hide()
            //print("Result:\(String(describing: response.result.value))")
            let responseDic = response.result.value as? NSDictionary
            if response.result.error == nil{
                let todayWeather = Weather(dict: responseDic!)
                self.lblCurrentTemp.text =  String(format: "%@\u{00b0}", Constatnts.getTemparatureFromValue(tempDouble: todayWeather.currentTemparature))
               // print((todayWeather.currentTemparature! - 273.15))
                self.lblCurrentLocation.text =  todayWeather.cityName as String!
                self.lblCurrentDayTempReport1.text = todayWeather.w_main as String!
                self.lblCurrentDayTempReport2.text = todayWeather.w_description as String!
                self.lblCurrentDayTempReport2.sizeToFitHeight()
                //self.lblCurrentDaySunriseTime.text = ((todayWeather.sunriseTime)! * 1000).dateFromMilliseconds(format: "hh:mm a")
                //self.lblCurrentDaySunsetTime.text = ((todayWeather.sunsetTime)! * 1000).dateFromMilliseconds(format: "hh:mm a")
                self.lblCurrentDayHumidity.text = String(format: "%d%%", todayWeather.humidity!)
                //self.lblCurrentDayTempRange.text = String(format: "%@ ~ %@\u{00b0}",Constatnts.getTemparatureFromValue(tempDouble: todayWeather.minTemparature),Constatnts.getTemparatureFromValue(tempDouble: todayWeather.maxTemparature))
                let imageUrl = String(format: "%@%@.png", Weather_Image_Url,(todayWeather.w_icon)!)
                self.imgCurrentDayWeather.downloadImageFrom(link: imageUrl, contentMode: .scaleToFill)
            }
        }
    }
    
    func getForecastThreeDaysHourlyWeatherReportServiceCall(_ latitude: String?, _ longitude:String?){
        SwiftLoader.show(animated: true)
        let currentDayTempUrl = String(format: "%@%@", Base_Url,String(format: ThreeHoursForecastWeatherRequest, latitude ?? 0.0, longitude ?? 0.0, APP_ID))
       // print(currentDayTempUrl)
        Alamofire.request(currentDayTempUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
           SwiftLoader.hide()
           // print("Result:\(String(describing: response.result.value))")
            let responseDic = response.result.value as? NSDictionary
            if response.result.error == nil{
                if let cityDic = Validations.checkKeyNotAvailForDictionary(responseDic!, key: "city") as? NSDictionary {
                    self.lblCurrentLocation.text = Validations.checkKeyNotAvail(cityDic, key: "name") as? String ?? ""
                }
                if let dayListArray = Validations.checkKeyNotAvailForArray(responseDic!, key: "list") as? NSArray{
                    if dayListArray.count > 0{
                        self.daysArray.removeAllObjects()
                        self.filteredByDateArray.removeAllObjects()
                        self.forecastHourlyDataArray.removeAllObjects()
                        /*if let todayWeatherDic = dayListArray.object(at: 0) as? NSDictionary{
                            let todayWeather = Weather(dict: todayWeatherDic)
                            self.lblCurrentDayTempRange.text = String(format: "%@ ~ %@\u{00b0}",Constatnts.getTemparatureFromValue(tempDouble: todayWeather.minTemparature),Constatnts.getTemparatureFromValue(tempDouble: todayWeather.maxTemparature))
                        }*/
                        for index in 0..<dayListArray.count{
                            if let weatherDic =  dayListArray.object(at: index) as? NSDictionary{
                                let nextDayWeather = Weather(dict: weatherDic)
                                self.forecastHourlyDataArray.add(nextDayWeather)
                            }
                        }
                    }
                }
            }
            if self.forecastHourlyDataArray.count > 0 {
                let todayWeather = self.forecastHourlyDataArray.object(at: 0) as? Weather
                self.lblCurrentTemp.text =  String(format: "%@\u{00b0}", Constatnts.getTemparatureFromValue(tempDouble: todayWeather?.currentTemparature))
              //  print(((todayWeather?.currentTemparature ?? 0.0) - 273.15))
                self.lblCurrentDay.text = ((todayWeather?.date)! * 1000).dateFromMilliseconds(format: "hh:mm a EEE dd MMM")
                self.lblCurrentDayTempReport1.text = todayWeather?.w_main as String!
                self.lblCurrentDayTempReport2.text = todayWeather?.w_description as String!
                self.lblCurrentDayHumidity.text = String(format: "%d%%", (todayWeather?.humidity!)!)
                self.lblCurrentDayTempReport2.sizeToFitHeight()
                //self.lblCurrentDayTempRange.text = String(format: "%@ ~ %@\u{00b0}",Constatnts.getTemparatureFromValue(tempDouble: todayWeather?.minTemparature),Constatnts.getTemparatureFromValue(tempDouble: todayWeather?.maxTemparature))
                let imageUrl = String(format: "%@%@.png", Weather_Image_Url,(todayWeather?.w_icon)!)
                self.imgCurrentDayWeather.downloadImageFrom(link: imageUrl, contentMode: .scaleToFill)
                for index in 0..<self.forecastHourlyDataArray.count{
                    let tempWeather = self.forecastHourlyDataArray.object(at: index) as? Weather
                    if self.daysArray.contains(tempWeather!.formattedDate) == false{
                        self.daysArray.add(tempWeather!.formattedDate)
                    }
                }
            }
            for index in 0..<self.daysArray.count{
                let filterDate = self.daysArray.object(at: index) as? String
                if Validations.isNullString(NSString(string: filterDate ?? "")) == false{
                    let filterPredicate = NSPredicate(format: "formattedDate == %@ ", filterDate!)
                    let arrDayWeather = self.forecastHourlyDataArray.filtered(using: filterPredicate)
                    let weatherDictionary = ["forecastDate":filterDate!,"forecastWeather":arrDayWeather] as [String : Any]
                    self.filteredByDateArray.add(weatherDictionary)
                }
            }
            self.settingLineChartGraphProperties()
            DispatchQueue.main.async {
                self.hourlyLineChart?.reloadGraph()
            }
            self.tblHourlyForecast.reloadData()
        }
    }
    
    //MARK: BEMLineGraph Datasource Methods
    func numberOfGapsBetweenLabels(onLineGraph graph: BEMSimpleLineGraphView) -> Int {
        return 0
    }
    
    func lineGraph(_ graph: BEMSimpleLineGraphView, labelOnXAxisFor index: Int) -> String {
        let nextDayWeather = forecastHourlyDataArray.object(at: index) as? Weather
        return ((nextDayWeather?.date)! * 1000).dateFromMilliseconds(format: "hh:mm a")
    }
    
    //MARK: BEMLineGraph Delegate Methods
    func numberOfPoints(inLineGraph graph: BEMSimpleLineGraphView) -> Int {
        return forecastHourlyDataArray.count
    }
    /*func baseValueForYAxis(onLineGraph graph: BEMSimpleLineGraphView) -> CGFloat {
        return 0.0
    }
    func incrementValueForYAxis(onLineGraph graph: BEMSimpleLineGraphView) -> CGFloat {
        return 50.0
    }
    func minValue(forLineGraph graph: BEMSimpleLineGraphView) -> CGFloat {
        return 0.0
    }
    func maxValue(forLineGraph graph: BEMSimpleLineGraphView) -> CGFloat {
        return 350.0
    }*/
    func lineGraph(_ graph: BEMSimpleLineGraphView, valueForPointAt index: Int) -> CGFloat {
        let weather = forecastHourlyDataArray.object(at: index) as? Weather
        let value = weather?.currentTemparature ?? 0.0
        //print("Value %f",value )
        //let i1 = (CGFloat)(arc4random() % 10000) / 100
        return CGFloat(value)
    }
    
    func lineGraph(_ graph: BEMSimpleLineGraphView, didScrollClosestIndex index: Int) {
        if index < forecastHourlyDataArray.count {
            let todayWeather = self.forecastHourlyDataArray.object(at: index) as? Weather
            self.lblCurrentTemp.text =  String(format: "%@\u{00b0}", Constatnts.getTemparatureFromValue(tempDouble: todayWeather?.currentTemparature))
            //print(((todayWeather?.currentTemparature!)! - 273.15))
            self.lblCurrentDay.text = ((todayWeather?.date)! * 1000).dateFromMilliseconds(format: "hh:mm a EEE dd MMM")
            self.lblCurrentDayTempReport1.text = todayWeather?.w_main as String!
            self.lblCurrentDayTempReport2.text = todayWeather?.w_description as String!
            self.lblCurrentDayTempReport2.sizeToFitHeight()
            self.lblCurrentDayHumidity.text = String(format: "%d%%", (todayWeather?.humidity!)!)
            //self.lblCurrentDayTempRange.text = String(format: "%@ ~ %@\u{00b0}",Constatnts.getTemparatureFromValue(tempDouble: todayWeather?.minTemparature),Constatnts.getTemparatureFromValue(tempDouble: todayWeather?.maxTemparature))
            let imageUrl = String(format: "%@%@.png", Weather_Image_Url,(todayWeather?.w_icon)!)
            self.imgCurrentDayWeather.downloadImageFrom(link: imageUrl, contentMode: .scaleToFill)
        }
    }
    
    //MARK: tableView dataSource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredByDateArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionDictionary = filteredByDateArray.object(at: section) as? NSDictionary else {
            return 0
        }
        if let dataArray = Validations.checkKeyNotAvailForArray(sectionDictionary, key: "forecastWeather") as? NSArray {
            return dataArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "WeatherCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        //cell.layer.backgroundColor = UIColor.clear.cgColor
        let sectionDictionary = filteredByDateArray.object(at: indexPath.section) as? NSDictionary
        let dayForecastDataArray = sectionDictionary?.value(forKey: "forecastWeather") as? NSArray
        let nextDayWeather = dayForecastDataArray?.object(at: indexPath.row) as? Weather
        let lblDate : UILabel = cell.viewWithTag(100) as! UILabel
        let lblRainFall : UILabel = cell.viewWithTag(102) as! UILabel
        let lblTemparatureRange : UILabel = cell.viewWithTag(103) as! UILabel
        let imgWeather : UIImageView = cell.viewWithTag(101) as! UIImageView
        let imageUrl = String(format: "%@%@.png", Weather_Image_Url,(nextDayWeather?.w_icon)!)
        imgWeather.downloadImageFrom(link: imageUrl, contentMode: .scaleToFill)
        lblDate.text = ((nextDayWeather?.date)! * 1000).dateFromMilliseconds(format: "hh:mm a")
        lblRainFall.text = nextDayWeather?.w_main as String!
        //lblTemparatureRange.text = String(format: "%@ ~ %@\u{00b0}",Constatnts.getTemparatureFromValue(tempDouble: nextDayWeather?.minTemparature),Constatnts.getTemparatureFromValue(tempDouble: nextDayWeather?.maxTemparature))
        lblTemparatureRange.text = String(format: "%@\u{00b0}",Constatnts.getTemparatureFromValue(tempDouble: nextDayWeather?.currentTemparature))
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(white: 0.0, alpha: 0.65)
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 10, width: tableView.bounds.size.width - 10, height: 26))
        headerLabel.font = UIFont(name: "Helvetica Neue", size: 22)
        headerLabel.textColor = UIColor.white
        headerLabel.text = ""
        guard let sectionDictionary = filteredByDateArray.object(at: section) as? NSDictionary else {
            return nil
        }
        if let forecastDate = Validations.checkKeyNotAvail(sectionDictionary, key: "forecastDate") as? String {
            headerLabel.text = forecastDate
        }
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
        //self.getCurrentDayWeatherReportServiceCall(String(format : "%f",currentLocation.coordinate.latitude), String(format : "%f",currentLocation.coordinate.longitude))
        self.getForecastThreeDaysHourlyWeatherReportServiceCall(String(format :"%f",currentLocation.coordinate.latitude), String(format : "%f",currentLocation.coordinate.longitude))
        locationService.stopUpdatingLocation()
    }
    
    func tracingLocationDidFailWithError(_ error: NSError) {
        
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
