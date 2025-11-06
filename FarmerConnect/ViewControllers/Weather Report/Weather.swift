//
//  Weather.swift
//  Weather Plugin
//
//  Created by Admin on 08/08/17.
//  Copyright © 2017 Empover. All rights reserved.
//

import UIKit

class Weather: NSObject {

    var cityName : NSString?
    var date : Int64?
    var w_main : NSString?
    var w_description : NSString?
    var w_icon : NSString?
    var avgTemparature: Double?
    var currentTemparature: Double?
    var maxTemparature : Double?
    var minTemparature : Double?
    var dayTemparature : Double?
    var nightTemparature : Double?
    var morningTemparature : Double?
    var eveningTemparature : Double?
    var humidity : Int64?
    var rain : Double?
    var clouds : NSString?
    var sunriseTime : Int64?
    var sunsetTime : Int64?
    @objc var formattedDate : String = ""
    var formattedTime : String = ""

    init(dict: NSDictionary) {
        self.cityName = Validations.checkKeyNotAvail(dict, key: "name") as? NSString ?? ""
        self.clouds = Validations.checkKeyNotAvail(dict, key: "clouds") as? NSString ?? ""
        self.rain = Validations.checkKeyNotAvail(dict, key: "rain") as? Double ?? 0.0
        if let hum = Validations.checkKeyNotAvail(dict, key: "humidity") as? Int64 {
            if hum > 0{
                self.humidity = hum
            }
        }
        if let weatherArray = Validations.checkKeyNotAvailForArray(dict, key: "weather") as? NSArray {
            if weatherArray.count > 0 {
                if let weatherDic = weatherArray.object(at: 0) as? NSDictionary {
                    self.w_main = Validations.checkKeyNotAvail(weatherDic, key: "main") as? NSString ?? ""
                    self.w_description = Validations.checkKeyNotAvail(weatherDic, key: "description") as? NSString ?? ""
                    self.w_icon = Validations.checkKeyNotAvail(weatherDic, key: "icon") as? NSString ?? ""
                }
            }
        }
        if let mainDic = Validations.checkKeyNotAvailForDictionary(dict, key: "main") as? NSDictionary {
            self.currentTemparature = Validations.checkKeyNotAvail(mainDic, key: "temp") as? Double ?? 0.0
            self.humidity =  Validations.checkKeyNotAvail(mainDic, key: "humidity") as? Int64 ?? 0
            self.minTemparature =  Validations.checkKeyNotAvail(mainDic, key: "temp_min") as? Double ?? 0.0
            self.maxTemparature =   Validations.checkKeyNotAvail(mainDic, key: "temp_max") as? Double ?? 0.0
        }
        if let sysDic = Validations.checkKeyNotAvailForDictionary(dict, key: "sys") as? NSDictionary {
            self.sunriseTime = Validations.checkKeyNotAvail(sysDic, key: "sunrise") as? Int64 ?? 0
            self.sunsetTime = Validations.checkKeyNotAvail(sysDic, key: "sunset") as? Int64 ?? 0
        }
        if let date = Validations.checkKeyNotAvail(dict, key: "dt") as? Int64 {
            if date > 0{
                self.date = date
                guard let dateFromServer = ((self.date)! * 1000).dateFromMilliseconds(format: "EEE dd MMM") as String?  else {
                }
                self.formattedDate = dateFromServer
                guard let timeFromServer = ((self.date)! * 1000).dateFromMilliseconds(format: "hh:mm a") as String?  else {
                }
                self.formattedTime = timeFromServer
            }
        }
        if let tempDic = Validations.checkKeyNotAvailForDictionary(dict, key: "temp") as? NSDictionary {
            if let tempMin = Validations.checkKeyNotAvail(tempDic, key: "min") as? Double {
                if tempMin > 0{
                    self.minTemparature = tempMin
                }
            }
            if let tempMax = Validations.checkKeyNotAvail(tempDic, key: "max") as? Double {
                if tempMax > 0{
                    self.maxTemparature = tempMax
                }
            }
            if let dayTemp = Validations.checkKeyNotAvail(tempDic, key: "day") as? Double {
                if dayTemp > 0{
                    self.dayTemparature = dayTemp
                }
            }
            if let nightTemp = Validations.checkKeyNotAvail(tempDic, key: "night") as? Double {
                if nightTemp > 0{
                    self.nightTemparature = nightTemp
                }
            }
            if let eveTemp = Validations.checkKeyNotAvail(tempDic, key: "eve") as? Double {
                if eveTemp > 0{
                    self.eveningTemparature = eveTemp
                }
            }
            if let mornTemp = Validations.checkKeyNotAvail(tempDic, key: "morn") as? Double {
                if mornTemp > 0{
                    self.morningTemparature = mornTemp
                }
            }
        }
    }
}
