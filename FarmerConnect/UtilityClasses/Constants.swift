//
//  Constatnts.swift
//  PioneerEmployee
//
//  Created by Empover on 08/09/17.
//  Copyright © 2017 Empover. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Alamofire

extension Int64 {
    func dateFromMilliseconds(format:String) -> String {
        let date : NSDate! = NSDate(timeIntervalSince1970:Double(self) / 1000.0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        let timeStamp = dateFormatter.string(from: date as Date)
        
        /*let formatter = DateFormatter()
         formatter.dateFormat = format
         return ( formatter.date( from: timeStamp ) )!*/
        return timeStamp
    }
}

let SUCCESS_STATUS_CODE_100 = 100
let STATUS_CODE_101 = "101" //User doesn't exists
let INVALID_USER_STATUS_CODE_102 = "102" //User not exist but exist in other DB
let ALREADY_LOGIN_STATUS_CODE_103 = "103"
let RESEND_OTP_SUCCESS_STATUS_CODE_5 = 5
let RESEND_OTP_SUCCESS_STATUS_CODE_15 = 15
let INVALID_OTP_2 = 2
let STATUS_CODE_200 = "200"
let STATUS_CODE_205 = "205"
let CDI_FEEDBACK_STATUS_CODE_200 = 200
let STATUS_CODE_804 = "804"
let STATUS_CODE_122 = "122" //OTP Expired
let STATUS_CODE_123 = "123" //OTP Invalid
let STATUS_CODE_124 = "124" // Pincode InValid
let STATUS_CODE_163 = 163 //This product label is already registered
let STATUS_CODE_158 = 158 //Coupon already alloted to this farmer
let STATUS_CODE_159 = 159 //Dear farmer, The coupon which you entered is already redeemed
let STATUS_CODE_160 = 160 //No coupons available
let STATUS_CODE_161 = 161 //Coupons can be shared to farmers only
let STATUS_CODE_500 = "500" //Unable to process your request.
let STATUS_CODE_100 = 100 // Success dotnet
let FAB_MASTER_DETAILS_BASED_ON_STATENAME_STATUS_CODE_301 = "301"
let FAB_MASTER_DETAILS_NO_CHANGE_IN_CURRENT_VERSION_302 = 302
let CROP_ADVISORY_NOT_AVAILABLE = 151
let CROP_DIAGNOSIS_DISEASE_NOT_FOUND_401 = 401
let STATUS_CODE_NO_BOOKLETS_AVAILABLE_157 = 157
let CROP_ADVISORY_NOT_AVAILABLE_151 = "151"
let STATUS_CODE_601 = "601"
let STATUS_CODE_105 = "105"
let STATUS_CODE_300 = "300"
let STATUS_CODE_1 = "1"
var unReadnotifications = String()
let cropTypeId = "cropTypeId"
let cropPhaseId = "cropPhaseId"
let stageId = "caSatgeId"
let MISSED_CALL_VERIFICATION_NUMBER = "+918688929929"
let APP_NAME = "FC"
/******** MANDIS URL **************/
//var Main_URL = "https://data.gov.in/api/datastore/resource.json?resource_id=9ef84268-d588-465a-a308-a864a43d0070&api-key=5a328bd84966903f2aaf8ce8ee8379c7"
//var Main_URL = "https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070?format=json&api-key=579b464db66ec23bdd00000124ebac6c2fd04e37507a63cc90ef48b8"
var Main_URL = "mandiPrices/getMandiPricesStateNames"
//"https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070?format=json&api-key=579b464db66ec23bdd00000124ebac6c2fd04e37507a63cc90ef48b8"
var GET_MANDIES = "mandiPrices/getMandiPricesMarketsByState"
var GET_COMMODITIES = "mandiPrices/getMandiPricesCommoditesByStateAndMarket"
var GET_COMMODITIES_PRICES = "mandiPrices/getMandiPricesByStateAndMarketAndCommodities"

var GET_CROPS = "mandiPrices/getMandiPricesCropNames"
var GET_STATES_BY_CROP  =  "mandiPrices/getMandiPricesStateByCommodity"
var GET_PRICES_BY_COMMODITIES_STATE  = "mandiPrices/getMandiPricesByCommodityAndState"
/**********************************/
let Crop_Advisori_Registration_new = "CASubscriptionFilterViewController"

/**** Used for response status codes & messages ******/
var DOTNET_STATUS_CODE_KEY = "respCd"
var DOTNET_RESPONSE_DATA_KEY = "data"
var DOTNET_RESPONSE_MESSAGE_KEY = "respMsg"

var JAVA_STATUS_CODE_KEY = "statusCode"
var JAVA_RESPONSE_DATA_KEY = "response"
var JAVA_RESPONSE_MESSAGE_KEY = "message"
/**** Used for response status codes & messages ******/

//MARK:Farmer Connect Development URI

//var NEWS_BASEURL = "http://192.168.3.35/RMAServiceAPI.asmx/" // Test Bhavani
//var NEWS_BASEURL = "http://pioneer.empover.com/RMAServiceAPI.asmx/" // Test 50 server
//var BASE_URL = "http://192.168.3.113:8090/ATP/rest/" //Testing
//var BASE_URL = "http://192.168.3.184:8080/ATP/rest/" //Testing Jagadeesh
//var BASE_URL = "http://192.168.3.236:9090/ATP2018/rest/" //Testing 236 public IP
//var BASE_URL = "http://182.73.10.4:9090/ATP/rest/" //Testing public IP
//var BASE_URL = "http://182.73.10.4:9090/MEC/rest/" //Testing public IP
// var BASE_URL = "http://192.168.3.157:8080/CDI/rest/" //Testing Vivek
//var BASE_URL = "http://192.168.3.236:9090/ATPTEST/rest/" //Testing 9090 Public IP

/********************************************/

/******** CDI URI **************/
//var CDI_BASE_URL = "http://182.73.10.3:8090/CDI/rest/" //Testing
//var CDI_BASE_URL = "http://192.168.3.157:8080/CDI/rest/" //Testing Vivek
//var CDI_BASE_URL = "http://192.168.3.185:8080/CDI/rest/" //Testing
//var CDI_BASE_URL = "http://192.168.3.214:9090/CDI/rest/" //Testing

/******** Paramarsh URI ********/
/*
var PARAMARSH_BASE_URL = "http://192.168.3.236:9090/IMS/" //Testing
let Google_API_Key = "AIzaSyD5C56h14UJNnJ_IFs0zxG_efMQPF-usX4"
*/

//MARK: Farmer Connect Production URIs
//
/*
var BASE_URL = "http://192.168.3.184:9090/ATP/rest/"//LIVE
=======
var BASE_URL = "http://103.24.202.200:9090/ATP/rest/"//LIVE
var NEWS_BASEURL = "http://pioneerparivaar.com/RMAServiceAPI.asmx/" //Live

var CDI_BASE_URL = "http://103.24.202.7:9090/CDI/rest/" // Live
var PARAMARSH_BASE_URL = "http://103.24.202.200:9090/IMS/" //Live

let Google_API_Key = "AIzaSyA8Orrd62f0b1wmKAkqFVJecwO55vmFWws" //Live
*/
//http://192.168.3.141:8080/ATP/rest/
//"AIzaSyA8Orrd62f0b1wmKAkqFVJecwO55vmFWws"

// Test URLS live 2021

/*var BASE_URL = "http://pioneeractivity.in/rest/"//LIVE
var NEWS_BASEURL = "http://169.38.110.103:7070/RMAServiceAPI.asmx/" //"http://test.pioneerparivaar.com/RMAServiceAPI.asmx/" //"http://pioneerparivaar.com/RMAServiceAPI.asmx/" //Live
var CDI_BASE_URL = "http://pioneercdi.in/rest/" // "http://192.168.3.108:8080/CDI/rest/" // Live
var PARAMARSH_BASE_URL =  "http://pioneerparamarsh.com/" //"http://192.168.3.108:8080/IMS/" //Live*/

//MARK: Farmer Connect Production URIs

//<<<<<<< HEAD
//var BASE_URL = "http://pioneeractivity.com/rest/"//LIVE
//var NEWS_BASEURL = "http://169.38.110.105:7070/RMAServiceAPI.asmx/"  //"http://pioneerparivaar.com/RMAServiceAPI.asmx/" //Live
//var CDI_BASE_URL = "http://pioneercdi.com/rest/" // "http://192.168.3.108:8080/CDI/rest/" // Live
//var PARAMARSH_BASE_URL =  "http://pioneerparamarsh.com/" //"http://192.168.3.108:8080/IMS/" //Live
//=======
//var BASE_URL = "http://uat.pioneeractivity.in/rest/" //"http://pioneeractivity.in/rest/"//LIVE
//var NEWS_BASEURL = "http://169.38.110.105:7070/RMAServiceAPI.asmx/" //"http://test.pioneerparivaar.com/RMAServiceAPI.asmx/" //"http://pioneerparivaar.com/RMAServiceAPI.asmx/" //Live
//var CDI_BASE_URL = "http://pioneercdi.com/rest/" // "http://192.168.3.108:8080/CDI/rest/" // Live
//var PARAMARSH_BASE_URL =  "http://pioneerparamarsh.com/" //"http://192.168.3.108:8080/IMS/" //Live
var BASE_URL_NEARBY = "http://pioneeractivity.com/"
var NEAR_BY = "datasync/getLocationPlottingPage?"
var GET_NEARBY_LOCAL_DATA = "locIntelligence/getDataBasedOnLatLangs"

//var BASE_URL_near =  BASE_URL_NEARBY
//MARk :- Test Credentials

/*var BASE_URL = "http://pioneeractivity.com/rest/"
var CDI_BASE_URL =  "http://pioneercdi.com/rest/"
var PARAMARSH_BASE_URL = "http://pioneerparamarsh.com/"
var NEWS_BASEURL = "http://169.38.110.105:7070/RMAServiceAPI.asmx/" //http://test.pioneerparivaar.com/RMAServiceAPI.asmx/ */
//let Google_API_Key = "AIzaSyA8Orrd62f0b1wmKAkqFVJecwO55vmFWws"


//* URLS START HERE *//

//-----------------------------------//
//* 2021 * TEST BASE URL Crdeentials *//
// --------------------------------- //

var BASE_URL = "https://pioneeractivity.in/rest/"
//"https://pioneeractivity.in/RGL/rest/"
//"https://uat.pioneeractivity.in/rest/"
//"https://pioneeractivity.in/rest/"
var NEWS_BASEURL = "https://test.pioneerparivaar.com/RMAServiceAPI.asmx/"   //"http://169.38.110.105:7070/RMAServiceAPI.asmx/" //"http://test.pioneerparivaar.com/RMAServiceAPI.asmx/" //"http://pioneerparivaar.com/RMAServiceAPI.asmx/" //Live
var CDI_BASE_URL = "https://pioneercdi.com/rest/" // "http://192.168.3.108:8080/CDI/rest/" // Live
var PARAMARSH_BASE_URL =  "https://pioneerparamarsh.com/" //"http://192.168.3.108:8080/IMS/" //Live


//-----------------------------------//
//* 2021 * Live BASE URL Crdeentials *//
// --------------------------------- //

//var BASE_URL = "https://pioneeractivity.com/rest/"
//var NEWS_BASEURL = "https://169.38.110.105:7070/RMAServiceAPI.asmx/"
////https://test.pioneerparivaar.com/RMAServiceAPI.asmx/
//var CDI_BASE_URL =  "https://pioneercdi.com/rest/"
//var PARAMARSH_BASE_URL = "https://pioneerparamarsh.com/"
 
//* URLS END HERE *//

//MARK:- Test Credentials End

let CASH_FREE_ECOUPON_PAYMENTMODE_REQUEST =
"cashFreeReward/ecouponCashFreePaymentModeRequest"
let Google_API_Key = "AIzaSyCsVl8HKz5Fh6PxE11gHtJzQwDjf8xYMAE"
let CASH_FREE_RETAILER_MOBILE = "/cashFreeReward/getRetMdoDetails"
var PRIVACY_POLICY_URL = "https://www.corteva.us/privacy-policy.html"
var TERMS_CONDITIONS_URL = "https://www.corteva.com/terms-and-conditions.html"

var CDI_CUSTOMER_FEEDBACK = "disease/customerFeedbackNew"
var PARAMARSH_TICKET_DETAILS = "unauthorised/getTicketInfoNew"
var PARAMARSH_RAISE_TICKET = "unauthorised/raiseTicketNew"//raise and upload data
var PARAMARSH_MASTER_DATA = "unauthorised/getMasterDataNew"
var LOGIN_GET_COUNTRIES_LIST = "customer/getCountriesList"
var LOGIN_GET_LANGUAGES_LIST = "language/getAllLanguages"
var LOGIN_SEND_OTP = "customer/sendOTP"
var NOTIFICATIONS = "pushNotification/getAllPushNotifications"
/// Notifications

var GETALL_NOTIFICATIONs = "pushNotification/getAllPushNotifications"
var DELETE_NOTIFICATIONS = "pushNotification/deletePushNotifications"

var LOGIN_RESEND_OTP = "customer/resendOTP"
var LOGIN_VERIFY_OTP = "customer/validateOTP"
var INFORM_MOBILE_VIA_MISSED_CALL = "customer/informUserForMissCallVerification"
var VERIFY_MOBILE_NUMBER_VIA_MISSED_CALL = "customer/validateThroughMissCall"
var SEND_OTP_TO_WHATSAPP = "customer/sendOTPByWhatsApp"
var GET_LOCATION_FROM_PINCODE = "customer/getTheLocationDetailsBasedOnPincode"
var REGISTER_USER = "customer/registerCustomer"
var GET_CROP_NOTIFICATIONS = "cropAdvisory/getNotificationsOfCropAdvisory"
var FORCE_UPDATE_MOBILE_VERSION_DATA = "farmerConnectAppVersion/checkForAppUpdate"//"GetForceUpdateMobileVersionDataEmp"
var GET_CROP_ADVISORY_DATA = "cropAdvisory/getCropAdvisoryDetails"
var REGISTER_CROP_ADVISORY_DATA = "cropAdvisory/subscribeCropAdvisory"
var GET_FAB_MASTER_DETAILS = "fab/getFABMasterDetails"
var GET_NEWS_FROM_DOTNET_SERVER = "GetCortevaAgriScience_News"
var GET_PENDING_PROFILE_UPDATE_STATUS = "customer/pendingCustomerProfile"
var WHATSUP_OPT_IN_REGISTRATION = "whatsappOptin/insertWhatsAppOptin"

var FAB_ALERT_MESSAGE = "Currently your internet is off. You will only be able to view already downloaded features and benefits. Switch on your internet to view other crops features and benefits."

var GET_FAB_DETAILS = "fab/getFABDetails"

var GET_FAB_CP_MASTER_DETAILS = "fab/getCpFabMaster"
var GET_FAB_CP_DETAILS = "fab/getCpFABDetails"

var GET_BOOKLETS = "booklets/getPravaktaBooklets"

var GET_ON_BOARD_SCREENS = "farmerConnectAppVersion/onBoardScreenMasterData"

var LOGOUT = "logout/logoutTheCustomer"

var CROP_DIAGNOSIS_REQUEST = "disease/cropDiagnosisRequest"

var CROP_DIAGNOSIS_MASTER_DATA = "disease/syncData"

var CROP_DIAGNOSIS_MULTIPART = "disease/cropDiagnosisRequestEmpMultipart"

var CDI_CROP_DIAGNOSIS_GETDISEASE_PRODUCT_DESC = "cropDiagnosis/getDiseaseRelatedAgroProductDataAndPrescription"

var CDI_GETPRODUCTS_DESCRIPTION_BY_PRODUCTID = "products/getProductsDescriptionByProductId"

var CDI_GET_FARMERPLOADED_DISEASE = "disease/farmerUploadedDiseaseDetails"

var GET_CROPS_MASTERDATA = "customer/getMasterForCustomerInfoUpdation"

var GET_TYPE_FARMER = "customer/getFarmerTypesForRegistration"

var GET_CASHFREE_SUCCESS_TRANSACTION_DETAILS = "cashFreeReward/getAllTransactionsWithReferrenceId"

var User_DeviceToken_registration = "customer/updateDeviceToken"
let User_Profile_Master_Data = "customer/mastersForEditProfile"
let User_Profile_Update_Data = "customer/updateCustomerProfile"
let Get_Crop_Calculator_Master = "cropCalculator/getCropCalculatorMasterData"
let Sync_CropCalculations = "cropCalculator/syncCropCalculatorTransactionData"

let Save_Genunity_Check_Result = "customer/saveGenuinityCheckDetails_V2"
let Save_Genuinity_Check_Result_Acviss = "customer/saveGenuinityCheckDetails_V2_acviss"
let Save_Genuinity_Check_Result_Acviss_SampleTracking = "customer/saveGenuinityCheckDetailsForSampleProduct"
let CASH_FREE_PAYMENTMODE_REQUEST = "cashFreeReward/cashFreePaymentModeRequest_V2"
let CASH_FREE_PAYMENTMODE_REQUEST_SEED = "cashFreeReward/seedCashFreePaymentModeRequest_V2"
let Tracker_RetailerCode = "customer/requestProcessForDelegateAndTracerProgramWithRetailerCode"

let Get_User_Rewards = "cashFreeReward/getCashFreeTransactionPendingRequest_V2"

let GET_GERMINATION_LIST = "germination/getGerminationMasterOfFarmer"//"germination/getGerminationListOfFarmer"
let SUBMIT_GERMINATION_AGREEMENT = "germination/submitGerminationForm"
let SUBMIT_GERMINATION_CLAIM = "germination/submitGerminationClaim"
let STATUS_AGREEMENT_PENDING = "Agreement Pending"
let STATUS_CLAIMED = "Claimed"
let STATUS_TO_BE_CLAIMED = "To Be Claimed"
let GERMINATION_AGREEMENT_SUBMITTED_MSG = "Agreement submitted successfully"

//MARK:- Farmer Dashboard
var FARMER_DETAILS_BASED_ON_MOBILE = "farmerDashboard/getSingleFarmerDashBoardDataByMobileNo"
var FARMER_ACTIVITY_TIMELINE = "farmerDashboard/getFarmerDashboardActivitiesGraphData"
var FARMER_ADD_PRODUCT = "farmerDashboard/getFarmerDashBoardBroughProductFilter"
var FARMER_SAVE_PRODUCT = "farmerDashboard/saveBoughtProductsInfo"
var CA_GET_MASTER_ADD_SUBSCRIPTION_DROPDOWN_V2 = "cropAdvisory/getCropAdvisoryDetails_V2"
var CA_GET_CROPLIST = "cropAdvisory/getCropAdvisoryCropFilter"
var CA_GET_MASTER_ADD_SUBSCRIPTION_DROPDOWN = "cropAdvisory/getCropAdvisoryDetails"
var CA_GET_ORIGINALIMAGE_AND_SUBIMAGES = "cropAdvisory/getCropAdvisoryOriginalAndSubImageDetails"
var CA_GET_SUB_ORIGINALIMAGE_AND_SUBIMAGES = "cropAdvisory/getCropAdvisorySubImagesAndDataDetails"
var CA_GET_SUBSCRIBED_USER_DETAILS = "cropAdvisory/getCASubscribedUserDetails"
var CA_GET_DATA_DETAILS = "cropAdvisory/getCropAdvisoryDataDetails"
var CA_SAVE_LOGEVENTS = "datasync/saveLoginEvents"
var GET_CA_SUSBSCRIPTION_CROPTYPE = "cropAdvisory/getCropAdvisoryCropTypeDetails"
var CA_GET_SUBIMAGES_DATADETAILS = "cropAdvisory/getCropAdvisorySubImagesAndDataDetails"
var CA_SUBSCRIBE_ADVISORY = "cropAdvisory/subscribeCropAdvisory_V2"



var GET_CROP_MASTER = "cropAdvisory/getAllCrops"
var SUBMIT_SPRAY_SERVICE_REQUEST = "cropAdvisory/sprayServiceRequest"
var GET_RETAILERS = "Spary/getRetaillers"
var UPLOAD_RETAILERINFO = "cropAdvisory/uploadBillingOfBuyedSeed"
var UPLOAD_RETAILERINFO_WITHOUTIMAGE = "cropAdvisory/uploadBillingOfBuyedSeed_v2"
var GET_SPRAY_VENDORS = "/Spary/sprayVendorOrderList"
var SUBMIT_FEEDBACK = "Spary/sprayVendorOrderCompletsConfirmation"
var GET_MANDAL_AND_VILLAGES_PINCODE = "/Spary/getMasteForRetailer"
var SPRAY_REQUESTER_ORDERS_LIST = "/Spary/sprayRequesterOrderConfirmation"
var Spray_REQUESTER_FEEDBACK_SUBMISSION = "/Spary/submitFeedBackBysprayRequester"
var GET_DATA_REQUESTOR_BASEDON_TASKID = "Spary/getDataForRequesterBasedOnTaskId"

var GET_VENDOR_DATA_TO_SUBMIT_FEEDBACK = "Spary/getVendorDataForRequesterFeedBack"

var GET_SprayCycleStatus =  "Spary/sprayRequesterStatusOfBookingStages"
var GET_NumberOfScansRequester = "Spary/getNumberOfScans"
var SUBMIT_NumberOfScansRequester = "Spary/SaveNumberOfScans"

var GET_SprayCycleStatusDetails = "Spary/sprayRequesterBookingStagesDetails"

var GET_GENUINITYCHECK_REPORTS = "customer/pravaktaGenunityCouponScanData"
var SUBMIT_PRAVAKTA_FEEDBACK = "customer/pravaktaFeedBackOnFC"


var LOGIN_USER_ACCEPTANCE_KEY_0 = "0"

var LOGIN_USER_ACCEPTANCE_KEY_1 = "1"

var LOGIN_NAME = "EMP"
var LOGIN_APP_NAME = "EMP"
let DEVICE_TYPE = "iOS"

// Whats'up Opt-In
let AUTHKEY_NEWUSER = "4fd75c93b17f9cee"
let AUTHKEY_OLDUSER = "f53b0b6ea82b09f4"
let METHODNAME_NEWUSER = "FarmerConnectAppNew"
let METHODNAME_OLDUSER = "FarmerConnectAppOld"
let SHAREWITH = "EMPOVER"

//CEP
var CEP_DASHBOARDMORE_API = "cep/getTotalActivitiesDashboardDetails"
var  GET_CEP_DASHBOARD_DETAILS = "cep/getFarmerCEPDashboardDetails"
var  GET_CEP_FARMERREERAL = "cep/cepFarmerReferral"
var  GET_CEP_PEST_DOWNLOADMASTER = "pest/downloadPestManagementMaster"
var  CEP_PEST_SUBMITDATA = "pest/uploadPestData"
var  CEP_PEST_UPLOADIMAGE =  "pest/uploadPestImages"
var  CEP_HEIGHEST_YIELD_COMPETITION =  "cep/highestYieldCompetition"
var CEP_fIELDSHARING = "cep/fieldPictureSharing"

//RHRD
var GET_RHRD_HOMEPAGE_DETAILS = "rhrd/getRHRDHomePageDetails"
var GET_RHRD_TOTALACTIVITIES_DASHBOARD = "rhrd/getTotalActivitiesDashboardDetails"
var GET_RHRD_REFERAL_DETAILS = "rhrd/chillyFarmerReferral"
var GET_RHRD_FIELDSHARING = "rhrd/fieldPictureSharing"
var GET_RHRD_SUCCESSTORY = "rhrd/rhrdSuccessStory"

//DelegateDostDhamaka
var GET_DDD_COUPON_DETAILS = "getDelegateDostDhamakaCouponData"

//User Log EVents Details
var SAVE_USER_LOG_EVENTS_MODULEWISE = "saveUserLogEventsModuleWise"

//PlanterServices
var GET_PLANTER_SERVICES_VENDOR_ORDER_LIST = "planterServices/planterServiceVendorOrderList"
var GET_PLANTER_DATA_FOR_VENDOR_BASED_ON_TASK_ID = "planterServices/getPlanterDataForVendorBasedOnTaskId"

var GET_PLANTER_SERVICES_REQUESTER_ORDER_LIST = "planterServices/planterServiceRequesterOrderList"
var GET_PLANTER_SERVICES_REQUESTER_FEEDBACKSUBMIT = "planterServices/submitFeedBackByRequester"

var PLANTER_SERVICE_ORDER_COMPLETION_CONFIRMATION = "planterServices/planterServiceVendorOrderCompletsConfirmation"
var PLANTER_SERVICES_ORDER_ACCEPT_OR_REJECT = "planterServices/orderAcceptOrReject"

//Sample Tracking
var GET_SAMPLE_TRACKING_LIST = "st/getHistoryList"
var POST_SAMPLE_TRACKING_SAVE_REQUEST = "st/saveRaiseRequestDetilsWithMultipart"


//MARK: Alert Messages
var Please_Enter_Valid_Otp = "Please Enter Valid OTP"
var Please_Enter_Otp = NSLocalizedString("enter_otp_hint", comment: "")//"Please Enter OTP" //NSLocalizedString("plase_enter_hint", comment: "")
var Otp_Sent_Successfully =  NSLocalizedString("otpsuc", comment: "")//"OTP Sent Successfully"
var Please_Enter_Mobile_Number =  NSLocalizedString("mobile_no_hint", comment: "")//"Please Enter Mobile Number"
var Please_Enter_First_Name = NSLocalizedString("plase_enter_hint", comment: "") +  NSLocalizedString("first_name", comment: "")//"Enter First Name"
var Please_Enter_Last_Name =  NSLocalizedString("plase_enter_hint", comment: "") +  NSLocalizedString("last_name", comment: "")//"Enter Last Name"
var howmanyAcres =  NSLocalizedString("cep_How_many_rice_Acres", comment: "")

var Please_Enter_EmailId =  NSLocalizedString("plase_enter_hint", comment: "") + NSLocalizedString("enter_valid_email_error", comment: "")//"Enter Valid EmailId"
var Please_Enter_Total_Crop =  NSLocalizedString("plase_enter_hint", comment: "") + NSLocalizedString("total_crop_acres", comment: "")//"Enter Total Crop Acres"
var Please_Enter_Acres_Sowed = NSLocalizedString("plase_enter_hint", comment: "") +  NSLocalizedString("registration_acressowed", comment: "")//"Enter Acres Sowed"
let Pincode_Characters_Limit = "Pincode should not be less than 6 characters."
let Total_Crop_Acres = NSLocalizedString("plase_enter_hint", comment: "") +  NSLocalizedString("total_crop_acres", comment: "")//"Enter total crop acres."
let Select_Village_Your_Location =  NSLocalizedString("plase_enter_hint", comment: "") + NSLocalizedString("check_location_error", comment: "")//"Please select your village location."
let Valid_Crop_Acres =  NSLocalizedString("enter_any_crop", comment: "")//"Please fill valid number in any crop field."
let Total_Crop_Acres_Sum =  NSLocalizedString("valid_total_acres_error", comment: "")//"Sum of all crop acres should not be more than total crop acres."
let Select_Any_Season =  NSLocalizedString("select_season_error", comment: "")//"Please select any season."
let Select_Any_Irrigation =  NSLocalizedString("select_one_irrigation", comment: "")//"Please select any one from refined/irrigation."
let Select_Any_Company =  NSLocalizedString("select_one_company", comment: "")//"Please select any one company seeds which you are using."
let Aadhar_Number = "Enter 12 digits Aadhaar Number"
let Enter_Planning_Acers = NSLocalizedString("plase_enter_hint", comment: "") + NSLocalizedString("planning_acres", comment: "")//"Please enter planning acers."
let Enter_Commercial_Fooder_Price =  NSLocalizedString("plase_enter_hint", comment: "") + NSLocalizedString("commercial_fodder_price", comment: "")//"Please enter Commercial Fodder Price (Rs./Qntl.)"
let Enter_Straw_Yield = NSLocalizedString("plase_enter_hint", comment: "") +  NSLocalizedString("straw_yield", comment: "")//"Please enter Straw Yield (Qntl./acre)"
let Enter_Commercial_Grain_Price = NSLocalizedString("plase_enter_hint", comment: "") +  NSLocalizedString("calculatorvalues_commercialgrainprice", comment: "")//"Please enter Commercial Grain Price (Rs./Qntl.)"
let Enter_Commercial_Grain_Yield = NSLocalizedString("plase_enter_hint", comment: "") +  NSLocalizedString("calculatorvalues_graincottonyield", comment: "")//"Please enter Grain/cotton Yield."
let Enter_Pestiside_Cost =  NSLocalizedString("plase_enter_hint", comment: "") +  NSLocalizedString("calculatorvalues_pesticidecost", comment: "")//"Please enter Pesticide Cost."
let Enter_Fertiliser_Cost = NSLocalizedString("plase_enter_hint", comment: "") +  NSLocalizedString("calculatorvalues_fertilisercost", comment: "")//"Please enter Fertiliser Cost."
let Enter_NoOf_Irrigations = NSLocalizedString("plase_enter_hint", comment: "") +  NSLocalizedString("no_irrigations", comment: "")//"Please enter No. of Irrigations."
let Enter_Irrigation_Cost =  NSLocalizedString("plase_enter_hint", comment: "") + NSLocalizedString("cost_irrigation", comment: "")//"Please enter Cost per Irrigation."
let Enter_NoOf_Labours_Count = NSLocalizedString("plase_enter_hint", comment: "") +   NSLocalizedString("total_no_of_labour", comment: "")//"Please enter Total no. of labourers reqd. in entire crop duration."
let Enter_Labour_Cost =  NSLocalizedString("plase_enter_hint", comment: "") + NSLocalizedString("labbour_cost_error", comment: "")//"Please enter Labour Cost."
let Enter_Seed_rate =  NSLocalizedString("plase_enter_hint", comment: "") + NSLocalizedString("enter_seed_rate_error", comment: "")//"Please enter Seed Rate (kg/acre)"
let Enter_Seed_Cost = NSLocalizedString("plase_enter_hint", comment: "") + NSLocalizedString("enter_seed_cost_error", comment: "")//"Please enter Seed Cost (Rs./kg)"
let Enter_Land_Preparation = NSLocalizedString("plase_enter_hint", comment: "") +  NSLocalizedString("calculatorvalues_landpreparationnurseryraising", comment: "")    //"Please enter Land Preparation/ Nursery Raising"
let Select_Year = NSLocalizedString("select_year", comment: "")   // "Select Year"
let YES   = NSLocalizedString("yes", comment: "")
let NO = NSLocalizedString("no", comment: "")
let PRIVACY_POLICY = NSLocalizedString("privacy_policy", comment: "")

var NO_OFFLINE_DATA_AVAILABLE = "No Offline Data Available"

var CROP_ADVISORY_SUCCESSFULLY_STORED = "Crop Advisory Successfully Stored"

var ALREADY_LOGIN_STATUS_MESSAGE = "This user is already logged in other device. If you login here,you will be logged out from that device.Do you want to proceed?"

var CROP_ADVISORY_ALERT_MESSAGE = "Currently your internet is off. You will only be able to view already downloaded Crop Advisories. Switch on your internet to view other Crops Advisories."

var DELETE_REPOSITORY_ALERT_MESSAGE = "Are you sure want to delete this repository?"
var ALERT_GO_BACK_MESSAGE = "Are you sure you want to go back?"

var STATUS_CODE_101_MESSAGE = "Error occurred while doing activity, please try again"

var CHECK_NETWORK_CONNECTION_MESSAGE = NSLocalizedString("no_internet", comment: "")  //"Please check your network connection"

var LOGOUT_ALERT_MESSAGE = "If you logout from this device, you will loss the un-submitted data of stored coupons. Do you want to Logout?"
//var INVALID_USER_STATUS_CODE_102_MESSAGE = "Invalid user, Please register and try again"

var CommoditiesAndCropsTableCellBackgroundColor  = UIColor (red: 177.0/255, green: 226.0/255, blue: 237.0/255, alpha: 1.0)

var NavigationBarColor  = UIColor (red: 0.0/255, green: 179.0/255, blue: 89.0/255, alpha: 1.0)

var ParamarshNavigationBarColor  = UIColor (red: 79.0/255, green: 96.0/255, blue: 201.0/255, alpha: 1.0)

var LoginEnterMobileNumberBorderColor  = UIColor (red: 65.0/255, green: 129.0/255, blue: 13.0/255, alpha: 1.0)

/******** Paramarsh Alert messages **********/
//MARK: Alert Messages
var Alert_Message_201 = "Oops! Something went wrong. Please try after some time."
var Alert_Message_101 = "Oops! Something went wrong. Please try after some time."
var Alert_Message_203 = "User doesnot exist"
var Alert_Message_104 = "Oops! Something went wrong. Please try after some time."
var Alert_Message_102 = "You are already registered"
var Alert_Message_ForgotPwd_101 = "User doesnot exist"
var Alert_Message_ForgotPwd_100 = "New password will receive on your registered mobile number"
/*********************************************/
//MARK: Genunity Check Autentication Keys
let Genunity_Auth_Id = "9BE2484806A0ED370B7C"
let Genunity_Auth_Token = "B5589A25C67F01C7DEA452553235051DC7A7E651"
let Genunity_URL = "https://dupont.uniqolabel.co/api/mobile/v1/"
let Genunity_Status_Code_100 = 100
let Genunity_Status_Code_101 = 101
let Genunity_Status_Code_102 = 102
let Genunity_Status_Code_103 = 103
let Genunity_Status_Code_104 = 104
let Genunity_Status_Code_105 = 105
//MARK: Genunity Messages
let GenunitySuccessMessage = "This is a genuine DuPont Pexalon™ (SKU)."
let GenunityFailureMessage = "This is not a genuine DuPont product. Please call DuPont customer care on: 1860-1800-186."
let GenunityAttemptsExceedMessage = " This DuPont Pexalon™ (SKU) label is validated in past. Please call DuPont customer care  for re-verification on: 1860-1800-186."

//MARK: Germination Validation And Status messages
let Germination_Acerage_Qualification_Fail_Msg = "Thanks for your interest, unfortunately your acreage does not qualify for Germination Guarantee scheme – Product Manager, %@"
let Germination_Enrolled_Success_Msg = "You are now enrolled for Germination Guarantee Seed Replacement Scheme – Product Manager, %@"
let Germination_Claimed_Success_Msg = "You have successfully Claimed"

#if DEBUG
    let genunityEnvironment = "test"
#else
    let genunityEnvironment = "prod"
#endif
//Nav bar headings
var HOME = "PHI Sales Emp"

var VOLUME_PLANNER = "Volume Planner"

var MANDI_PRICES = "Mandi Prices"

var MANDIS = "States"

var CROPS = "Crops"

var CROP_ADVISORY = "Crop Advisory"

var FEATURE_AND_BENEFITS = "Feature and Benefits"

var normalStr = "YES"
var User_Deviceid : NSString = ""
var arrIrrigationTypes = ["Rainfed","Irrigated"]
var arrSeasonTypes = ["Rainy","Post-Rainy","Spring","Summer"]

//MARK: Gcm Keys
var gcmMessageIDKey = "gcm.message_id"
//MARK: Deeplink Modules and Params
let deepLinkBaseUrl = "https://deeplinking.pioneerfarmerconnect.com/deeplinking?" //"http://103.24.202.200:9090/FarmerConnect/deeplinking?" //"http://www.pioneerfarmerconnect.com/deeplinking?" //"http://192.168.3.236:9090/FarmerConnect/deeplinking?"//http://test.pioneerfarmerconnect.com/deeplinking?"
let Module = "module"
let Crop_Advisori_Registration = "cropAdvisoryRegistration"
let CD_Product_Details = "cdProductDetails"
let CD_All_Products = "cdAllProducts"
let Crop_Diagnostic = "cropDiagnostic"
let FAB = "FAB"
let FAB_CP = "FABCP"
let PravakthaBooklets = "pravaktaBooklets"
let Notification_s = "notifications"
let WhatsAppOptIn = "whatsAppOptIn"
let Hybrid_Product_Details = "hybridProductDetails"
let Disease_Details = "diseaseDetails"
let Equipment_View_Details = "equipmentViewDetails"
let SPRAY_MODULE  = "spray"
let Pincode = "pincode"
let Customer_Id = "customerId"
let User_Category = "category"
let State_Id = "state"
let Crop_Id = "crop"
let DISEASE = "disease"
let Hybrid_Id = "hybrid"
let Season_Id = "season"
let Season_Start_Date = "startDate"
let Season_End_Date = "endDate"
let Product_Id = "productId"
let Disease_Id = "diseaseId"
let version = "version"
let Product_Name = "productName"
let Equipment_Id = "equipmentId"
let Intent_Type = "mechRequester"
let Map_Requestor = "mapRequestor"
let Equipment_Owner_Id = "ownerId"
let Device_Type = "iOS"
let AppName = "Farmer"
let subModule = "subModule"
let planterServices = "PlanterServices"
let userLogsAllPrint = "userLogsAllPrint"
// submodule navigation for spray services notifications
let Spray_subModule_uploadBill = "uploadBill"
let Spray_subModule_requesterMode = "requesterMode"
let Spray_subModule_farmerFeedbackList = "farmerFeedbackList"
let Spray_subModule_vendorOrderList = "vendorOrderList"
let Spray_subModule_taskId = "60"
let Refer_a_Farmer = "ssAndWReferralProg"

 


class Constatnts: NSObject {
    
    class func getCustomerId() -> Int{
        let user = Constatnts.getUserObject()
        if Validations.isNullString(user.customerId!) == true{
            return 0
        }
        else{
            return Int(user.customerId as String? ?? "0") ?? 0
        }
    }
    class func setUserToUserDefaults(user: User){
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: user)
        UserDefaults.standard.set(encodedData, forKey: "User")
    }
    class func getUserObject() -> User{
        if let data = UserDefaults.standard.data(forKey: "User"){
            let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? User
            return user!
        }
        return User(dict: NSDictionary())
    }
    public class func getTemparatureFromValue(tempDouble: Double?) -> String{
        var temparatureString = "0"
        if tempDouble != nil  {
            if tempDouble! > Double(273.15) {
                temparatureString =  String(format: "%d", Int64(floor(tempDouble! - 273.15)))
            }
        }
        return temparatureString
    }
    
    public class func nsobjectToJSON(_ swiftObject: NSDictionary) ->String
    {
//        let jsonData: Data =  try! JSONSerialization.data(withJSONObject: swiftObject, options: JSONSerialization.WritingOptions.prettyPrinted)
//        let strJSON : NSString =  NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)!
//        let str = strJSON as String
        
        let dictionResult = self.encryptInputParams(parameters: swiftObject)
        //print("strJSON  :\(dictionResult)")
        return dictionResult
    }
    
    //----------- RS256 ENCRYPTION FUNCTION --------------- //(input as NSDictionary)
    public class func encryptInputParams(parameters : NSDictionary )->String{
        //var dictionReslut = NSDictionary()
        let algorithmNAme: JWTAlgorithm? = JWTAlgorithmFactory.algorithm(byName: "RS256")
        
        //print(algorithmNAme)
        
        let bundle = Bundle.main
        let path = bundle.path(forResource: "MyCert_farmer", ofType: "p12")
        let privateKeySecretData = NSData(contentsOfFile: path!)
        let passphraseForPrivateKey = "empover"  //encryptPrivateKey  ///
        
        //let rest1 =  "sdhfjsdhgsfg"
        let encodePayload = JWTBuilder.encodePayload(parameters as [NSObject : AnyObject])
        let secrateData = encodePayload?.secretData((privateKeySecretData as AnyObject) as? Data)
        let privateKey = secrateData?.privateKeyCertificatePassphrase(passphraseForPrivateKey)
        let algorithm = privateKey?.algorithm(algorithmNAme)
        let jwtTokenStr = String(format:"%@",algorithm?.encode ?? "")
        
        //print(rest1)
        return jwtTokenStr
    }
    
    public class func timeGapBetweenDates(previousDate : String,currentDate : String) -> Int
    {
        let dateString1 = previousDate
        let dateString2 = currentDate
        
        let Dateformatter = DateFormatter()
        Dateformatter.dateFormat = "yyyy-MM-dd"
        
        
        let date1 = Dateformatter.date(from: dateString1)
        let date2 = Dateformatter.date(from: dateString2)
        
        
        let distanceBetweenDates: TimeInterval? = date2?.timeIntervalSince(date1!)
        //        let secondsInAnHour: Double = 3600
        //        let minsInAnHour: Double = 60
        let secondsInDays: Double = 86400
        //        let secondsInWeek: Double = 604800
        //        let secondsInMonths : Double = 2592000
        //        let secondsInYears : Double = 31104000
        
        //        let minBetweenDates = Int((distanceBetweenDates! / minsInAnHour))
        //        let hoursBetweenDates = Int((distanceBetweenDates! / secondsInAnHour))
        let daysBetweenDates = Int((distanceBetweenDates! / secondsInDays))
        //        let weekBetweenDates = Int((distanceBetweenDates! / secondsInWeek))
        //        let monthsbetweenDates = Int((distanceBetweenDates! / secondsInMonths))
        //        let yearbetweenDates = Int((distanceBetweenDates! / secondsInYears))
        //        let secbetweenDates = Int(distanceBetweenDates!)
        
        return daysBetweenDates
    }
    

    //----------- RS256 ENCRYPTION FUNCTION --------------- //(input as NSString)
    public class func encrptInputString(paramStr : NSString) -> String{
        let algorithmNAme: JWTAlgorithm? = JWTAlgorithmFactory.algorithm(byName: "RS256")
        let bundle = Bundle.main
        let path = bundle.path(forResource: "MyCert_farmer", ofType: "p12")
        let privateKeySecretData = NSData(contentsOfFile: path!)
        let passphraseForPrivateKey = "empover"  //encryptPrivateKey  ///
        //let jwtTokenStr = String(format:"%@",(JWTBuilder.encodePayloadStr(paramStr as String!).secretData((privateKeySecretData as AnyObject) as? Data)?.privateKeyCertificatePassphrase(passphraseForPrivateKey)?.algorithm(algorithmNAme)?.encode1!)!)
        let encodePayload = JWTBuilder.encodePayloadStr(paramStr as String)
        let secrateData = encodePayload?.secretData((privateKeySecretData as AnyObject) as? Data)
        let privateKey = secrateData?.privateKeyCertificatePassphrase(passphraseForPrivateKey)
        let algorithm = privateKey?.algorithm(algorithmNAme)
        let jwtTokenStr = String(format:"%@",algorithm?.encode1 ?? "")
        return jwtTokenStr
    }
    
    // ---------- RS256 Decryption Function -----------------
    public class func decryptResult( StrJson : String ) -> NSDictionary
    {
        //should be replaced by decode result sent by the server (response)
        let splitArray1 : NSArray = StrJson.split(separator: ".") as NSArray
        //print(splitArray1)
        let base64Str = splitArray1[1] as? String ?? ""
        var base64 = base64Str
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/").replacingOccurrences(of: "", with: "=")
        let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
        let requiredLength = 4 * ceil(length / 4.0)
        let paddingLength = requiredLength - length
        if paddingLength > 0 {
            let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
            base64 = base64 + padding
        }
        var dictionResult = NSDictionary()
        //
        //        let splitArray1 : NSArray = StrJson._split(separator: ".") as NSArray
        //        print(splitArray1)
        //
        //        var base64Str = splitArray1[1] as! String
        //        if base64Str.characters.count % 4 != 0 {
        //            let padlen = 4 - base64Str.characters.count % 4
        //            base64Str += String(repeating: "=", count: padlen)
        //        }
        
        if let data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters),
            let str = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
            //print(str)
            dictionResult = self.convertToDictionary(text: str as String)! as NSDictionary
            //print("decoded dictionary :\(dictionResult)")
        
        }
        return dictionResult
    }
   public class func convertToDictionary(from text: String) -> [String: String] {
        guard let data = text.data(using: .utf8) else { return [:] }
        let anyResult: Any? = try? JSONSerialization.jsonObject(with: data, options: [])
        return anyResult as? [String: String] ?? [:]
    }
    public class func decryptFarmerDashBoardResult( StrJson : String ) -> NSDictionary
    {
        //should be replaced by decode result sent by the server (response)
        let splitArray1 : NSArray = StrJson.split(separator: ".") as NSArray
        //print(splitArray1)
        let base64Str = splitArray1[1] as! String
        var base64 = base64Str
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/").replacingOccurrences(of: "", with: "=")
        let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
        let requiredLength = 4 * ceil(length / 4.0)
        let paddingLength = requiredLength - length
        if paddingLength > 0 {
            let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
            base64 = base64 + padding
        }
        var dictionResult = NSDictionary()
        //
        //        let splitArray1 : NSArray = StrJson._split(separator: ".") as NSArray
        //        print(splitArray1)
        //
        //        var base64Str = splitArray1[1] as! String
        //        if base64Str.characters.count % 4 != 0 {
        //            let padlen = 4 - base64Str.characters.count % 4
        //            base64Str += String(repeating: "=", count: padlen)
        //        }
        
        if let data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters),
            let str = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
            print(str)
            let str1 = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            
             // return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            print(str1)
            //print("decoded dictionary :\(dictionResult)")
        }
        return [:]
    }
    class func getLoggedInFarmerHeaders() -> HTTPHeaders{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appBuildId = Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String ?? "Unknown"
        let versionNum = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        
        let userObj = Constatnts.getUserObject()
        let headers : HTTPHeaders = ["userAuthorizationToken": userObj.userAuthorizationToken! as String,"mobileNumber": userObj.mobileNumber! as  String ,"customerId": userObj.customerId! as String,"deviceToken":userObj.deviceToken as String,"deviceId":userObj.deviceId! as String,"appVersionCode":appBuildId as String,"appLangCode":appDelegate.selectedLanguage,"appVersionName":versionNum]
        return headers
    }
    // userObj.mobileNumber! as  String
    public class func getCurrentMillis()->Int64 {
        //print(Int64(Date().timeIntervalSince1970 * 1000))
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    //MARK: delete coreData entity by name
   
    public class func deleteCoreDataEntity(entityName: String){
      
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let coord = appDelegate.persistentStoreCoordinator
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        fetchRequest.includesPropertyValues = false
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coord.execute(deleteRequest, with: context)
        } catch let error as NSError {
            debugPrint(error)
        }

    }
    
    //MARK: deleteAllDBData
   public class func clearDBData(){
    //var context:NSManagedObjectContext?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.managedObjectContext
        for entityName in ["CropAdvisoryDetails", "AgroProductMasterEntity","DiseasePrescriptionsEntity","FABDetails","NotificationsEntity","CropCalculatorEntity","RaiseTicketEntity","TicketDetailsEntity"]{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let delAllReqVar = NSBatchDeleteRequest(fetchRequest: request)
            do {
                try context.execute(delAllReqVar)
            }
            catch {
              //  print(error)
            }
        }
    }
    
    //MARK: clearDocumentsDirectory
   public class func clearDocumentsDirectory(){
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        guard let items = try? FileManager.default.contentsOfDirectory(atPath: path) else { return }
        for item in items {
            // This can be made better by using pathComponent
            let completePath = path.appending("/").appending(item)
            try? FileManager.default.removeItem(atPath: completePath)
        }
    }
    
    //to clear defaults
    //        let domain = Bundle.main.bundleIdentifier!
    //        UserDefaults.standard.removePersistentDomain(forName: domain)
    //        UserDefaults.standard.synchronize()

    //MARK: logout
    /**
     This method is used to logout from the app
     - Remark: clears total DB data, Documents directory and UserDefaults is set to **false** for **login** key
    */
    public class func logOut(){
        Constatnts.clearDBData()
        Constatnts.clearDocumentsDirectory()
        //to clear defaults
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        UserDefaults.standard.set(false, forKey: "login")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        UIApplication.shared.keyWindow?.rootViewController = storyboard.instantiateViewController(withIdentifier: "DLDemoRootViewController") as! DLDemoRootViewController
    }
    
    public class func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            }
            catch {
             //  print(error.localizedDescription)
            }
        }
        return nil
    }
    
    public class func uniqueElementsFrom(array: [String]) -> [String] {
        //Create an empty Set to track unique items
        var set = Set<String>()
        let result = array.filter {
            guard !set.contains($0) else {
                //If the set already contains this object, return false
                //so we skip it
                return false
            }
            //Add this item to the set since it will now be in the array
            set.insert($0)
            //Return true so that filtered array will contain this item.
            return true
        }
        //print(result)
        return result
    }
    
    func uniqueElementsFrom<T: NSDictionary>(array: [T]?, filterKey:String) -> [T] {
        var set = Set<T>()
        let result = array!.filter {
            guard !set.contains($0) else {
                return false
            }
            set.insert($0)
            return true
        }
        return result
    }
}
