//
//  ChangeLanguageTableViewCell.swift
//  FarmerConnect
//
//  Created by Apple on 28/11/19.
//  Copyright © 2019 ABC. All rights reserved.
//

import UIKit

class ChangeLanguageTableViewCell: UITableViewCell {

    @IBOutlet weak var lblLanguageName: UILabel!
    @IBOutlet weak var btnSelectRunSelect: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
