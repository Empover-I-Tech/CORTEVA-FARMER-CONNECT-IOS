////
////  dskjgkljdViewController.swift
////  FarmerConnect
////
////  Created by Empover-i-Tech on 04/12/19.
////  Copyright © 2019 ABC. All rights reserved.
////
//
//import UIKit
//
//class dskjgkljdViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//
//
//
//
//
//  "drawer_open" = "Open"
//    "drawer_close"    =   "Close";
////      "rs"  =  "  (\u20B9)"
////      "Rs"    =  " (\u20B9)"
//    "rupee_symbol"    =   "₹";
//    "km_symbol"    =    "km";
//    "price_rs"    =   "Price per hour(\u20B9)";
//    "kms"    =   "Kms";
//    "app_name"    =   "Farmer Connect";
//      "connection_timeout"    =   "Connection timed out"
//    "no_internet"    =  " Please check your network connection.";
//    "item_edit_name"    =   "EditName";
//    "search"    =   "Search";
//    "mobile_number_hint"    =   "Enter Mobile Number";
//
////    <!-- Genuinity Check Credentials --    =
////      "test_auth_id"    =   4208042C50F4BEC3304A
////      "test_auth_token"    =   2D24DD3FACFA1E105E23AE757AA0DD2CB9294B90
////      "test_base_url"    =   https://dupont.test.uniqolabel.co
////      "prod_auth_id"    =   96E80FBE7D0C195FA4E6
////      "prod_auth_token"    =   A317FCEAAAC1A0458C795615720BC0EAA62916AB
////      "prod_base_url"    =   https://dupont.uniqolabel.co
//
//   // <!--Menu Itmes --    =
//    "home"    =   "Home";
//    "features_and_benefits"    =   "Features";
//    "products"    =   "Products";
//    "crop_advisory"    =   "Crop Advisory";
//    "registration"    =   "Registration";
//    "crop_notify"    =   "Crop Notification";
//    "crop_diagnosis"    =   "Crop Diagnostic";
//    "farm_services"    =   "Farm Services";
//    "mech_prov"    =   "Provider";
//    "mech_req"    =   "Requester";
//    "weather_report"    =  " Weather Report";
//    "mandi"    =   "Mandi Prices";
//    "coupon_booklet"    =   "Coupon Booklet";
//    "product_registration"    =   "Claim Coupon";
//    "farmer_assist"    =  "Farmer Assist";
//    "notifications"    =  "Notifications";
//    "attendance_code"    =   "Give Attendance";
//    "paramarsh"    =   "Paramarsh";
//    "calcu"    =   "Calculator";
//    "genuinity"    =   "Genuinity Check";
//    "germination"    =   "Germination";
//    "my_health_card"    =   "My Soil Card";
//    "soil_health_card"    =   "Soil Health Card";
//    "language_change"    =   "Language Change";
//
//    "crop_advisory_registration"    =   "Crop Advisory Registration";
//    "crop_advisory_notifications"    =   "Crop Advisory Notifications";
//    "booklet"    =   "Booklets";
//    "cart_list"    =   "cartPords";
//    <!-- End of Items --    =
//
//    <!--HomeScreen Start--    =
//    <!--HomeScreen end--    =
//
//    <!--FAB Details Start--    =
//      "st_get_fab_details"    =   Get FAB Details
//      "description"    =   Description :
//    <!-- End of FAB--    =
//
//    <!--Products Start--    =
//      "product_preselectionmenu_all"    =   All
//      "product_preselectionmenu_rice"    =   Rice
//      "product_preselectionmenu_millet"    =   Millet
//      "product_preselectionmenu_corn"    =   Corn
//      "product_preselectionmenu_mustard"    =   Mustard
//
//    <!--MyAddress Start--    =
//      "myaddress_firstname"    =   First Name
//      "myaddress_lastname"    =   Last Name
//      "myaddress_address1"    =   Address 1
//      "myaddress_address2"    =   Address 2
//      "myaddress_mobileno"    =   Mobile No
//      "myaddress_pincode"    =   Pin Code
//      "myaddress_region"    =   Region
//      "myaddress_state"    =   State
//      "myaddress_district"    =   District
//    <!--MyAddress end--    =
//
//    <!--Registration Start--    =
//      "registration_category"    =   Category
//      "registration_crop"    =   Crop
//      "registration_hybridname"    =   Hybrid Name
//      "registration_season"    =   Season
//      "registration_dateofsowing"    =   Date Of Sowing
//      "registration_acressowed"    =   Acres Sowed
//    <!--Registration end--    =
//
//    <!--FarmerServices Start--    =
//    <!--Provider Start--    =
//      "provider_addequipment"    =   Add Equipment
//    <!--FarmerServices end--    =
//
//      "max_price_hour"    =   Maximum price per hour $1
//      "enter_min_chars"    =   Please enter minimum $1 characters
//
//    <!-- Otp Screen--    =
//      "otp_sending_msg"    =   OTP will be sent on $1 as sms
//      "otp_sending_msg_email"    =    and $2
//
//      "one_acre"    =   1 Acre of land requires  $1  $2 of  $3 ($4)
//      "et_value_should_not_zero"    =   $1 value should not be zero
//      "update_google_play_services"    =   Update google play services for better performance
//      "google_play_services_missing"    =   google play services missing install/update for better performance
//      "google_play_services_disable"    =   google play services disabled enable for better performance
//      "google_play_services_invalid"    =   google play services invalid install/update for better performance
//      "please_enter_no_acres"    =   Please enter No.of Acres.
//      "acres_of_land_req"    =   Acres of land requires
//      "make_sure_to_give_permission"    =   Make sure to give Permission to Access This page
//
//    <!--Calculators Start--    =
//      "calculators_cropcalculators"    =   Crop Calculators
//
//    <!--CalculatorValues Start--    =
//      "calculatorvalues_viewpreviousyear"    =   View Previous Year
//      "calculatorvalues_planningyear"    =   Planning Year
//      "calculatorvalues_planningacres"    =   Planning Acres
//      "calculatorvalues_calculate"    =   Calculate
//      "calculatorvalues_landpreparationnurseryraising"    =   Land Preparation/Nursery Raising
//      "calculatorvalues_seedcost"    =   Seed Cost (Rs./kg)
//      "calculatorvalues_seedrate"    =   Seed Rate (kg/acre)
//      "calculatorvalues_totalseedcost"    =   Total Seed Cost (Rs./
//      "calculatorvalues_labourcost"    =   Labour Cost (Rs./labour)
//      "calculatorvalues_totallabourcost"    =   Total Labour Cost (Rs./
//      "calculatorvalues_costperirrigation"    =   Cost per Irrigation (Rs./acre)
//      "calculatorvalues_noofirrigations"    =   No Of irrigation
//      "calculatorvalues_totalirrigationcost"    =   Total Irrigation Cost (Rs./
//      "calculatorvalues_fertilisercost"    =   Fertiliser Cost(Rs./acre)
//      "calculatorvalues_pesticidecost"    =   Pesticide Cost(Rs./acre)
//      "calculatorvalues_totalinputcost"    =   Total Input Cost(Rs./
//      "calculatorvalues_graincottonyield"    =   Grain/cotton Yield ( Qntl./acre )
//      "calculatorvalues_commercialgrainprice"    =   Commercial Grain Price (Rs./Qntl.)
//      "calculatorvalues_totalincome"    =   Total Income(Rs./
//      "calculatorvalues_netprofit"    =   Net Profit (Rs./
//      "total_no_of_labour"    =   Total no. of labourers reqd. in entire crop duration
//      "mechharvest"    =   Mechanical harvesting cost Rs./acre
//      "straw_yield"    =   Straw Yield (Qntl./acre)
//      "commercialfodder"    =   Commercial Fodder Price (Rs./Qntl.)
//      "save_data"    =   Do you want to save data ?
//    <!--CalculatorValues end--    =
//    <!--Calculators end--    =
//
//    <!-- Screen Title start--    =
//      "update_profile"    =   Update Profile
//      "coupons"    =   Coupons
//      "my_profile"    =   My Profile
//      "create_addrs"    =   Add an Address
//      "agro_products"    =   Product Details
//      "orders"    =    Orders
//      "how_to_capture_photo"    =   How to capture photo ?
//      "title_diagnosis"    =   Diagnosis
//      "disease_detected"    =   Disease Detected
//      "states"    =   States
//      "title_diagnosis_chance"    =   Diagnosis - Chance
//      "update_schedule"    =   Update Schedule
//      "equipment_list"    =   Equipment List
//      "all_reviews"    =   All Reviews
//      "filter"    =   clea
//      "select_loc_map"    =   Select location
//      "edit_equip"    =   Edit Equipment
//      "address_selection"    =   Address Selection
//      "select_day"    =   Select Day
//      "feedback"    =   Feedback
//    <!-- Screen Title end--    =
//
//    <!--MandiPrice Start--    =
//      "mandiprice_bymandis"    =   By Mandis
//      "mandiprice_bycrops"    =   By Crops
//      "crops"    =   Crops
//    <!--MandiPrice end--    =
//
//    <!--String Label start--    =
//      "registration_usertype"    =   User Type
//      "registration_firstname"    =   First Name
//      "registration_lastname"    =   Last Name
//      "registration_country"    =   Country
//      "registration_language"    =   Language
//      "registration_mobileno"    =   Mobile Number
//      "registration_email"    =   Email Id
//      "registration_pincode"    =   PinCode
//      "registration_state"    =   State
//      "registration_district"    =   District
//      "registration_villagelocation"    =   Village Location
//      "registration_totalcropacres"    =   Total Crop Acres
//      "registration_corn"    =   Corn
//      "registration_rice"    =   Rice
//      "registration_millet"    =   Millet
//      "registration_mustard"    =   Mustard
//      "registration_seasonscultivated"    =   Seasons Cultivated
//      "registration_rainy"    =   Rainy
//      "registration_postrainy"    =   Post-Rainy
//      "registration_spring"    =   Spring
//      "registration_summer"    =   Summer
//      "registration_typeofirrigation"    =   Type of Irrigation
//      "registration_rainfed"    =   Rainfed
//      "registration_irrigated"    =   Irrigated
//    <!--<string name="registration_privacy_policy"    =   <u    =   Privacy Policy</u    =       --    =
//      "registration_submit"    =   Submit
//      "registration_update"    =   UPDATE
//
//    <!--FarmerAssist Start--    =
//      "farmerassist_farmermobilenumber"    =   Farmer Mobile Number
//    <!--FarmerAssist end--    =
//
//      "optional"    =   Optional
//      "farmer"    =   Farmer
//      "district"    =   District
//      "submit"    =   Submit
//      "send_same"    =   Send same request to multiple providers
//      "service_complete"    =   Service Completed
//      "service_failed"    =   Service Failed
//      "navigate"    =   Navigate
//      "status"    =   Status :
//      "status_"    =   Status
//      "confirm"    =   Confirm
//      "reject"    =   Reject
//      "resendOtp"    =   Resend
//      "no_internet_label"    =   Please check your network connection.
//      "grant"    =   Grant
//      "validtill"    =   Valid Till
//      "coupon"    =   Coupon
//      "couponbooklet"    =   Coupons in booklet
//      "noshared"    =   No of coupons shared
//      "share_coupon"    =   Share Coupon
//      "multiplereq"    =   Multiple request configuration
//      "product_register"    =   Thank you for registering product
//      "share"    =   Share
//      "view_coupons"    =   View Coupons
//      "tryagain"    =   <u    =   Try Again</u    =
//      "price"    =   Price
//      "productLabel"    =   Product Label
//      "register"    =   Register
//      "shared_information"    =   Farmer Information
//      "shared_by"    =   Farmer Name
//      "shared_by_mobileno"    =   Farmer Mobile No
//      "shared_by_date"    =   Shared Date
//      "all"    =   All
//      "rice_l"    =   Rice
//      "millet_l"    =   Millet
//      "corn_l"    =   Corn
//      "mustard_l"    =   Mustard
//      "soyabean_l"    =   Soybean
//      "chilli_l"    =   Chilli
//      "cotton_l"    =   Cotton
//      "mobile_no"    =   Mobile No
//      "no_products"    =   Currently there are no products available for sale.
//      "mrp_unit"    =   MRP/Unit
//      "discount_unit"    =   Discount/Unit
//      "net_amount_unit"    =   Net Amount/Unit
//      "remove"    =   Remove
//      "yes"    =   Yes
//      "no"    =   No
//      "season_name"    =   Season
//      "crop_name"    =   Crop
//      "hybrid_name"    =   Hybrid
//      "senton"    =   SentOn
//      "notification"    =   Notification
//      "sowing_date"    =   Sowing Date
//      "local_msg"    =   Local Message
//      "noofdays"    =   Number of Days From Sowing Date
//      "stage"    =   Stage
//      "expecteddate"    =   Expected Date
//      "msg"    =   Message
//      "calculate"    =   Calculate
//      "place_order"    =   Place order
//      "product_type"    =   Product Type      <!-- Tab Name --    =
//      "product_name"    =   Product Name     <!-- Tab Name --    =
//      "amount"    =   Amount (\u20B9)     <!-- Tab Name --    =
//      "feature_fragment"    =   Features     <!-- Tab Name --    =
//      "advantages_fragment"    =   Advantages     <!-- Tab Name --    =
//      "benefits_fragment"    =   Benefits     <!-- Tab Name --    =
//      "pending_request"    =   Pending Request     <!-- Tab Name --    =
//      "pending_orders"    =   Pending Orders     <!-- Tab Name --    =
//      "past_orders"    =   Past Orders     <!-- Tab Name --    =
//      "version_code"    =   Version 2.1
//      "log_out"    =   Log Out
//      "ok"    =   OK
//      "ok_got"    =   OK, Got it!
//      "cancel"    =   Cancel
//      "update"    =   Update
//      "continu"    =   Continue
//      "force_update_title"    =   Update Available
//      "total_amount"    =   Total Amount
//      "date_of_sowing"    =   Date Of Sowing
//      "cart_empty"    =   Your Cart is empty.
//      "cropadvisory_notavailable"    =    Crop Advisory is not available for your region !
//      "cd_allproducts"    =   All Products
//      "fab_internet_offmsg"    =   Currently your internet is off. You will only be able to view already downloaded features and benefits. Switch on your internet to view other crops features and benefits.
//      "nointernet"    =    Oops! No Internet
//
//
//      "no_data_available"    =   No Data Available
//      "no_messages_available"    =   No Messages Are Available
//      "privacy_policy"    =   <u    =   Privacy Policy</u    =
//      "splash_privacypolicytext"    =   By using this App, you agree to the terms and conditions of DuPont Pioneer’s Privacy Statement. For Privacy details, visit <u    =   www.privacy.DuPont.com</u    =
//      "choose_options"    =   Choose Option
//      "camera"    =   Camera
//      "gallery"    =   Gallery
//      "choose_image"    =   Choose Image
//      "remove_image"    =   Remove Image
//      "focus_disease_area"    =   Focus on disease area.Please cover 80% of disease while image capture
//      "focus_whole_plant"    =   Don\'t focus on whole plant
//      "select_your_crop"    =   Select your crop
//      "crop_calculator"    =   Crop Calculators
//      "gps"    =   Please enable GPS to continue
//      "muti"    =   Multi-day forecast
//      "humidity"    =   Humidity
//      "sunset"    =   Sunset
//      "sunrise"    =   Sunrise
//      "market"    =   Market Area
//      "today_"    =   Today
//      "commodity"    =   Commodity
//      "variety"    =   Variety
//      "arrival"    =   Arrival Date
//      "minprice"    =   Minimum Price
//      "maxprice"    =   Maximum Price
//      "modelprice"    =   Model Price
//      "progress_please_wait"    =   Please wait loading
//      "do_u_want_to_save_equipment"    =   Do you want to save equipment ?
//      "do_u_want_to_update_equipment"    =   Do you want to update equipment ?
//
//      "save"    =   Save
//      "done"    =   Done
//      "view_details"    =   View Details
//      "manage"    =   Manage
//      "equipment"    =   Equipment
//      "sch"    =   Schedule
//      "schedule"    =   Schedule equipment
//      "disable"    =   Disable     <!-- comparing string as well as setting value--    =
//      "enable"    =   Enable     <!-- comparing string as well as setting value--    =
//      "edit"    =   Edit     <!-- comparing string as well as setting value--    =
//      "booknow"    =   Book Now     <!-- comparing string as well as setting value--    =
//      "delete"    =   Delete
//      "model"    =   Model
//      "performance"    =   Performance
//      "with_driver"    =   With driver
//      "single_day"    =   Single day
//      "multiple_day"    =   Multiple days
//      "driver"    =   Driver
//      "pick_drop"    =   Pick and Drop
//      "request_location"    =   Request Location
//      "max_dist"    =   Maximum distance
//      "cancelpolicy"    =   Cancellation Policy
//      "requested_by"    =   Requested by
//      "provided_by"    =   Provided by
//      "distance_label"    =   Distance
//      "selected_hours_label"    =   Selected Hours
//      "year_manuf"    =   Year of manufacture
//      "vehicle_number"    =   Vehicle Number
//      "ratings_by_user"    =   Ratings by user
//      "alert"    =   Alert!
//      "notify"    =   What is the reason for reject ?
//      "notify1"    =   What is the reason for cancel ?
//      "to"    =   to
//      "distance_sorting"    =   Distance sorting
//      "vehicle"    =   Vehicle
//      "no_of_hour_sorting"    =   No of booking hours sorting
//      "no_of_hours_required"    =   No of hours required
//      "start_time"    =   Start Time
//      "confirm_booking"    =   Confirm Booking
//      "date_range"    =   Date Range
//      "apply_filter"    =   Apply Filter
//      "classification"    =   Classification
//      "available_dates"    =   Available dates
//      "price_per_hour"    =   Price per hour
//      "reset"    =   Reset
//      "clear"    =   Clear
//      "distance_kilo"    =   in kms
//      "available_timing"    =   Available timings
//      "add_eqpt_max_img"    =   You can upload 3 images only
//      "mini_servic"    =   Minimum service
//      "equipment_desc"    =   Description
//      "registered_number"    =   Registered number
//      "no_equipments_available"    =   Currently no equipments available
//      "location"    =   Location
//
//      "select_from_date"    =   Please select from date
//      "select_from_date_first"    =   Please select from date first
//      "please_provide_from_date"    =   Please provide from date
//      "from_date"    =   From date
//      "select_to_date"    =   Please select to date
//      "to_date"    =   To date
//      "enter_your_location"    =   Enter your location
//      "select_driver_options"    =   Please select any one from with driver / pick and drop
//      "price_should_not_be_zero"    =   Price should not be zero
//      "priceper_hour_should_not_be_zero"    =   Price per hour should not be zero
//      "no_orders_found"    =   No Orders Found
//      "you_are_here_map"    =   You are here
//      "no_of_hours_required_alert"    =   Number of hours should be more than 0 and less than 24
//      "distance_info"    =   Distance calculated as straight line distance, actual distance may vary depending on route
//      "internet_required"    =   This feature required internet connectivity, check your network connection.
//      "maker"    =   Maker
//      "price_hint"    =   Enter price in rupees
//      "distance_hint"    =   Enter distance in kms
//      "no_of_hrs_hint"    =   Enter number of hours
//      "contact_no"    =   Contact No.
//      "book_hours"    =   Booked Hours
//      "start_current_time_alert"    =   Start time should be greater than or equal to current time
//      "select_hours_alert"    =    Please select number of hours required
//      "selected_hours_should_more_than"    =   Required service hours should be more than or equal to minimum service hours
//      "not_available_legend_text"    =   Not Available
//      "available_legend_text"    =   Available
//      "scheduled_legend_text"    =   Scheduled
//      "booked_legend_text"    =   Booked
//      "selected_legend_text"    =   Selected
//      "today"    =   Today is the day
//      "form_exit_msg"    =    You have unsaved changes. Do you want to go back anyway ?
//      "distance_kms"    =   Service area distance(in kms)
//      "rating_hint"    =   Please specify what you like the most
//      "power_by_pestoz"    =   Powered by Pestoz
//      "hours"    =   in hours
//      "no_reviews_available"    =   No Reviews Available
//      "mini_servic_hrs"    =   Minimum service(in hours)
//      "performance_hint"    =   E.g. 2 Acres per hour
//      "min_service_hours"    =   Minimum Service hours
//      "select_location"    =   Please  select location
//      "from_time"    =   From time
//      "to_time"    =   To time
//      "selectdates"    =   Selected Date(s)
//      "date"    =   Date
//      "select_vehicle"    =   Select vehicle
//      "counter_proposal"    =   Propose changes
//      "conterreq"    =   Counter proposal request
//      "please_enter_price_per_hour"    =   Please enter price per hour
//      "please_try"    =   Currently mandi prices are not available,\nPlease try again after some time
//      "proceed"    =   Proceed
//      "booked_date"    =   Booked date
//      "booked_dates"    =   Booked dates
//      "end_time"    =   End time
//      "country"    =   Country
//      "language"    =   Language
//      "pd_packaging_lable"    =   Packaging
//      "pd_product_char_lable"    =   Product Character
//      "pd_product_work_lable"    =   How this product works
//      "pd_product_use_lable"    =   How to use this product
//      "pd_caution_lable"    =   Caution during usage
//      "pd_result_effect_lable"    =   Result and effect
//      "pd_related_hazards_lable"    =   Related Hazards
//      "hd_in_a_nutshell_lable"    =   In a NutShell
//      "hd_symptoms_lable"    =   Symptoms
//      "hd_trigger_lable"    =   Trigger
//      "hd_preventive_measure_lable"    =   Preventive Measures
//      "hd_biological_control_lable"    =   Biological Control
//      "hd_chemical_control_lable"    =   Chemical Control
//      "hd_hazard_description_lable"    =   Hazard Description
//      "related_products_lable"    =   Related Products :
//      "select_manufacture_year"    =   Please select year of manufacture
//      "cd_pest_lable"    =   Pests
//      "cd_disease_lable"    =   Disease
//      "cd_weed_lable"    =   Weeds
//      "cd_nutritional_deficiency_lable"    =   Nutritional Deficiency
//      "cd_others_lable"    =   Others
//
//    <!-- ALL permissions will be written here --    =
//      "location_permission_msg"    =   Allow access to get the location.
//      "no_access_to_weather"    =   You can not access weather, because you denies the location permission\nGo to app info and enable permission manually
//      "no_access_to_farmservice_requester"    =   You can not access Farm Services - Requester, because you denies the location permission\nGo to app info and enable permission manually
//      "permission_camera_storage_title"    =   Need Camera and storage permissions
//      "permission_camera_title"    =   Need Camera permissions
//      "permission_camera_storage_crop_body"    =   This app needs camera permission to demonize the crop.
//      "permission_camera_scan_barcode_body"    =   This app needs camera permission to scan barcode.
//      "permission_denied_title"    =   Permission Denied
//      "permission_denied_camera_body"    =   You denied camera permission with never show option. \nPlease enable permissions manually, tap on permissions then enable the camera permission.
//      "permission_denied_storage_body"    =   You denied Storage permission with never show option. \nPlease enable permissions manually, tap on permissions then enable the Storage permission.
//      "permission_denied_location_body"    =   You denied location permission with never show option. \nPlease enable permissions manually, tap on permissions then enable the location permission.
//      "permission_location_title"    =   Location Permission Needed
//      "permission_location_body"    =   This app needs the Location permission, please accept to use location functionality
//      "logout_permission_msg"    =   Are you sure, you want to logout?
//      "permission_storage_title"    =   Need Storage Permission
//      "permission_storage_body"    =   This app needs Storage permission to store and play audio file(s).
//      "permission_camera_storage_euipment_body"    =   App needs camera and storage permission to capture/browse and upload equipment images.
//      "sms_read_permission_header"    =   SMS Read Permission
//      "sms_read_permission_body"    =   This app needs SMS read permission to read OTP.
//      "storage_permission_msg"    =   Storage permission is required to download crop diseases and store offline
//      "storage_permission_denied"    =   Storage permission is denied, so application can not download and store crop diseases offline.
//      "permission_not_assigned"    =   You don\'t assign permission.
//      "permission_gps_bogy"    =   GPS is disabled in your device. Please enable GPS to use services
//      "no_of_acres_land"    =   Enter number of Land Acres
//      "no_of_acres_hint"    =   Enter No.Of Acres
//      "image_deleted"    =   Image deleted
//      "not_scheduled"    =   Not Scheduled
//      "buy_now"    =   Buy Now
//      "totalPrice"    =   Total price
//      "drag_map_to_address"    =   Please drag map to your address..
//      "no_hybrid_for_selected_crop"    =   No Hybrids for Above Selected Crop
//      "loading"    =   Loading…
//      "newest_first"    =   Newest First
//      "negetive_first"    =   Negative First
//      "positive_first"    =   Positive First
//      "available_time_not_less_min_servHrs"    =   Available timings should not be less than minimum service hours
//      "to_time_should_greater_from_time"    =   To time should not be less than to from time
//      "enter_equipment_location"    =   Please enter Equipment Location
//      "enter_to_time"    =   Please enter To time
//      "enter_from_time"    =   Please enter From time
//      "should_not_start_with_zero"    =   Should not starts with zero(0)
//      "hour_s_bracket"    =   hour(s)
//      "equipment_not_available_somethng_wrong"    =   Equipment not available / Something went wrong
//      "counter_request_sent_to_requester"    =   Counter request has been sent to requester
//      "order_details_modifed_succ"    =   Order details modified successfully
//      "select_any_date"    =   Please select any date
//      "select_available_date"    =   Please select available date
//      "enter_price_error"    =   Enter price
//      "enter_distance_error"    =   Enter distance
//      "service_provided_till_kms"    =   Service will be provided till
//      "distance_should_provided"    =   Distance has to be provided
//      "r_u_sure_u_want_to_delete"    =   Are you sure to delete this
//      "confirm_counter_request_title"    =   Confirm Counter Request
//      "proposed_dates"    =   Proposed Dates
//      "price_per_hour_provider_proposed"    =   Price per hour proposed by provider
//      "price_per_hour_at_bookingTime"    =   Price per hour at the time of booking
//      "provider_proposed_time"    =   Provider Proposed Time
//      "requested_time"    =   Requested Time
//      "enter_feedback_details"    =   Please enter feedback details
//      "enter_comments"    =   Enter comments
//      "select_rating"    =   Select rating
//      "equipment_details_updated"    =   Equipment details updated successfully
//      "success"    =   Success
//      "failed_to_capture_image"    =   Sorry! Failed to capture image
//      "user_cancelled_image_capture"    =   User cancelled image capture
//      "description_should_not_empty"    =   Description should not be empty
//      "min_service_hour_not_less_than"    =   Minimum service hours should not be less than
//      "min_service_hours_shoult_not_empty"    =   Minimum service hours should not be empty / zero (0)
//      "location_should_not_empty"    =   Location should not be empty
//      "model_should_not_empty"    =   Model should not be empty
//      "maker_should_not_empty"    =   Maker should not be empty
//      "select_equipment_classification"    =   Please select equipment classification
//      "select_image"    =   Please select image
//      "service_area_distance_should_not_zero"    =   Service area distance should not be zero(0) / empty
//      "enter_planning_acres_error"    =   Please enter planning acers
//      "enter_commercial_fodder_price_error"    =   Please enter Commercial Fodder Price (Rs./Qntl.)
//      "enter_straw_yeild_error"    =   Please enter Straw Yield (Qntl./acre)
//      "enter_commercial_grain_price_error"    =   Please enter Commercial Grain Price (Rs./Qntl.)
//      "enter_grain_cotton_yeild_error"    =   Please enter Grain/cotton Yield ( Qntl./acre )
//      "enter_pesticide_cost_error"    =   Please enter Pesticide Cost (Rs./acre)
//      "enter_fertilizer_cost_error"    =   Please enter Fertiliser Cost (Rs./acre)
//      "enter_no_of_irrigations_error"    =   Please enter No. of Irrigations
//      "enter_cost_per_irrigation_error"    =   Please enter Cost per Irrigation (Rs./acre)
//      "enter_no_of_labours_required_error"    =   Please enter Total no. of labourers reqd. in entire crop duration
//      "labbour_cost_error"    =   Please enter Labour Cost (Rs./labour)
//      "enter_seed_rate_error"    =   Please enter Seed Rate (kg/acre)
//      "enter_seed_cost_error"    =   Please enter Seed Cost (Rs./kg)
//      "enter_land_preparation_error"    =   Please enter Land Preparation/ Nursery Raising
//      "please_wait"    =   Please wait…
//      "getting_location"    =   Getting Location
//      "enter_address_error"    =   Enter your address
//      "product_lable_min_letters"    =   Enter min 4 digits product label
//      "product_lable_error"    =   Product label should not be empty
//      "select"    =   Select
//      "scan_cancelled"    =   Scan cancelled
//      "attendance_marked_success"    =   Successfully marked attendance
//      "do_u_want_to_exit"    =   Are you sure you want to exit?
//      "invalid_qr_code"    =   Invalid QR Code
//      "attendance_stored_locally"    =   Attendance captured and store, will be uploaded when there is a network connection.
//      "atten_markd_alredy_same_activty"    =   Already attendance marked for the same activity!
//      "scan_barcode"    =   Scan a barcode
//      "login_confirm_title"    =   Login Confirmation
//      "india_first_letter_cap"    =   India
//      "india_cap_letters"    =   INDIA
//      "enter_mobile_number_error"    =   Please enter valid mobile number
//      "select_country_error"    =   Please select country
//      "internet_connected"    =   Connected to Internet
//      "host"    =   Hosts:
//      "biological_name"    =   Biological Name
//      "disease_name"    =   Disease Name
//      "open_settings"    =   Open Settings
//      "disease_iden_toast"    =   Disease could not be Identified
//      "disease_not_toast"    =   Diseases not available
//      "common_rust"    =   Common Rust
//      "prob"    =   Probability of Common Rust\\nis 60.36%
//      "step"    =   Step 1 - SELECT CROP
//      "any_crop"    =   Select any crop whose disease diagnosis you want to do from the below mentioned crop.
//      "no_season"    =   No Season Available
//      "quantity"    =   Quantity
//      "min_quat"    =   Minimum Quantity should be :
//      "cannot_add"    =   You can not add more than :
//      "add_cart"    =   Add to Cart
//      "total"    =   Total
//      "unit_price"    =   Unit Price
//      "item_added"    =   Item added to cart successfully
//      "on_back_press_error"    =   Are you sure, you want to clear the changes that you made just now?
//
//      "please_select"    =   Please select
//      "timer_start_time"    =   00:00
//      "enter_otp_hint"    =   Enter OTP
//      "otp_send_successfully"    =   OTP sent successfully
//      "enter_valid_otp_error"    =   Enter Valid OTP
//      "select_one_company"    =   Please select any one company seeds which you are using
//      "select_one_irrigation"    =   Please select any one from rainfed/irrigated
//      "valid_total_acres_error"    =   Sum of all crop acres should not be more than total crop acres
//      "enter_any_crop"    =   Please fill valid number in any crop field
//      "check_location_error"    =   Please select your village location
//      "failed_location_msg"    =   Failed to get location, try again
//
//      "spring"    =   Spring
//      "post_rainy"    =   Post-Rainy
//      "rainy"    =   Rainy
//      "irrigated"    =   Irrigated
//      "rainfed"    =   Rainfed
//      "companies_patronized"    =   Companies Patronized
//      "seasons_cultivated"    =   Seasons Cultivated
//      "type_of_irrigation"    =   Type of Irrigation
//      "your_selected_date_is"    =   Your selected date is\n
//      "select_date_error"    =   Please select date
//      "order"    =   Order
//
//      "order_stat"    =   Order Status
//      "select_season_error"    =   Please select any season
//      "select_hybrid_error"    =   Please select any hybrid
//      "select_crop_error"    =   Please select any crop
//      "select_state_error"    =   Please select any state
//      "select_farmer_category_error"    =   Please select any category
//      "enter_valid_email_error"    =   Enter valid EmailId
//      "enter_total_crop_acres_error"    =   Enter total crop acres
//      "enter_last_name_error"    =   Enter last name
//      "enter_first_name_error"    =   Enter first name
//
//      "acres"    =   acres)
//      "previous_data"    =   Previous Year Planning
//      "this_equip_disable_mode"    =   This equipment is in disable mode
//      "for_your_selected_classification"    =    for your selected classification
//      "select_year"    =   Select Year
//      "version"    =   Version :
//      "location_permission_need"    =   Location Permission Needed
//      "this_app_needs_the_location"    =   This app needs the Location permission, please accept to use location functionality
//    <!--String label end--    =
//
//      "country_prompt"    =   Choose a country
//      "edit_editprofile"    =   Edit
//      "progress_loading"    =   Loading…
//      "payment"    =   Complete Your Order
//      "checkout_shipping_select_shipping_rate"    =   Please select shipping method
//      "default_error"    =   Oops, something went wrong, please try again …
//      "cart_subtotal_price"    =   SubTotal: %s
//      "checkout_title"    =   Order Confirmation
//      "checkout_update_shipping_address_progress"    =   Updating shipping address…
//      "checkout_fetch_shipping_rates_progress"    =   Fetching shipping rates…
//      "checkout_apply_shipping_rate_progress"    =   Applying shipping rate…
//      "checkout_complete_progress"    =   Confirming Order …
//      "checkout_success"    =   Your order has been placed successfully
//      "checkout_summary_total"    =   Total: %s
//      "checkout_shipping_method_not_selected"    =   Not Selected
//      "checkout_shipping_method_price_not_available"    =   N/A
//      "checkout_shipping_method_select_title"    =   Select Shipping Method
//      "payment_exit_alert"    =   Are you sure want to exit without completing order?
//      "collection_list_title"    =   Collections
//      "checkout"    =   Checkout
//      "android_pay"    =   Android Pay
//      "cart_subtotal_title"    =   SubTotal
//      "cart_subtotal_subtitle"    =   Shipping and taxes are calculated at checkout
//      "year"    =   Year
//      "i_agree"    =   I Agree
//      "target_poineer_hybrid_acres"    =   Target pioneer hybrid acres
//      "actuals_pioneer_hybrid_acres"    =   Actual pioneer hybrid acres
//      "total_numbre_of_crop_acres"    =   Total $1 acres
//      "i_accept_terms_of_use"    =   I Accept Terms of Use, Privacy Policy and Legal Disclaimer
//      "target_poineer_hybrid_acres_error"    =   Please enter $1 target of pioneer hybrid acres
//      "total_number_of_acres_error"    =   Please enter total number of acres
//      "total_number_of_acres_valid_error"    =   Total number of acres should not be zero
//      "target_pioneer_hybrid_acres_valid_error"    =   Target of pioneer hybrid acres should not be zero
//      "target_should_not_greater_total"    =   Target acres should not be more than total acres
//      "crop_acres_required_error"    =   Crop acres should not be empty
//      "enter_total_crop_acres"    =   Enter total $1 acres
//      "germination_failed_acres_error"    =   Please enter germination failed acres
//      "germination_failed_acres_valid_error"    =   Germination failed acres should not be zero
//      "germination_failed_not_more_than_total_acres_error"    =   Germination failed acres should not be more than total number of acres
//      "scheme_is_not_applicable"    =   Scheme is not applicable.
//      "congratulations"    =   Congratulations
//      "you_are_eligible_for_germination"    =   You are now enrolled for Germination Guarantee Seed Replacement Scheme
//      "subscribe"    =   Subscribe
//      "total_sowed_acres"    =   Total sowed acres
//      "germination_failed_acres"    =   Germination failed Acres
//      "germination_failed"    =   Germination failed
//      "remarks"    =   Remarks
//      "claim_policy"    =   Claim Policy
//      "claim"    =   Claim
//      "scheme_available"    =   Scheme(s) Available
//      "scheme_enrolled"    =   Scheme(s) Enrolled
//      "scheme_claimed_status"    =   Scheme(s) Claimed Status
//      "no_access_to_germination_claim"    =   You can not claim germination scheme , because you denies the location permission\nGo to app info and enable permission manually
//      "disease_iden"    =   Disease identified correctly ?
//      "mention_disease"    =   Please mention the name of disease
//      "photo_information"    =   Click on the photo of any disease to see more information
//      "customer_care"    =   If you have any queries, please contact customer care at \n 1800 103 9799
//      "share_cdi_all_products"    =   I have found all types of pesticides in Farmer Connect App. To check all available pesticides products, please click on
//      "share_cdi_product_details"    =   I have found all types of pesticides in Farmer Connect App. To check details of a product - $1, please click on
//      "share_fab"    =   There are many crop\'s Features and Benefits provided in Farmer Connect App. Please click on link to check all features and benefits of a crop.
//      "share_farm_service_provider"    =   Hi, please find my equipment - $1 available in Farmer Connect app. To check full details of my equipment please click on provided link.
//      "share_farm_service_requester"    =   I have found an equipment - $1 available in Farmer Connect app. To check full details of an equipment please click on provided link.
//      "share_cdi_disease_details_library"    =   I have found a disease in crop, please click on provided link which provides full details of disease and check whether your crop is been affected or not.
//      "share_cdi_disease_details_result"    =   I have diagnosed a disease in my crop, please click on provided link which provides full details of the disease and check whether your crop is been affected or not.
//      "share_crop_advisory_subscription"    =   I have subscribed to Crop Advisory in Farmer Connect App. You can also subscribe to it. To subscribe please click on provided link.
//
//    <!--Genuinity Check --    =
//      "genuinity_code_100"    =   This is a genuine DuPont Pexalon™ (SKU)
//      "genuinity_code_101"    =   This is not a genuine DuPont product. Please call DuPont customer care on: 1860-1800-186
//      "genuinity_code_102"    =   This is not a genuine DuPont product. Please call DuPont customer care on: 1860-1800-186
//      "genuinity_code_103"    =   This DuPont Pexalon™ (SKU) label is validated in past. Please call DuPont customer care  for re-verification on: 1860-1800-186
//      "serial_number"    =   Serial Number :
//      "something_went_wrong"    =   Something Went Wrong
//
//    <!--Language Change --    =
//      "language_selection_confirmation"    =   Do you want to set $1 language?
//    <!--End ofLanguage Change --    =
//
//      "summer"    =   summer
//      "other_dates"    =   Other Dates
//      "same_farmer_assist"    =   You can not assist yourself
//      "delete_schedule"    =   Are you sure want to delete schedule on
//      "select_language_error"    =   Please select any language
//      "no_language_available_for_country"    =   No language available for selected country. Please choose another option
//
//
//    <!-- Master data --    =
//      "coolon"    =   :
//      "hyphen"    =   -
//
//    <!-- string array list start--    =
//      "rice_m"    =   Rice
//      "millet_m"    =   Millet
//      "corn_m"    =   Corn
//      "mustard_m"    =   Mustard
//      "soyabean_m"    =   Soybean
//      "chilli_m"    =   Chilli
//      "cotton_m"    =   Cotton
//      "driver_m"    =   Driver     <!-- checking condition --    =
//      "pick_drop_m"    =   Pick and Drop     <!-- checking condition --    =
//      "cd_pest_lable_master"    =   Pests
//      "cd_disease_lable_master"    =   Disease
//      "cd_weed_lable_master"    =   Weeds
//      "cd_fungus_lable_master"    =   Fungal
//      "cd_bacteria_lable_master"    =   Bacterial
//      "cd_nutritional_deficiency_lable_master"    =   Nutritional Deficiency
//      "cd_viral_lable_master"    =   Viral
//      "cd_npk_lable_master"    =   NPK
//      "cd_micronutrients_lable_master"    =   Micronutrients
//      "cd_others_lable_master"    =   Others
//      "rainy_m"    =   Rainy
//      "post_rainy_m"    =   Post-Rainy
//      "spring_m"    =   Spring
//      "summer_m"    =   summer
//      "irrigated_m"    =   Irrigated
//      "rainfed_m"    =   Rainfed
//
//
//    <!-- New After adding Punjabi Language --    =
//      "features_and_benefits_title"    =   Features&amp;Benefits
//      "library"    =   Library
//      "select_crop"    =   Select Crop
//      "news"    =   News
//      "na"    =   N/A
//      "login_text"    =   By clicking submit you agreed to our\nTerms and Conditions and Privacy Policy
//      "resend_otp_text"    =   <u    =   Resend OTP</u    =
//      "skip"    =   Skip
//      "buy_products"    =   Buy Products
//      "customer_service"    =   Customer Service
//      "ob_crop_adv"    =   Crop advisory is a holistic tool that reminds you about all the steps necessary for highest yields and best quality of your farm produce.
//      "get_started"    =   Get Started
//      "crop_rel"    =   Crop Related
//      "rent_out"    =   Rent Out Equipment
//      "rent_equipment"    =   Rent Equipment
//      "ob_buy_prod"    =   Get our exclusive products online.
//      "ob_crop_diagno"    =   Are your plants healthy? Take a picture of your crop with smart phone.Corteva will analyze it and provide insights with in seconds.
//      "ob_equip_prod"    =   Farmer can Provide their  equipment on rental basis to other farmers.
//      "ob_equip_req"    =   Book an equipment on rent from other farmers/owners.
//      "ob_custo_service"    =   User can raise the issues and will be escalate to respective employees to resolve the raised issue.
//      "noimage"    =   no image
//      "weather"    =   Weather
//      "other_service"    =   Other Services
//      "sales_related"    =   Sales Related
//      "advisory_related"    =   Advisory Related
//      "terms_conditions"    =   Terms and Conditions
//
//
//    <!--Repeated Strings --    =
//      "menuitem_farmerconnect"    =   Farmer Connect
//      "calculators_rice"    =   Rice
//      "calculators_corn"    =   Corn
//      "calculators_millet"    =   Millet
//      "calculators_mustard"    =   Mustard
//      "add_equip"    =   Add Equipment
//
//      "privacy_policy_text"    =   <u    =   Privacy Policy</u    =
//      "crop_advisory_title"    =   Crop Advisory
//      "crop_diagnosis_title"    =   Crop Diagnostic
//
//    <!--Removed Strings as no usage found--    =
//      "add_equ"    =   ADD EQUIPMENT
//
//
//    <!-- Added on 12th June 2019 Build --    =
//      "is_added_to_cart"    =   is added to cart     <!--"Product Name" is added to cart --    =
//      "modify"    =   Modify
//      "continuee"    =   Continue
//      "thank_you"    =   Thank You
//      "on_registered_email"    =   on registered email id
//      "remove_last_item_cart"    =   Would you like to remove last item from cart?
//      "go_to_home"    =   Go to home
//
//    <!-- Added on 08th July 2019  New Registration--    =
//       "check_pincode_error"    =   Please enter pincode
//       "email"    =   Email (Optional)
//      "select_comp_pat"    =   Select Companies Patronized
//      "well"    =   Well
//      "canal"    =   Canal
//      "cloudy"    =   Cloudy
//      "pending_profile"    =   Do you want to Update Your Profile?
//      "tap_season"    =   Tap on any season to select
//      "do_u_want_to_register"    =   Farmer does not exist with entered mobile number $1 .\n Do you want to register now?
//      "acres_error"    =   Acres
//      "enter_acres"    =   Please enter
//      "enter_added_crop"    =   Please add and fill valid number in any crop field
//      "enter_added_crop_1"    =   Please enter value
//
//    <!--Farmerdashboard strings new--    =
//      "appbar_scrolling_view_behavior" translatable="false"    =   com.google.android.material.appbar.AppBarLayout$ScrollingViewBehavior
//      "type"    =   Crop     <!-- duplicate of crop_name --    =
//      "lbl_crop"    =   Crop :
//      "lbl_hybrid"    =   Hybrid :     <!--duplicate of hybrid_name --    =
//      "lbl_season"    =   Season :     <!--duplicate of season_name--    =
//      "lbl_acres"    =   Acres :     <!--Similar of acres_error--    =
//      "lbl_dos"    =   Date of Sowing :      <!--Similar of date_of_sowing--    =
//      "lbl_disease"    =   Disease :      <!--Similar of cd_disease_lable --    =
//      "lbl_quantity"    =   Quantity :      <!--duplicate of quantity--    =
//      "lbl_date"    =   Date :      <!--duplicate of date--    =
//      "farmer_dashboard"    =   Farmer Dashboard
//      "timeline_apos"    =   \&apos;s Timeline
//      "lbl_dod"    =   Date of Diagnosis :
//      "lbl_product"    =   Product :
//      "lbl_doo"    =   Date of Order :
//      "lbl_tla"    =   Total Land Acres :
//      "lbl_auc"    =   Area Under Crop :
//      "tap_on_view_timeline"    =   Tap here to view Farmer Timeline
//      "vertical_mode"    =   <u    =   Vertical Mode</u    =
//      "filterRestMsg"    =   Would you like to reset the filter changes
//      "acres_hint"    =   Enter number of acres
//      "qt_hint"    =   Enter Quantity
//      "dop_hint"    =   Select date of purchase
//      "sop_hint"    =   Enter source of purchase
//      "dos_hint"    =   Select date of sowing
//      "doa_hint"    =   Select date of application
//      "add_product"    =   Bought Products
//      "activity_participation"    =   Activity Participation
//      "other_activities"    =   Other Activities
//      "click_on_at_info"    =   Click on number of activitites to see details
//
//    <!--Genuinity Check cashfree integration --    =
//        "rewards"    =   "Rewards";
//        "reward_shemes"    =   "Reward Schemes";
//        "transfer"    =   "Transfer";
//        "select_payment_mode"    =   "Select Payment Mode";
//        "bank_details"    =   "Bank Details";
//        "bank_transfer"    =   "banktransfer";
//        "upi"    =   "upi";
//        "upi_caps"    =   "UPI";
//        "paytm"    =   "paytm";
//        "paytm_title"    =   "Paytm";
//        "amazon_pay_gift_card"    =   "Amazon Pay gift Card";
//        "amazonpay"    =   "amazonpay";
//        "account_name"    =   "ACCOUNT NAME";
//        "account_number"    =   "ACCOUNT NUMBER";
//        "ifsc_code"    =   "IFSC CODE";
//        "upi_vpa"    =  " UPI VPA";
//        "phone_number"    =   "PHONE NUMBER";
//        "paytm_info"    =   "Please ensure that you have completed your KYC on Paytm";
//        "amazon_gift_card_info"    =   "The money will be credited to your Amazon Pay wallet \n\n 2)Please ensure that you have an active Amazon Pay account associated with the mobile number above";
//        "acout_name_error"    =   "Please enter account name";
//        "account_number_error"    =   "Please enter account number";
//      "account_number_valid_error"    =   "Please enter valid account number"
//        "ifsc_code_error"    =   "Please enter IFSC code";
//        "ifsc_code_valid_error"    =   "Please enter valid IFSC code";
//        "upi_error"    =   "Please enter UPI VPA";
//        "r_u_sure_u_want_to_go_back"    =   "Are you sure you want to go back?";
//        "amount_label"    =   "Amount";     <!-- duplicate of amount --    =
//        "redeem"    =   "Redeem";
//        "transactionId"    =  "Transaction Id";
//      "referenceId"    =   "Reference Id"
//      "reclaim"    =   "Reclaim"
//
//
//
//
//}
