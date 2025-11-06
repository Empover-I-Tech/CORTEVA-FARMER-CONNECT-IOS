//
//  PlanterTableViewCell.swift
//  FarmerConnect
//
//  Created by Empover i-Tech on 29/03/23.
//  Copyright © 2023 ABC. All rights reserved.
//

import UIKit

class PlanterTableViewCell: UITableViewCell {
    @IBOutlet weak var lblfarmerNAme : UILabel!
    @IBOutlet weak var lblMobile : UILabel!
    @IBOutlet weak var lblCrop : UILabel!
    @IBOutlet weak var lblNoofAcres : UILabel!
    @IBOutlet weak var lblAddress : UITextView!
    @IBOutlet weak var imgUrl : UIImageView!
     @IBOutlet weak var approverejectImg : UIImageView!
    @IBOutlet weak var bgView : UIView!
    
    @IBOutlet weak var farmerView : UIView!
     @IBOutlet weak var statusView : UIView!
    @IBOutlet weak var mobileView : UIView!
    @IBOutlet weak var CropView : UIView!
    @IBOutlet weak var noofacresView : UIView!
    @IBOutlet weak var AddressView : UIView!
    
    @IBOutlet weak var viewDetailsBtn : UIButton!
      @IBOutlet weak var ApproveBtn : UIButton!
    @IBOutlet weak var lblpincode: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 5.0
        bgView.layer.borderColor = UIColor.gray.cgColor
        bgView.layer.borderWidth = 1.0
        
        viewDetailsBtn.layer.cornerRadius = 10.0
        lblAddress.contentInset = UIEdgeInsetsMake(-7.0,0.0,0,0.0);
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
