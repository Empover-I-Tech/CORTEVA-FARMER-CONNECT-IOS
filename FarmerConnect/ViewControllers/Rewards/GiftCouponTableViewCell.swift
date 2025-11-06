//
//  GiftCouponTableViewCell.swift
//  FarmerConnect
//
//  Created by Empover on 31/01/24.
//  Copyright © 2024 ABC. All rights reserved.
//

import UIKit

class GiftCouponTableViewCell: UITableViewCell {

    @IBOutlet weak var productNameDisplayLbl: UILabel!
    @IBOutlet weak var dateDisplayLbl: UILabel!
    @IBOutlet weak var statusDisplayLbl: UILabel!
    @IBOutlet weak var productNameValueLbl: UILabel!
    @IBOutlet weak var dateValueLbl: UILabel!
    @IBOutlet weak var statusValueLbl: UILabel!
    @IBOutlet weak var QRCodeImgBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
