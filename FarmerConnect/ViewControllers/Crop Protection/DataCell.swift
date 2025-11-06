//
//  DataCell.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 30/03/20.
//  Copyright © 2020 ABC. All rights reserved.
//

import UIKit

class DataCell: UITableViewCell {
    
    @IBOutlet weak var lbl_message : UILabel!
    @IBOutlet weak var img_Arrow : UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
