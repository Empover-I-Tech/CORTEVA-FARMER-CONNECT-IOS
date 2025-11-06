//
//  SubscriptionCropCellTableViewCell.swift
//  CropAdvisoryFramework
//
//  Created by Apple on 06/12/19.
//  Copyright © 2019 Empover iTech Pvt Ltd. All rights reserved.
//

import UIKit

open class SubscriptionCropCellTableViewCell: UITableViewCell {

    @IBOutlet weak var croptitle: UILabel!
    @IBOutlet weak var cropImage: UIImageView!
    @IBOutlet weak var bgView: UIView!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
