//
//  CDIDiseaseCell.swift
//  FarmerConnect
//
//  Created by Apple on 05/12/19.
//  Copyright © 2019 ABC. All rights reserved.
//

import UIKit

class CDIDiseaseCell: UITableViewCell {

    @IBOutlet weak var btn_percentage: UIButton!
    @IBOutlet weak var lbl_DiseaseSubmittedDate: UILabel!
    @IBOutlet weak var lbl_diseaseNAme: UILabel!
    @IBOutlet weak var lbl_scientificName: UILabel!
    @IBOutlet weak var img_diesease: UIImageView!
    @IBOutlet weak var lbl_ResultDisease: UILabel!
    @IBOutlet weak var bgImg: UIImageView!
    @IBOutlet weak var resultsLableHeightConstant: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
