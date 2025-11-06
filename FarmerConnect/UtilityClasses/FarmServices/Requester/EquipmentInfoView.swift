//
//  EquipmentInfoView.swift
//  FarmerConnect
//
//  Created by Admin on 28/12/17.
//  Copyright © 2017 ABC. All rights reserved.
//

import UIKit

class EquipmentInfoView: UIView, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet var lblServiceHours : UILabel?
    @IBOutlet var lblClassicications : UILabel?
    @IBOutlet var lblModel : UILabel?
    @IBOutlet var collectionAvailable : UICollectionView?
    @IBOutlet var btnClose : UIButton?
    @IBOutlet var btnViewDetails : UIButton?
    @IBOutlet var contentView : UIView?

    var viewEquipmentDetailsHandler:((Equipment?) -> Void)?
    var bookEquipmentHandler:((Equipment?) -> Void)?

    var arrAvailableDates = NSArray()
    var arrRequestedDates = NSArray()
    var equipmentObj : Equipment?
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var nibName: String {
        return String(describing: type(of: self))
    }
    
    /**
     *  Called when first loading the nib.
     *  Defaults to `[NSBundle bundleForClass:[self class]]`
     *
     *  @return The bundle in which to find the nib.
     */
    var nibBundle: Bundle {
        return Bundle(for: type(of: self))
    }
    
    /**
     *  Use the 2 methods above to instanciate the correct instance of UINib for the view.
     *  You can override this if you need more customization.
     *
     *  @return An instance of UINib
     */
    
    var nib: UINib {
        return UINib(nibName: self.nibName, bundle: self.nibBundle)
    }
    
    class func instanceFromNib() -> EquipmentInfoView {
        return UINib(nibName: "EquipmentInfoView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EquipmentInfoView
    }
    fileprivate var shouldAwakeFromNib: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
        //self.createFromNib()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.shouldAwakeFromNib = false
        self.commonInit()
    }
    
    func commonInit(){
        collectionAvailable?.register(EquipDateCollectionViewCell.self, forCellWithReuseIdentifier: "EquipDateCell")
    }
    
    func reloadInfoViewData(){
        if equipmentObj != nil {
            lblServiceHours?.text = equipmentObj?.serviceAreaDistance as String!
            lblModel?.text = equipmentObj?.model as String!
            var string = equipmentObj?.availableDates
            string = string?.replacingOccurrences(of: " ", with: "") as NSString!
            if Validations.isNullString(string ?? "") == false{
                if let arrAvailable = string?.components(separatedBy: ",") as NSArray?{
                    self.arrAvailableDates = arrAvailable
                }
            }
            lblClassicications?.text = equipmentObj?.classification as String!
            if let arrAvailable = equipmentObj?.requestedDates!.components(separatedBy: ",") as NSArray?{
                self.arrRequestedDates = arrAvailable
            }
            self.collectionAvailable?.reloadData()
        }
    }
    
    func getDayOfWeek(today:String)->Int {
        
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.date(from: today)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.day, from: todayDate)
        let weekDay = myComponents.day
        return weekDay!
    }

    //MARK: collectionView datasource and delegate methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrRequestedDates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionAvailable?.dequeueReusableCell(withReuseIdentifier: "EquipDateCell", for: indexPath) as? EquipDateCollectionViewCell
        if let dateStr = arrRequestedDates.object(at: indexPath.row) as? String{
            let day = self.getDayOfWeek(today: dateStr)
            let dayStr = String(format: "%02d", day)
            cell?.dateButton.setTitle(dayStr, for: .normal)
            cell?.layer.cornerRadius = 14.0
            cell?.layer.masksToBounds = true
            cell?.backgroundColor = App_Theme_Blue_Color
            //print(arrAvailableDates)
            if arrAvailableDates.contains(dateStr) == true{
                cell?.backgroundColor = App_Theme_Blue_Color
            }
            else{
                cell?.backgroundColor = UIColor.red
            }
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 28, height: 28)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)//top,left,bottom,right
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if equipmentObj != nil {
            if bookEquipmentHandler != nil{
                self.bookEquipmentHandler!(equipmentObj)
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        print("Gesture",gestureRecognizer)
        if (gestureRecognizer is UITapGestureRecognizer && gestureRecognizer.state == UIGestureRecognizerState.ended) {
            return true
            
        } else {
            return false
            
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            // do something with your currentPoint
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            // do something with your currentPoint
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            // do something with your currentPoint
        }
    }
    
    //MARK: UIButton Click Methods
    @IBAction func viewDetailsButtonClick(_ sender: UIButton){
        if equipmentObj != nil {
            if viewEquipmentDetailsHandler != nil{
                self.viewEquipmentDetailsHandler!(equipmentObj)
            }
        }
    }
}
