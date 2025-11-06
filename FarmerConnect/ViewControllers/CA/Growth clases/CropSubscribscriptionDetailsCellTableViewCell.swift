

//
//  CropSubscribscriptionDetailsCellTableViewCell.swift
//  FarmerConnect
//
//  Created by Apple on 07/11/19.
//  Copyright © 2019 ABC. All rights reserved.
//

import UIKit

open class CropSubscribscriptionDetailsCellTableViewCell: UITableViewCell,UIScrollViewDelegate{
    
    @IBOutlet weak var lblNoDataAvailable: UILabel!
    @IBOutlet weak var lblDisplayDate: UILabel!
    
    @IBOutlet weak var lblStage: UILabel!
    
    @IBOutlet weak var lbl_prevPhaseDays: UILabel!
    @IBOutlet weak var img_prevPhase: UIImageView!
    @IBOutlet weak var lbl_prevPhaseTitle: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblMessageOtherLang: UILabel!
    @IBOutlet weak var lblMessageEnglish: UILabel!
    @IBOutlet weak var lblExpectedDate: UILabel!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var view_previous: UIView!
    @IBOutlet weak var view_next: UIView!
    @IBOutlet weak var playOrangeBtn: UIButton!
    @IBOutlet weak var img_nextPhase: UIImageView!
    @IBOutlet weak var lbl_nextPhaseDays: UILabel!
    @IBOutlet weak var lbl_nextPhaseTitle: UILabel!
    
    @IBOutlet weak var lbl_prevObjDate: UILabel!
    @IBOutlet weak var lbl_nextObjDate: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    
     @IBOutlet weak var custSlider: UISlider!
     @IBOutlet weak var lblValue: UILabel!
     @IBOutlet weak var lblScrollbar: UILabel!

    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblScrollbar.isHidden = false
        
        let when = DispatchTime.now() + 1.0
        DispatchQueue.main.asyncAfter(deadline: when){
            self.messageTextView.isScrollEnabled = true
        }
        self.messageTextView.flashScrollIndicators()
        img_nextPhase.layer.cornerRadius = img_nextPhase.frame.height/2
        img_nextPhase.layer.masksToBounds = true
        img_prevPhase.layer.cornerRadius = img_prevPhase.frame.height/2
        img_prevPhase.layer.masksToBounds = true
//        self.custSlider.thumbRect(forBounds: CGRect(x: 0, y: 0, width: 5, height: 5), trackRect: CGRect(x: 0, y: 0, width: 5, height: 5), value: 5)
        self.custSlider.trackRect(forBounds: self.custSlider.bounds)
    }
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.lblScrollbar.isHidden = true
        self.messageTextView.isScrollEnabled = true
        self.messageTextView.showsVerticalScrollIndicator = true
        
    }
    
}

class customSlider : UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
           let point = CGPoint(x: bounds.minX, y: bounds.midY)
           return CGRect(origin: point, size: CGSize(width: bounds.width, height: 5))
       }
}
