//
//  RewardsViewCell.swift
//  FarmerConnect
//
//  Created by Empover on 19/05/21.
//  Copyright © 2021 ABC. All rights reserved.
//

import UIKit

class RGLCurrentOrderCell: UITableViewCell {
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemTitleLbl: UILabel!
    @IBOutlet weak var itemSubTitleLbl: UILabel!
    @IBOutlet weak var itemAmountLbl: UILabel!
    
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBAction func closeBtnAction(_ sender: Any) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    @IBOutlet weak var stepperBtn: UIStepper!

    @IBAction func stepperBtnAction(_ sender: Any) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
