//
//  BookNowCalanderViewController.swift
//  FarmerConnect
//
//  Created by Admin on 03/01/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit

class BookNowCalanderViewController: RequesterBaseViewController,CalendarViewDelegate,CalendarViewDataSource {
    @IBOutlet var calendarView : CalendarView?
    @IBOutlet var scrollContent : UIView?
    @IBOutlet var btnProceed : UIButton?
    @IBOutlet var contentViewHeightContraint : NSLayoutConstraint?
    
    var selectedSchedule : Schedule?
    var selectedEquipment : Equipment?
    var minimumServiceHours : NSString?
    var arrAvailability = NSMutableArray()
    var btnDone : UIButton?
    var scheduleDeleteAlert = UIView()
    var selectedDate : String?
    var dateSelectionCompletionBlock : ((_ bookingDateStr : String?,_ bookingDate: Date?) -> (Void))?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calendarView?.isFromBooking = true
        CalendarView.Style.CellShape = .Round
        CalendarView.Style.CellColorDefault = UIColor.clear
        //CalendarView.Style.CellColorToday = UIColor(red:1.00, green:0.84, blue:0.64, alpha:1.00)
        CalendarView.Style.CellBorderColor = UIColor(red:1.00, green:0.63, blue:0.24, alpha:1.00)
        CalendarView.Style.CellEventColor = UIColor(red:1.00, green:0.63, blue:0.24, alpha:1.00)
        CalendarView.Style.HeaderTextColor = UIColor.gray
        CalendarView.Style.CellTextColorDefault = UIColor.black
        calendarView?.collectionView.allowsMultipleSelection = false
        //CalendarView.Style.CellTextColorToday = UIColor(red:0.31, green:0.44, blue:0.47, alpha:1.00)
        
        calendarView?.scheduledDates = self.arrAvailability
        calendarView?.dataSource = self
        calendarView?.delegate = self
        calendarView?.direction = .horizontal
        
        //calendarView.backgroundColor = UIColor(red:0.31, green:0.44, blue:0.47, alpha:1.00)
        calendarView?.isRanged = true
        calendarView?.fromDate = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 20, to: Date())
        calendarView?.toDate = tomorrow!
        //calendarView.endDateCache = tomorrow!
        calendarView?.reloadData()
        self.btnProceed?.isHidden = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.topView?.isHidden = false
        self.lblTitle?.text = "Select Date"
    }
    
    @IBAction func doneButtonClick(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func proceedButtonClick(_ sender: UIButton){
        if self.selectedDate != nil {
            if self.dateSelectionCompletionBlock != nil{
                dateSelectionCompletionBlock!(self.selectedDate ,nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
        else{
            self.view.makeToast(Select_Date)
        }
    }
    @IBAction func goToPreviousMonth(_ sender: Any) {
        self.calendarView!.goToPreviousMonth()
    }
    @IBAction func goToNextMonth(_ sender: Any) {
        self.calendarView!.goToNextMonth()
        
    }
    // MARK : KDCalendarDataSource
    
    func startDate() -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = 0
        let today = Date()
        let threeMonthsAgo = self.calendarView?.calendar.date(byAdding: dateComponents, to: today)!
        return threeMonthsAgo!
    }
    
    func endDate() -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = 20;
        let tomorrow = Calendar.current.date(byAdding: .day, value: 20, to: Date())
        let twoYearsFromNow = self.calendarView?.calendar.date(byAdding: dateComponents, to: tomorrow!)!
        return twoYearsFromNow!
        
    }
    
    // MARK : KDCalendarDelegate
    
    func calendar(_ calendar: CalendarView, didSelectDate date : Date, withEvents events: [CalendarEvent]) {
        let compareDateStr = FarmServicesConstants.getDateStringFromDate(serverDate: date)
        if compareDateStr != nil{
            if self.arrAvailability.count > 0{
                if Validations.isNullString(compareDateStr!) == false {
                    if arrAvailability.contains(compareDateStr!){
                        self.selectedDate = compareDateStr as String?
                        if self.dateSelectionCompletionBlock != nil{
                            dateSelectionCompletionBlock!(compareDateStr as String?,date)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
        /*print("Did Select: \(date) with \(events.count) events")
         for event in events {
         print("\t\"\(event.title)\" - Starting at:\(event.startDate)")
         }*/
    }
    
    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {
        let compareDateStr = FarmServicesConstants.getDateStringFromDate(serverDate: date)
        if compareDateStr != nil{

        }
    }
    func calendar(_ calendar: CalendarView, didScrollToMonth date : Date) {
        
        //self.datePicker.setDate(date, animated: true)
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
