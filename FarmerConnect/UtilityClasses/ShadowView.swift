//
//  ShadowView.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 26/12/19.
//  Copyright © 2019 ABC. All rights reserved.
//

import UIKit

class ShadowView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib()
    {
            super.awakeFromNib()

            self.layer.shadowOffset =  CGSize(width: 0, height: 1)   // CGSizeMake(0, 1)
            self.layer.shadowColor = UIColor.lightGray.cgColor
            self.layer.shadowRadius = 1.5
            self.layer.shadowOpacity = 0.65
            self.layer.cornerRadius = 10
            self.clipsToBounds = true
            self.layer.masksToBounds = false
            self.layer.masksToBounds = false
        }

}
