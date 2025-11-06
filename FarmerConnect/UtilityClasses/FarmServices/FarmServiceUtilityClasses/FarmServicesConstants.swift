//
//  Constants.swift
//  FarmerConnect
//
//  Created by Admin on 20/12/17.
//  Copyright © 2017 ABC. All rights reserved.
//

import UIKit
import CoreLocation

var Equipment_Classification = "equipmentProvider/getEquipmentClassificationList"

let localizedString = NSLocalizedString("No_Equipment_Available", comment: "")

var No_Equipment_Available = localizedString
var Add_Equipments = "equipmentProvider/addEquipment"
var Add_Equipment_Images = "equipmentProvider/addImagesToEquipment"
var Get_Equipment_List = "equipmentProvider/getEquipmentList"
var Edit_Equipment_Details = "equipmentProvider/editEquipment"
var View_Equipment_Details = "equipmentProvider/viewEquipment"
var Delete_Equipment_Details = "equipmentProvider/deleteEquipment"
var Disable_Equipment_Details = "equipmentProvider/disableEquipment"
var Enable_Equipment_Details = "equipmentProvider/enableEquipment"
var View_Equipment_Availability = "equipmentProvider/viewEquipmentAvailability"
var Update_Equipment_Availability = "equipmentProvider/updateAvailability"
var Add_Equipment_Availability = "equipmentProvider/addAvailability"
var Delete_Equipment_Availability = "equipmentProvider/deleteAvailability"
var Equipment_DateWise_Availability = "equipmentProvider/getEquipmentDateWiseAvailability"
var Placing_Fresh_Oredr = "equipmentRequester/confirmBooking"
var Provider_Filter_Equipment_Classification = "equipmentProvider/getProviderAddedEquipmentsMasterData"

var Edit_Placed_Order = "equipmentRequester/editOrderDetails"
var Get_Provider_Orers_List = "equipmentProvider/getProviderOrders"
var Get_Requester_Orders_List = "equipmentRequester/getRequesterOrders"
var Requester_Cancel_Booking = "equipmentRequester/cancelBooking"
var Provider_Reject_Booking = "equipmentProvider/rejectBooking"
var Provider_Confirm_Booking = "equipmentProvider/confirmBooking"
var Check_FeedBack_Availability = "equipmentProvider/checkFeedbackAvailable"
var Submit_Equipment_Feedback = "equipmentProvider/submitRating"
var Get_Rating_Questions = "equipmentProvider/ratingQuestions"
var Accept_Counter_Proposal = "equipmentRequester/acceptCounterProposal"

var App_Theme_Green_Color = UIColor(red: 34.0/255, green: 119.0/255, blue: 45.0/255, alpha: 1.0)
var App_Theme_Orange_Color = UIColor(red: 255.0/255, green: 147.0/255, blue: 0.0/255, alpha: 1.0)
var App_Theme_Blue_Color = UIColor(red: 0.0/255, green: 95.0/255, blue: 239.0/255, alpha: 1.0)
var App_Theme_Orange_Light_Color = UIColor(red: 255.0/255, green: 126.0/255, blue: 31.0/255, alpha: 1.0)
var App_Theme_Green_Light_Color = UIColor(red: 136.0/255, green: 180.0/255, blue: 16.0/255, alpha: 1.0)
var App_Theme_Orange_new_Color = UIColor(red: 255.0/255, green: 130.0/255, blue: 82.0/255, alpha: 1.0)

//MARK: Response codes
let CURRENTLY_NO_EQUIPMENTS_AVAILABLE = "804"

//MARK: Messages

let Equipment_Images_Max_Select = NSLocalizedString("Equipment_Images_Max_Select", comment: "")
let Equipment_Images_Max_Limit_Reached = "You don't select more than three images"
let Please_Select_Location = "Please select location."
let Please_Enter_Price = NSLocalizedString("please_enter_price_per_hour", comment: "")
let Please_Enter_Schedule_From_Time = NSLocalizedString("please_enter_schedule_from_time", comment: "")
let Please_Enter_Schedule_To_Time = NSLocalizedString("Please_Enter_Schedule_To_Time", comment: "") //"Please enter schedule to time."
let Please_Select_Equip_Location = NSLocalizedString("Please_Select_Equip_Location", comment: "") //"Please select equipment location."
let Please_Select_Rating = NSLocalizedString("Please_Select_Rating", comment: "")//"Please select rating."
let Please_Enter_your_Comments = NSLocalizedString("Please_Enter_your_Comments", comment: "")//"Please enter your comments."
let Please_Select_From_Date = NSLocalizedString("Please_Select_From_Date", comment: "")//"Please select from date."
let Please_Select_To_Date = NSLocalizedString("Please_Select_To_Date", comment: "")//"Please select to date."
let Please_Select_No_Of_Hours = NSLocalizedString("Please_Enter_No_Of_Hours", comment: "")//"Please select number of hours required."
let Please_Select_Available_Date = NSLocalizedString("Please_Select_Available_Date", comment: "")//"Please select available date."
let Please_Enter_No_Of_Hours = NSLocalizedString("Please_Enter_No_Of_Hours", comment: "")//"Enter number of hours"
let Please_Enter_Location = NSLocalizedString("Please_Enter_Location", comment: "")//"Enter your location"
let Please_Select_To_Date_PlaceHolder = NSLocalizedString("Please_Select_To_Date", comment: "")
let Price_Not_Zero = NSLocalizedString("Price_Not_Zero", comment: "")//"Price value should not be zero"
let Enter_Number_Of_Hours = NSLocalizedString("Enter_Number_Of_Hours", comment: "")//"Enter number of hours required"
let Updated_Equipment_Successfully = NSLocalizedString("Updated_Equipment_Successfully", comment: "")//"Updated schedule successfully."
let Scheduled_Equipment_Successfully = NSLocalizedString("Scheduled_Equipment_Successfully", comment: "")//"Equipment scheduled successfully."
let Cancel_Reason_Char_Limit = NSLocalizedString("Cancel_Reason_Char_Limit", comment: "")//"Please enter minimum 16 characters"
//let No_Equipments_Available = "Currently no equipment available."
let Price_Per_Hour_Empty = NSLocalizedString("Price_Per_Hour_Empty", comment: "")//"Price per hour empty"
let Price_Should_Not_Zero = NSLocalizedString("Price_Should_Not_Zero", comment: "")//"Price should not be equal to zero"
let Max_Distance_Empty = NSLocalizedString("Max_Distance_Empty", comment: "")//"Max distance empty"
let Distance_Not_Equal_To_Zero = NSLocalizedString("Distance_Not_Equal_To_Zero", comment: "")//"Distance should not be equal to zero"
let From_To_Time_Alert = NSLocalizedString("From_To_Time_Alert", comment: "")//"To time should not be less than to from time."
let Schedule_Date_Not_Empty = NSLocalizedString("Schedule_Date_Not_Empty", comment: "")//"Schedule date should not empty."
let Minimum_Service_Hours_Required = NSLocalizedString("Minimum_Service_Hours_Required", comment: "")//"Required service hours should be more than or equal to minimum service hours."
let Request_Location_Not_Empty = NSLocalizedString("Request_Location_Not_Empty", comment: "")//"Request location should not be empty."
let Start_Time_Greater_To_Current = NSLocalizedString("Start_Time_Greater_To_Current", comment: "")//"Start time should be greater than or equal to current time"
let To_Date_Greater_To_From = NSLocalizedString("To_Date_Greater_To_From", comment: "")//"To date should be greater than or equal to from date"
let Select_Date = NSLocalizedString("Please_select_date", comment: "")
var Schedule_Delete_Message = NSLocalizedString("Schedule_Delete_Message", comment: "")//"Are you sure want to delete schedule on %@ ?"
let Equipment_Delete_Successfully = NSLocalizedString("Equipment_Delete_Successfully", comment: "")//"Equipment deleted successfully."
let Feedback_Submitted_Successfully =  NSLocalizedString("Feedback_Submitted_Successfully", comment: "")//"Feedback submitted successfully."
let Order_Cancel_Alert_Title = NSLocalizedString("Order_Cancel_Alert_Title", comment: "")//"What is the reason for cancel?"
let Order_Reject_Alert_Title = NSLocalizedString("Order_Reject_Alert_Title", comment: "")//"What is the reason for rejection?"
let No_Orders_Found = NSLocalizedString("No_Orders_Found", comment: "")
let Equipment_In_DisableMode = NSLocalizedString("Equipment_In_DisableMode", comment: "")//"This equipment is in disable mode."
var DISTANCE_ALERT_MESSAGE = NSLocalizedString("DISTANCE_ALERT_MESSAGE", comment: "")// "Distance calculated as straight line \n distance, actual distance may vary\n depending on route."
var Currency = "\u{20B9}"

//Requester
var GET_REQUESTER_CLASSIFICATIONS = "equipmentProvider/getEquipmentClassificationList"
var GET_EQUIPMENT_LIST = "equipmentRequester/getEquipmentList"
var GET_REQUESTER_RATINGS = "equipmentRequester/getSelfRating"
var GET_EQUIPMENT_RATINGS = "equipmentRequester/getEquipmentRating"

//Notification Navigation Handling Key
var Notification_Type_Provider : NSString = "provider"
var Notification_Type_Provider_Home : NSString = "providerHome"
var Notification_Type_Requester : NSString = "requester"
var Notification_Type_Requester_Home : NSString = "requesterHome"
var Notification_Type_Deeplink : NSString = "requester"
var Notification_Deeplink_Key : NSString = "deepLinkingKey"
var Deeplink_Key_Notification : NSString = "gcm.notification.deepLinkingURL"
var Notification_Type_Classification : NSString = "Planter"


var Notification_User_Type = "gcm.notification.userType"
var Notification_Classification = "gcm.notification.classification"
var CANCEL = NSLocalizedString("cancel", comment: "")
var REJECT = NSLocalizedString("reject", comment: "")
var CONFIRM = NSLocalizedString("confirm", comment: "")
let OK = NSLocalizedString("ok", comment: "")
let ALERT = NSLocalizedString("alert", comment: "")

class FarmServicesConstants: NSObject {

    public class func getCurrentMillis()->Int64 {
        //print(Int64(Date().timeIntervalSince1970 * 1000))
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    public class func getTimeStampForImage()->String {
        //print(Int64(Date().timeIntervalSince1970 * 1000))
        let userObj = Constatnts.getUserObject()
        let imageName = String(format: "%@_%@_%d.jpg", userObj.customerId!,userObj.deviceId!,FarmServicesConstants.getCurrentMillis())
        return imageName
    }
    
    public class func getDateFromDateString(dateStr : String) -> NSDate?{
        var dateString = dateStr
        dateString = dateString .trimmingCharacters(in: NSCharacterSet .whitespacesAndNewlines)
        if (dateString.count > 0 )
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date : NSDate = dateFormatter.date(from: dateString)! as NSDate
            return date
        }
        return nil
    }
    
    public class func getDateStringFromDate(serverDate : Date?) -> NSString?{
        if (serverDate != nil)
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateStr : String = dateFormatter.string(from: serverDate!)
            if Validations.isNullString(dateStr as NSString) == false{
                return dateStr as NSString
            }
            return nil
        }
        return nil
    }
    
    public class func getDateStringFromDateWithShortMonth(serverDate : Date?) -> NSString?{
        if (serverDate != nil)
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            let dateStr : String = dateFormatter.string(from: serverDate!)
            if Validations.isNullString(dateStr as NSString) == false{
                return dateStr as NSString
            }
            return nil
        }
        return nil
    }
    
    public class func getDateStringFromDateStringWithShortFormat(serverDate : String?) -> NSString?{
        if (serverDate != nil)
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let formatDate = dateFormatter.date(from: serverDate!) as Date?
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            if formatDate != nil{
                let dateStr = dateFormatter.string(from: formatDate!)
                if Validations.isNullString(dateStr as NSString) == false{
                    return dateStr as NSString
                }
                return nil
            }
            return nil
        }
        return nil
    }
    public class func getDateFromDateStringWithShortFormat(serverDate : String?) -> Date?{
        if (serverDate != nil)
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            let formatDate = dateFormatter.date(from: serverDate!) as Date?
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if formatDate != nil{
                let dateStr = dateFormatter.string(from: formatDate!)
                if Validations.isNullString(dateStr as NSString) == false{
                    return dateFormatter.date(from: dateStr)
                }
                return nil
            }
            return nil
        }
        return nil
    }
    public class func getDateStringFromDateStringWithNormalFormat(serverDate : String?) -> NSString?{
        if (serverDate != nil)
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let formatDate = dateFormatter.date(from: serverDate!) as Date?
            dateFormatter.dateFormat = "dd-MM-yyyy"
            if formatDate != nil{
                let dateStr = dateFormatter.string(from: formatDate!)
                if Validations.isNullString(dateStr as NSString) == false{
                    return dateStr as NSString
                }
                return nil
            }
            return nil
        }
        return nil
    }
    public class func formattedAMAndPMTimeString(timeStr : String) -> NSString?{
        let arrTime = timeStr.components(separatedBy: ":")
        if arrTime.count > 1{
            var formattedStr = String(format: "%@:%@", arrTime[0],arrTime[1])
            formattedStr = formattedStr .trimmingCharacters(in: NSCharacterSet .whitespacesAndNewlines)
            if (formattedStr.count > 0 )
            {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                dateFormatter.amSymbol = "AM"
                dateFormatter.pmSymbol = "PM"
                let date : NSDate = dateFormatter.date(from: formattedStr)! as NSDate
                let finalTimeStr = dateFormatter.string(from: date as Date)
                if Validations.isNullString(finalTimeStr as NSString) == false{
                    return finalTimeStr as NSString
                }
                return nil
            }
        }
        return nil
    }
    public class func getRoutesWithgoogle(_ userCoordinates: CLLocationCoordinate2D?, departMentCoordinates deptCoordinates: CLLocationCoordinate2D?) {
        if userCoordinates != nil && deptCoordinates != nil{
            let latitude_User = CGFloat(userCoordinates!.latitude)
            let longitude_User = CGFloat(userCoordinates!.longitude)
            let latitude_Dept = CGFloat(deptCoordinates!.latitude)
            let longitude_Dept = CGFloat(deptCoordinates!.longitude)
            if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
                let openURLStr = "comgooglemaps://?saddr=\(latitude_User),\(longitude_User)&&daddr=\(latitude_Dept),\(longitude_Dept)&directionsmode=driving"
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: openURLStr)!, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(URL(string: openURLStr)!)
                }
            }
            else {
                let openURLStr: String? = String(format: "http://maps.google.com/maps?saddr=%f,%f&&daddr=%f,%f&directionsmode=driving", latitude_User,longitude_User,latitude_Dept,longitude_Dept).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: openURLStr ?? "")!, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(URL(string: openURLStr!)!)
                }
            }
        }
    }
    public class func amAppend(dateStr:String) -> String?{
        var dateString = dateStr
        dateString = dateString .trimmingCharacters(in: NSCharacterSet .whitespacesAndNewlines)
        if (dateString.count > 0 )
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH"
            let date : Date = dateFormatter.date(from: dateString)! as Date
            dateFormatter.dateFormat = "h:mm a"
            let amPmFormat = dateFormatter.string(from: date)
            if Validations.isNullString(amPmFormat as NSString) == false{
                return amPmFormat
            }
            return nil
        }
        return nil
        /*var temp = str
        var strArr = str.split{$0 == ":"}.map(String.init)
        let hour = Int(strArr[0])!
        let min = Int(strArr[1])!
        if hour == 12 && min < 60{
            temp = String(format: "%02d:%02d PM", hour,min)
        }
        else if(hour > 12){
            temp = String(format: "%02d:%02d PM", hour-12,min)
        }
        else{
            temp = String(format: "%02d:%02d AM", hour,min)
        }
        return temp*/
    }
}
