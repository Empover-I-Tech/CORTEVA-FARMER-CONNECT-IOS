//
//  CropDiagnosisCollectionViewCell.swift
//  FarmerConnect
//
//  Created by Empover on 28/12/17.
//  Copyright © 2017 ABC. All rights reserved.
//

import UIKit

class CropDiagnosisCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cropDiagnosisBtn: UIButton!
    
    convenience init() {
        self.init()
        cropDiagnosisBtn = UIButton()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
