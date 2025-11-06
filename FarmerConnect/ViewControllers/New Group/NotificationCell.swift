//
//  NotificationCell.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 06/05/20.
//  Copyright © 2020 ABC. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var imgNotification : UIImageView!
    @IBOutlet weak var lblMessage : UILabel!
    @IBOutlet weak var lblCreatedOn : UILabel!
    @IBOutlet weak var viewContent : UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
