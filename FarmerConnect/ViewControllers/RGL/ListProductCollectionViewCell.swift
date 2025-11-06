//
//  ProductCollectionViewCell.swift
//  FarmerConnect
//
//  Created by Empover on 06/11/24.
//  Copyright © 2024 ABC. All rights reserved.
//

import UIKit

class ListProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var mlLbl: UILabel!
    @IBOutlet weak var cropLbl: UILabel!
    @IBOutlet weak var viewBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
