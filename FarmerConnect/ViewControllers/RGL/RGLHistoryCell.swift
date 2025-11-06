//
//  RewardsViewCell.swift
//  FarmerConnect
//
//  Created by Empover on 19/05/21.
//  Copyright © 2021 ABC. All rights reserved.
//

import UIKit

class RGLHistoryCell: UITableViewCell {
    

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var orderIDValueLbl: UILabel!
    @IBOutlet weak var itemTitleLbl: UILabel!
    @IBOutlet weak var itemSubTitleLbl: UILabel!
    @IBOutlet weak var subImage: UIImageView!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var itemStatusLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
