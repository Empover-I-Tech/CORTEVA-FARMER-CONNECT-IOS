//
//  Singleton.swift
//  FarmerConnect
//
//  Created by Admin on 15/02/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
//import UQScannerFramework

class Singleton: NSObject {
    //MARK: Shared Instance
    
    static let sharedInstance : Singleton = {
        let instance = Singleton()
        return instance
    }()
    
    //MARK: Local Variable
    
    var emptyStringArray : [String]? = nil
    var isFromDeepLink : Bool? = false
    var deepLinkParams : NSDictionary? = nil
    
    //MARK: Init
    
    convenience override init() {
        self.init(array : [])
    }
    
    //MARK: Init Array
    
    init( array : [String]) {
        emptyStringArray = array
    }
    
    //MARK: Submit Pending Crop Calculations
    class func syncingPendigCropCalculationsToServer(){
        if let arrPendingCropCalculations = Singleton.getPendingCropCaliculations("CropCalculatorEntity") as NSArray?{
            if arrPendingCropCalculations.count > 0{
                let arrPendingCropsData = NSMutableArray()
                for index in 0..<arrPendingCropCalculations.count{
                    if let cropData = arrPendingCropCalculations.object(at: index) as? CropCalculatorEntity{
                        let cropDic = NSMutableDictionary()
                        cropDic.setValue(cropData.year ?? "", forKey: "year")
                        cropDic.setValue(cropData.cropName ?? "", forKey: "cropName")
                        cropDic.setValue(cropData.landPreparation ?? "", forKey: "landPreparation")
                        cropDic.setValue(cropData.seedCost ?? "", forKey: "seedCost")
                        cropDic.setValue(cropData.seedRate ?? "", forKey: "seedRate")
                        cropDic.setValue(cropData.labourCost ?? "", forKey: "labourCost")
                        cropDic.setValue(cropData.totalNoOfLabours ?? "", forKey: "totalNoOfLabourersReq")
                        cropDic.setValue(cropData.mechanicalHarvestingCost ?? "", forKey: "mechanicalHarvestingCost")
                        cropDic.setValue(cropData.costPerIrrigation ?? "", forKey: "costPerIrrigation")
                        cropDic.setValue(cropData.noOfIrrigations ?? "", forKey: "noOfIrrigations")
                        cropDic.setValue(cropData.fertiliserCost ?? "", forKey: "fertilizerCost")
                        cropDic.setValue(cropData.pesticidesCost ?? "", forKey: "pesticideCost")
                        cropDic.setValue(cropData.grainYield ?? "", forKey: "grainYield")
                        cropDic.setValue(cropData.commercialGrainPrice ?? "", forKey: "commercialGrainPrice")
                        cropDic.setValue(cropData.strawYield ?? "", forKey: "strawYield")
                        cropDic.setValue(cropData.commercialFooderPrice ?? "", forKey: "commercialFodderPrice")
                        cropDic.setValue(cropData.geoLocation ?? "", forKey: "geoLocation")
                        cropDic.setValue(cropData.mobileId ?? "", forKey: "mobileId")
                        cropDic.setValue(cropData.planningAcers ?? "", forKey: "planningAcres")
                        arrPendingCropsData.add(cropDic)
                    }
                }
                if arrPendingCropsData.count > 0{
                    let cropDatDic = ["cropCalculatorTransactionDataList":arrPendingCropsData]
                    Singleton.sharedInstance.uploadPendingCropCalculationsToServer(cropDatDic as NSDictionary, completionHandler: { (status, message,mobileIds) in
                        if status == true && mobileIds != nil{
                            if mobileIds?.count ?? 0 > 0{
                                Singleton.deleteSyncedCropDetailsFromLocalDB(mobileIds)
                            }
                        }
                    })
                }
            }
        }
    }
    func uploadPendingCropCalculationsToServer(_ parameters: NSDictionary, completionHandler:(_ status:Bool,_ message:String,_ mobileIds: NSArray?) -> Void){
        let urlString:String = String(format: "%@%@", arguments: [BASE_URL,Sync_CropCalculations])
        //lastUpdatedTime
        let userObj = Constatnts.getUserObject()
        let headers: HTTPHeaders = ["deviceToken": userObj.deviceToken as String,
                                    "userAuthorizationToken": userObj.userAuthorizationToken! as String,
                                    "mobileNumber": userObj.mobileNumber! as String,
                                    "customerId": userObj.customerId! as String,
                                    "deviceId": userObj.deviceId! as String]
        let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
        let params =  ["data" : paramsStr]
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
//            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        //print("Response after decrypting data:\(decryptData)")
                        let mobilIdListArray = decryptData.value(forKey: "mobileIdList") as! NSArray
                        for i in 0 ..< mobilIdListArray.count{
                            if let mobilId = mobilIdListArray.object(at: i) as? String{
                                let filterMobilId = NSPredicate(format: "mobileId == %@",mobilId)
                                Singleton.deleteSyncedCropCaliculationDetails(predicate: filterMobilId)
                            }
                        }
                    }
                }
            }
        }
    }
    class func getPendingCropCaliculations(_ entity:String) -> NSArray?{
        let detailsMutArray  = NSMutableArray()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.predicate = NSPredicate(format: "status = %@","1")
        do {
            let results = try managedContext!.fetch(fetchRequest) as! [NSManagedObject]
            for detailsObj  in results as [NSManagedObject] {
                if let detailsEntity =   detailsObj as? CropCalculatorEntity{
                    detailsMutArray.add(detailsEntity)
                }
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return detailsMutArray
    }
    class func getMasterDataFromCropCaliculations(_ entity:String) -> NSArray?{
        let detailsMutArray  = NSMutableArray()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        //fetchRequest.predicate = NSPredicate(format: "status = %@","1")
        do {
            let results = try managedContext!.fetch(fetchRequest) as! [NSManagedObject]
            for detailsObj  in results as [NSManagedObject] {
                if let detailsEntity =   detailsObj as? CropCalculatorEntity{
                    detailsMutArray.add(detailsEntity)
                }
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return detailsMutArray
    }
    class func getMasterDataFromCropCalculatonsWithPredicate(_ entity:String,predicate:NSPredicate?) -> NSArray?{
        let detailsMutArray  = NSMutableArray()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        do {
            let results = try managedContext!.fetch(fetchRequest) as! [NSManagedObject]
            for detailsObj  in results as [NSManagedObject] {
                if let detailsEntity =   detailsObj as? CropCalculatorEntity{
                    detailsMutArray.add(detailsEntity)
                }
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return detailsMutArray
    }
    class func getYearsFromMasterDataFromCropCalculatonsWithPredicate(_ entity:String,predicate:NSPredicate?) -> NSArray?{
        let detailsMutArray  = NSMutableArray()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.propertiesToFetch = ["year"]
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        do {
            let results = try managedContext!.fetch(fetchRequest) as! [NSManagedObject]
            for detailsObj  in results as [NSManagedObject] {
                if let detailsEntity =   detailsObj as? CropCalculatorEntity{
                    detailsMutArray.add(detailsEntity)
                }
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return detailsMutArray
    }
    class func getLastYearMasterDataFromCropCalculations(_ entity:String, _ cropName: String) -> NSArray?{
        let detailsMutArray  = NSMutableArray()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.predicate = NSPredicate(format: "cropName = %@",cropName)
        let sortDescriptor = NSSortDescriptor(key: "year", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchLimit = 1
        do {
            let results = try managedContext!.fetch(fetchRequest) as! [NSManagedObject]
            for detailsObj  in results as [NSManagedObject] {
                if let detailsEntity =   detailsObj as? CropCalculatorEntity{
                    detailsMutArray.add(detailsEntity)
                }
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return detailsMutArray
    }
    class func deleteSyncedCropCaliculationDetails(predicate:NSPredicate?) {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.managedObjectContext
        let coord = appDel.persistentStoreCoordinator
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CropCalculatorEntity")
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        fetchRequest.includesPropertyValues = false
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try coord.execute(deleteRequest, with: context)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    class func deleteSyncedCropDetailsFromLocalDB(_ mobileIds: NSArray?){
        if mobileIds != nil {
            if mobileIds!.count > 0{
                let appdelegate = UIApplication.shared.delegate as? AppDelegate
                for index in 0..<mobileIds!.count{
                    if let mobileId = mobileIds?.object(at: index) as? String{
                        appdelegate?.deleteSyncedCropCaliculationDetails(mobileId: mobileId, "", "")
                    }
                }
            }
        }
    }
    class func getRefferalCodeFromAppStoreUrl(_ url: URL){
        let urlStr = (url.absoluteString as NSString).lastPathComponent
        var refferalCode = ""
        if  urlStr.count > 0 {
            let urlComponents  = urlStr.components(separatedBy: "?") as NSArray
            if urlComponents.count > 0 {
                if let pathComponentsStr = urlComponents.lastObject as? NSString{
                    let pathComponents = pathComponentsStr.components(separatedBy: "&") as NSArray
                    if pathComponents.count > 0 {
                        for index in 0..<pathComponents.count{
                            if let referalStr = pathComponents.object(at: index) as? NSString{
                                let pairComponents = referalStr.components(separatedBy: "=") as NSArray
                                if pairComponents.count > 1{
                                    let key = pairComponents.firstObject as? String
                                    let value = pairComponents.lastObject as? String
                                    if key == "referral"{
                                        refferalCode = value!
                                        self.submitReferalCodeToServer(refferalCode)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    class func getParametersFromDeeplinkingUrl(_ url:URL) -> NSDictionary?{
        let queryString = (url.absoluteString as NSString).lastPathComponent
        if  queryString.count > 0 {
            let params = queryString.components(separatedBy: "&").map({
                $0.components(separatedBy: "=")
            }).reduce(into: [String:String]()) { dict, pair in
                if pair.count == 2 {
                    dict[pair[0]] = pair[1]
                }
            }
            print(params)
            guard let returnParms = params as NSDictionary? else{
                return nil
            }
            return returnParms
            /*let urlComponents  = urlStr.components(separatedBy: "&") as [String]
             if urlComponents.count > 0 {
             var queryStrings = [String: String]()
             for pair in urlComponents {
             let key = pair.components(separatedBy: "=")[0]
             let value = pair
             .components(separatedBy:"=")[1]
             .replacingOccurrences(of: "+", with: " ")
             .removingPercentEncoding ?? ""
             
             queryStrings[key] = value
             }
             }*/
        }
        return nil
    }
    class func getParametersFromDeeplinkingNotificationUrl(_ url:URL) -> NSDictionary?{
        let queryString = url.query
        if  queryString?.count ?? 0 > 0 {
            let params = queryString?.components(separatedBy: "&").map({
                $0.components(separatedBy: "=")
            }).reduce(into: [String:String]()) { dict, pair in
                if pair.count == 2 {
                    dict[pair[0]] = pair[1]
                }
            }
            print(params ?? [:])
            guard let returnParms = params as NSDictionary? else{
                return nil
            }
            return returnParms
            /*let urlComponents  = urlStr.components(separatedBy: "&") as [String]
             if urlComponents.count > 0 {
             var queryStrings = [String: String]()
             for pair in urlComponents {
             let key = pair.components(separatedBy: "=")[0]
             let value = pair
             .components(separatedBy:"=")[1]
             .replacingOccurrences(of: "+", with: " ")
             .removingPercentEncoding ?? ""
             
             queryStrings[key] = value
             }
             }*/
        }
        return nil
    }
    class func submitReferalCodeToServer(_ referalCode: String){
        let Campaign_Test_Url = "http://182.73.10.4:9090/ATP/rest/customer/saveCampaignDetails"
        /*{
         "customerId":"123",
         "deviceId":"sds555sdsds2ss222",
         "referralKey":"12sdsds132154dsds21s1s"
         "mobileTimestamp":"11111111",
         "deviceType":"iOS"
         }*/
        let deviceID = UIDevice.current.identifierForVendor!.uuidString.replacingOccurrences(of: "-", with: "") as String? ?? ""
        var customerId = ""
        if let loginDecodedData = UserDefaults.standard.value(forKey: "LoginDecodedData") as? NSDictionary{
            if let tempCustId = loginDecodedData.value(forKey: "customerId") as? String{
                customerId = tempCustId
            }
        }
        let timeStamp = String(format: "%d", Constatnts.getCurrentMillis())
        let params = ["customerId": customerId,"deviceId":deviceID,"referralKey": referalCode,"mobileTimestamp":timeStamp,"deviceType":"iOS"]
        Alamofire.request(Campaign_Test_Url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).response { (response) in
            
        }
    }
    //submitScannedUniquoBarcodeResultDataToServerNew
    class func submitScannedUniquoBarcodeResultDataToServerNew(scanResult: Dictionary<String,Any>?,userMessage:String,completeResponse : String,selectedLabel: String, completionHandler:@escaping (_ status:Bool?,_ dictionary: NSDictionary?,_ message:String?)-> Void){
        
        if scanResult != nil {
            let headers = Constatnts.getLoggedInFarmerHeaders()
            let productDetails = scanResult?["productDetails"] as? Dictionary<String,Any>
            let arrProductSpecs = productDetails?["product_specifications"] as? NSArray
            var batchNo = ""
            var mfg_date = ""
            var expiry_date = ""
            var product_points = ""
            
            //            for i in 0..<arrProductSpecs?.count{
            if arrProductSpecs != nil && arrProductSpecs?.count ?? 0 > 0 {
                for i in 0...arrProductSpecs!.count-1{
                    let product = arrProductSpecs![i] as? NSDictionary
                    
                    if product?.object(forKey: "batch_number") != nil {
                        batchNo = product?.object(forKey: "batch_number") as? String ?? ""
                    }
                    if product?.object(forKey: "mfg_date") != nil {
                        mfg_date = product?.object(forKey: "mfg_date") as? String ?? ""
                    }
                    if product?.object(forKey: "expiry_date") != nil {
                        expiry_date = product?.object(forKey: "expiry_date") as? String ?? ""
                    }
                    if product?.object(forKey: "product_points") != nil {
                        product_points = product?.object(forKey: "product_points") as? String ?? ""
                    }
                }
            }
            let userData = Constatnts.getUserObject()
            var parameters = ["responseCode":scanResult?["responseCode"],"message":scanResult?["message"] ,"serialNumber":scanResult?["serialNumber"],"codeLogId":scanResult?["codeLogId"] ?? "","deviceType":"iOS","userMessage":userMessage,"appName":"FC","productName" : productDetails?["product_name"] ?? "","productId" : productDetails?["product_id"] ?? "", "productSKU" : productDetails?["product_sku"] ?? "","productDescription" : productDetails?["product_description"], "referrer":userData.deepLinkingString] as NSMutableDictionary
            
            parameters.addEntries(from: ["productPrice" : productDetails?["product_price"] ?? "","productAndroidAR" : productDetails?["android_ar"] ?? ""])
            
            parameters.addEntries(from: ["productManufacturingdate" : mfg_date, "productExpiryDate" : expiry_date,"complete_response": completeResponse,"productIosAr" : productDetails?["ios_ar"] ?? "", "productPoints" : product_points,"productBatchNo" : batchNo])
            
            parameters.addEntries(from: ["userPacketLabel": selectedLabel])
            
            SwiftLoader.show(animated: true)
            let paramsStr = Constatnts.nsobjectToJSON(parameters as NSMutableDictionary)
            let params =  ["data" : paramsStr]
            let urlString:String = String(format: "%@%@", arguments: [BASE_URL,Save_Genunity_Check_Result]) // "http://192.168.3.141:8080/ATP/rest/" nithin
            
            Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                SwiftLoader.hide()
                if response.result.error == nil {
                    if let json = response.result.value {
                        print(json)
                        let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                        if responseStatusCode == STATUS_CODE_200{
                            let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                            let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                            let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString)
                            completionHandler(true,decryptData,msg as String? ?? "")
                        }
                        else if responseStatusCode == STATUS_CODE_205{
                            let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                            let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                            let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString)
                            completionHandler(true,decryptData,"205")
                        }
                        else if responseStatusCode == FAB_MASTER_DETAILS_BASED_ON_STATENAME_STATUS_CODE_301{
                            if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                completionHandler(false, NSDictionary(),"Unknown error occurred")
                            }
                        }
                        else if responseStatusCode == STATUS_CODE_105{
                            if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                print(msg)
//                               self.view.makeToast(msg)
                            
                            }
                        }
                        else if responseStatusCode == STATUS_CODE_601{
                            Constatnts.logOut()
                            if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                print(msg)
                            }
                        }
                        else{
                            completionHandler(false, NSDictionary(),"Unknown error occurred")
                        }
                        
                    }
                    else{
                        completionHandler(false, NSDictionary(),"Unknown error occurred")
                    }
                }
                else{
                    print((response.error?.localizedDescription) ?? "")
                    //self.view.makeToast((response.error?.localizedDescription)!)
                }
            }
        }
    }
 
    //SubmitAcvission Barcode Result Data to server
    class func submitScannedAcvissBarcodeResultDataToServerNew(scanResult: Dictionary<String,Any>?,completeResponse : String,selectedLabel: String , moduleType: String, responseCode: Int, completionHandler:@escaping (_ status:Bool?,_ dictionary: NSDictionary?,_ message:String?)-> Void){
          
          if scanResult != nil {
              let headers = Constatnts.getLoggedInFarmerHeaders()
              let productDetails = scanResult?["product_details"] as? Dictionary<String,Any>
              let arrProductSpecs = productDetails?["specifications"] as? NSArray
              var batchNo = ""
              var mfg_date = ""
              var expiry_date = ""
              var product_points = ""
          
              let userData = Constatnts.getUserObject()
              var parameters = ["deviceType":"iOS","appName":"FC","referrer":userData.deepLinkingString,"userPacketLabel":selectedLabel,"moduleType": moduleType,"complete_response": completeResponse, "responseCode":responseCode] as NSMutableDictionary
              SwiftLoader.show(animated: true)
              let paramsStr = Constatnts.nsobjectToJSON(parameters as NSMutableDictionary)
              let params =  ["data" : paramsStr]
              let urlString:String = String(format: "%@%@", arguments: [BASE_URL,Save_Genuinity_Check_Result_Acviss])
              
//              print("the url",urlString)
//              print("the parms",params)
//              print("the headers",headers)
              
              Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                  SwiftLoader.hide()
//                  print("the response",response)
                  if response.result.error == nil {
                      if let json = response.result.value {
                          print(json)
                          let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                         
                          if responseStatusCode == STATUS_CODE_200{
                              let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                              let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                              print("The decryptData is here:",decryptData)
                              let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString)
                              completionHandler(true,decryptData,msg as String? ?? "")
                          }
                          else if responseStatusCode == STATUS_CODE_205{
                              let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                              let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                              let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString)
                              completionHandler(true,decryptData,"205")
                          }
                          else if responseStatusCode == FAB_MASTER_DETAILS_BASED_ON_STATENAME_STATUS_CODE_301{
                              if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                  completionHandler(false, NSDictionary(),"Unknown error occurred")
                              }
                          }
                          else if responseStatusCode == STATUS_CODE_105{
                              if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                  print(msg)
  //                               self.view.makeToast(msg)
                              
                              }
                          }
                          else if responseStatusCode == STATUS_CODE_601{
                              Constatnts.logOut()
                              if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                  print(msg)
                              }
                          }
                          else{
                              completionHandler(false, NSDictionary(),"Unknown error occurred")
                          }
                          
                      }
                      else{
                          completionHandler(false, NSDictionary(),"Unknown error occurred")
                      }
                  }
                  else{
                      print((response.error?.localizedDescription) ?? "")
                      //self.view.makeToast((response.error?.localizedDescription)!)
                  }
              }
          }
      }
    
    
       //SubmitAcvission Barcode Result Data to server
    class func submitScannedAcvissBarcodeResultDataToServerNewSampleTracking(scanResult: Dictionary<String,Any>?,completeResponse : String,selectedLabel: String , moduleType: String, responseCode: Int, completionHandler:@escaping (_ status:Bool?,_ dictionary: NSDictionary?,_ message:String?)-> Void){
        
        if scanResult != nil {
            let headers = Constatnts.getLoggedInFarmerHeaders()
            let productDetails = scanResult?["product_details"] as? Dictionary<String,Any>
            let arrProductSpecs = productDetails?["specifications"] as? NSArray
            var batchNo = ""
            var mfg_date = ""
            var expiry_date = ""
            var product_points = ""
        
            let userData = Constatnts.getUserObject()
            var parameters = ["deviceType":"iOS","appName":"FC","referrer":userData.deepLinkingString,"userPacketLabel":selectedLabel,"moduleType": moduleType,"complete_response": completeResponse, "responseCode":responseCode] as NSMutableDictionary
            SwiftLoader.show(animated: true)
            let paramsStr = Constatnts.nsobjectToJSON(parameters as NSMutableDictionary)
            let params =  ["data" : paramsStr]
            let urlString:String = String(format: "%@%@", arguments: [BASE_URL,Save_Genuinity_Check_Result_Acviss_SampleTracking])
            
            Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                SwiftLoader.hide()
                if response.result.error == nil {
                    if let json = response.result.value {
                        print(json)
                        let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                       
                        if responseStatusCode == STATUS_CODE_200{
                            let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                            let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                            print("The decryptData is here888:",decryptData)
                            let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString)
                            completionHandler(true,decryptData,msg as String? ?? "")
                        }
                        else if responseStatusCode == STATUS_CODE_205{
                            let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                            let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                            let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString)
                            completionHandler(true,decryptData,"205")
                        }
                        else if responseStatusCode == FAB_MASTER_DETAILS_BASED_ON_STATENAME_STATUS_CODE_301{
                            if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                completionHandler(false, NSDictionary(),"Unknown error occurred")
                            }
                        }
                        else if responseStatusCode == STATUS_CODE_105{
                            if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                print(msg)
                            
                            }
                        }
                        else if responseStatusCode == STATUS_CODE_601{
                            Constatnts.logOut()
                            if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                print(msg)
                            }
                        }
                        else{
                            completionHandler(false, NSDictionary(),"Unknown error occurred")
                        }
                        
                    }
                    else{
                        completionHandler(false, NSDictionary(),"Unknown error occurred")
                    }
                }
                else{
                    print((response.error?.localizedDescription) ?? "")
                }
            }
        }
    }
    
    //submitScannedUniquoBarcodeResultDatRHRD,CEP{
    class func submitScannedUniquoBarcodeResultDataToServerRHRDCEP(scanResult: Dictionary<String,Any>?,userMessage:String,moduleType: String,completeResponse : String,selectedLabel: String, responseCode: Int,completionHandler:@escaping (_ status:Bool?,_ dictionary: NSDictionary?,_ message:String?)-> Void){
        
        if scanResult != nil {
            let headers = Constatnts.getLoggedInFarmerHeaders()
            let productDetails = scanResult?["product_details"] as? Dictionary<String,Any>
            let arrProductSpecs = productDetails?["specifications"] as? NSArray
            var batchNo = ""
            var mfg_date = ""
            var expiry_date = ""
            var product_points = ""
            
            //            for i in 0..<arrProductSpecs?.count{
            /*if arrProductSpecs != nil && arrProductSpecs?.count ?? 0 > 0 {
                for i in 0...arrProductSpecs!.count-1{
                    let product = arrProductSpecs![i] as? NSDictionary
                    
                    if product?.object(forKey: "batch_number") != nil {
                        batchNo = product?.object(forKey: "batch_number") as? String ?? ""
                    }
                    if product?.object(forKey: "mfg_date") != nil {
                        mfg_date = product?.object(forKey: "mfg_date") as? String ?? ""
                    }
                    if product?.object(forKey: "expiry_date") != nil {
                        expiry_date = product?.object(forKey: "expiry_date") as? String ?? ""
                    }
                    if product?.object(forKey: "product_points") != nil {
                        product_points = product?.object(forKey: "product_points") as? String ?? ""
                    }
                }
            }*/
            let userData = Constatnts.getUserObject()
           /* var parameters = ["responseCode":scanResult?["responseCode"],"message":scanResult?["message"] ,"serialNumber":scanResult?["serialNumber"],"codeLogId":scanResult?["codeLogId"] ?? "","deviceType":"iOS","userMessage":userMessage,"appName":"FC","productName" : productDetails?["product_name"] ?? "","productId" : productDetails?["product_id"] ?? "", "productSKU" : productDetails?["product_sku"] ?? "","productDescription" : productDetails?["product_description"], "referrer":userData.deepLinkingString,"moduleType": moduleType] as NSMutableDictionary
            
            parameters.addEntries(from: ["productPrice" : productDetails?["product_price"] ?? "","productAndroidAR" : productDetails?["android_ar"] ?? ""])
            
            parameters.addEntries(from: ["productManufacturingdate" : mfg_date, "productExpiryDate" : expiry_date,"complete_response": completeResponse,"productIosAr" : productDetails?["ios_ar"] ?? "", "productPoints" : product_points,"productBatchNo" : batchNo])
            
            parameters.addEntries(from: ["userPacketLabel": selectedLabel])*/
            
            //Acviss
            var parameters2 = ["deviceType":"iOS","appName":"FC","referrer":userData.deepLinkingString,"userPacketLabel":selectedLabel,"moduleType": moduleType,"complete_response": completeResponse, "responseCode":responseCode] as NSMutableDictionary
            
            //print(parameters)
            
            SwiftLoader.show(animated: true)
            let paramsStr = Constatnts.nsobjectToJSON(parameters2 as NSMutableDictionary)
            let params =  ["data" : paramsStr]
            let urlString:String = String(format: "%@%@", arguments: [BASE_URL,Save_Genuinity_Check_Result_Acviss]) // "http://192.168.3.141:8080/ATP/rest/" nithin
            
            Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                SwiftLoader.hide()
                if response.result.error == nil {
                    if let json = response.result.value {
                        print(json)
                        let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                        if responseStatusCode == STATUS_CODE_200{
                            let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                            let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                            let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString)
                            completionHandler(true,decryptData,msg as String? ?? "")
                        }
                        else if responseStatusCode == STATUS_CODE_205{
                            let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                            let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                            let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString)
                            completionHandler(true,decryptData,"205")
                        }
                        else if responseStatusCode == FAB_MASTER_DETAILS_BASED_ON_STATENAME_STATUS_CODE_301{
                            if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                completionHandler(false, NSDictionary(),"Unknown error occurred")
                            }
                        }
                        else if responseStatusCode == STATUS_CODE_105{
                            if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                print(msg)
//                               self.view.makeToast(msg)
                            
                            }
                        }
                        else if responseStatusCode == STATUS_CODE_601{
                            Constatnts.logOut()
                            if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                print(msg)
                            }
                        }
                        else{
                            completionHandler(false, NSDictionary(),"Unknown error occurred")
                        }
                        
                    }
                    else{
                        completionHandler(false, NSDictionary(),"Unknown error occurred")
                    }
                }
                else{
                    print((response.error?.localizedDescription) ?? "")
                    //self.view.makeToast((response.error?.localizedDescription)!)
                }
            }
        }
    }
    class func submitScannedUniquoBarcodeResultDataToServer(scanResult: Dictionary<String,Any>?,userMessage:String,completeResponse: String){
        if scanResult != nil {
            let headers = Constatnts.getLoggedInFarmerHeaders()
            let productDetails = scanResult?["productDetails"] as? Dictionary<String,Any>
            let arrProductSpecs = productDetails?["product_specifications"] as? NSArray
            var batchNo = ""
            var mfg_date = ""
            var expiry_date = ""
            var product_points = ""
            
            //            for i in 0..<arrProductSpecs?.count{
            if arrProductSpecs != nil {
                for i in 0...arrProductSpecs!.count-1{
                    let product = arrProductSpecs![i] as? NSDictionary
                    
                    if product?.object(forKey: "batch_number") != nil {
                        batchNo = product?.object(forKey: "batch_number") as? String ?? ""
                    }
                    if product?.object(forKey: "mfg_date") != nil {
                        mfg_date = product?.object(forKey: "mfg_date") as? String ?? ""
                    }
                    if product?.object(forKey: "expiry_date") != nil {
                        expiry_date = product?.object(forKey: "expiry_date") as? String ?? ""
                    }
                    if product?.object(forKey: "product_points") != nil {
                        product_points = product?.object(forKey: "product_points") as? String ?? ""
                    }
                }
            }
            
            var parameters = ["responseCode":scanResult?["responseCode"],"message":scanResult?["message"] ,"serialNumber":scanResult?["serialNumber"],"codeLogId":scanResult?["codeLogId"] ?? "","deviceType":"iOS","userMessage":userMessage,"appName":"FC","productName" : productDetails?["product_name"] ?? "","productId" : productDetails?["product_id"] ?? "", "productSKU" : productDetails?["product_sku"] ?? "","productDescription" : productDetails?["product_description"]] as NSMutableDictionary
            
            parameters.addEntries(from: ["productPrice" : productDetails?["product_price"] ?? "","productAndroidAR" : productDetails?["android_ar"] ?? ""])
            
            parameters.addEntries(from: ["productManufacturingdate" : mfg_date, "productExpiryDate" : expiry_date,"complete_response": completeResponse,"productIosAr" : productDetails?["ios_ar"] ?? "", "productPoints" : product_points,"productBatchNo" : batchNo])
            
            
            let paramsStr = Constatnts.nsobjectToJSON(parameters as NSMutableDictionary)
            let params =  ["data" : paramsStr]
            let urlString:String = String(format: "%@%@", arguments: ["http://192.168.3.141:8080/ATP/rest/",Save_Genunity_Check_Result])
            
            Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                //SwiftLoader.hide()
                if response.result.error == nil {
                    if let json = response.result.value {
                        print(json)
                        let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                        if responseStatusCode == STATUS_CODE_200{
                            //let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                            //let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                            //print("Response after decrypting data:\(decryptData)")
                        }
                        else if responseStatusCode == FAB_MASTER_DETAILS_BASED_ON_STATENAME_STATUS_CODE_301{
                            if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                print(msg)
                            }
                        }
                        else if responseStatusCode == STATUS_CODE_601{
                            Constatnts.logOut()
                            if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                print(msg)
                            }
                        }
                    }
                }
                else{
                    print((response.error?.localizedDescription) ?? "")
                    //self.view.makeToast((response.error?.localizedDescription)!)
                }
            }
        }
    }
    
//    class func submitScannedUniquoBarcodeResultDataToServerForRetailer(scanResult: Dictionary<String,Any>?,completeResponse: String){
        
        class func submitScannedUniquoBarcodeResultDataToServerForRetailer(scanResult: Dictionary<String,Any>?,completeResponse : String,selectedRetailerId : String, selectedRetailerName : String, selectedRetailerCode : String,responseCode: Int, completionHandler:@escaping (_ status:Bool?,_ dictionary: NSDictionary?,_ message:String?)-> Void){
            
            print("what is coming in scanResult",scanResult)
        if scanResult != nil {
            let headers = Constatnts.getLoggedInFarmerHeaders()
            let productDetails = scanResult?["productDetails"] as? Dictionary<String,Any>
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.myOrientation = .portrait
            let userObj = Constatnts.getUserObject()

            let farmerMobileNumberIs = userObj.mobileNumber as String?
            let farmerNameIs = userObj.firstName as String?

                        let appName = "FC"
                        let deviceType = "iOS"
                        let farmerMobileNo = farmerMobileNumberIs
                        let farmerName = farmerNameIs
                        let latLongValues = ""//productDetails?["product_description"]
                        let linkageRecordId = "0"
                        let lumiviaServReqRecordID = "0"
                        let moduleType = ""
                        let responseCode = responseCode//scanResult?["responseCode"]
                        let retailerCode = selectedRetailerCode
                        let retailerId = selectedRetailerId
                        let retailerName = selectedRetailerName
            
//                    let appName = "FC"
//                    let complete_response = ""
//                    let deviceType = "iOS"
//                    let farmerMobileNo = ""
//                    let farmerName = ""
//                    let latLongValues = ""//productDetails?["product_description"]
//                    let linkageRecordId = "0"
//                    let lumiviaServReqRecordID = "0"
//                    let moduleType = ""
//                    let responseCode = "0"//scanResult?["responseCode"]
//                    let retailerCode = "1001"
//                    let retailerId = "1"
//                    let retailerName = "Kiran (KIR1001)"
//                        
            let parameters = ["appName":appName,"deviceType":deviceType,"farmerMobileNo":farmerMobileNo,"farmerName":farmerName,"latLongValues":latLongValues,"linkageRecordId":linkageRecordId,"lumiviaServReqRecordID":lumiviaServReqRecordID,"moduleType":moduleType,"responseCode":responseCode,"retailerCode" : retailerCode,"retailerId" : retailerId,"retailerName" : retailerName]  as NSMutableDictionary
                        
                        print("what all data is coming here params",parameters)
            
                        parameters.addEntries(from: [ "complete_response": completeResponse])


            let paramsStr = Constatnts.nsobjectToJSON(parameters as NSMutableDictionary)
            let params =  ["data" : paramsStr]
            let urlString:String = String(format: "%@%@", arguments: [BASE_URL,Tracker_RetailerCode])
            
            Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
        
                if response.result.error == nil {
                    if let json = response.result.value {
                        print(json)
                        let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
                        if responseStatusCode == STATUS_CODE_200{
                       print("coming success here")
                            let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                            let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                            let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString)
                            completionHandler(true,decryptData,msg as String? ?? "")
                        }
                        else if responseStatusCode == FAB_MASTER_DETAILS_BASED_ON_STATENAME_STATUS_CODE_301{
                            if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                print(msg)
                            }
                        }
                        else if responseStatusCode == STATUS_CODE_601{
                            Constatnts.logOut()
                            if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                print(msg)
                            }
                        }
                        else{
                            print("it is coming here nandudd 007",((json as! NSDictionary).value(forKey: "message") as? NSString)!)
//                            self.view.makeToast((response.error?.localizedDescription)!)
                           
                            if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                print(msg)
                                completionHandler(false,NSDictionary(),msg as String? ?? "")
//                                completionHandler(false, NSDictionary(),"Unknown error occurred")
                            }
                        }
                    }
                }
                else{
                    print((response.error?.localizedDescription) ?? "")
                }
            }
        }
    }
}
/*
 class func submitScannedUniquoBarcodeResultDataToServer(scanResult: UQScanResults?,userMessage:String){
 if scanResult != nil {
 let headers = Constatnts.getLoggedInFarmerHeaders()
 let parameters = ["responseCode":scanResult?.responseCode ?? "","message":scanResult?.message ?? "","productDetails":scanResult?.productDetails ?? "","serialNumber":scanResult?.serialNo ?? "","codeLogId":scanResult?.codeLogId ?? "","deviceType":"iOS","userMessage":userMessage,"appName":"FC"] as NSDictionary
 print(parameters)
 let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
 let params =  ["data" : paramsStr]
 let urlString:String = String(format: "%@%@", arguments: [BASE_URL,Save_Genunity_Check_Result])
 Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
 //SwiftLoader.hide()
 if response.result.error == nil {
 if let json = response.result.value {
 print(json)
 let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as? String ?? ""
 if responseStatusCode == STATUS_CODE_200{
 //let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
 //let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
 //print("Response after decrypting data:\(decryptData)")
 }
 else if responseStatusCode == FAB_MASTER_DETAILS_BASED_ON_STATENAME_STATUS_CODE_301{
 if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
 print(msg)
 }
 }
 else if responseStatusCode == STATUS_CODE_601{
 Constatnts.logOut()
 if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
 print(msg)
 }
 }
 }
 }
 else{
 print((response.error?.localizedDescription) ?? "")
 //self.view.makeToast((response.error?.localizedDescription)!)
 }
 }
 }
 }
 
 }
 */
