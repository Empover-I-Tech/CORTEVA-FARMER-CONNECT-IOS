//
//  BookletCell.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 30/04/20.
//  Copyright © 2020 ABC. All rights reserved.
//

import UIKit

class BookletCell: UITableViewCell {
    
    @IBOutlet weak var imgBooklet : UIImageView!
    @IBOutlet weak var lblMediaName : UILabel!
    @IBOutlet weak var lblUpdateDate : UILabel!
    @IBOutlet weak var btnShare : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
