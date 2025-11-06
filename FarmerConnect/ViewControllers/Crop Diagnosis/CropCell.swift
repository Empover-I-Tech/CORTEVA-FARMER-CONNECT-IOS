//
//  CropCell.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 28/12/19.
//  Copyright © 2019 ABC. All rights reserved.
//

import UIKit

class CropCell: UITableViewCell {

    @IBOutlet weak var imgCrop : UIImageView!
    @IBOutlet weak var lblCrop : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
