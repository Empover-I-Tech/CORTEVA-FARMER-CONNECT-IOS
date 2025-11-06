//
//  GradientView.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 30/12/19.
//  Copyright © 2019 ABC. All rights reserved.
//

import UIKit

class GradientView: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
         let gradient = CAGradientLayer()
            gradient.frame = self.bounds
            gradient.startPoint = CGPoint.zero
            gradient.endPoint = CGPoint(x: 1, y: 1)
            gradient.colors = [(UIColor(red: 44.0 / 255.0, green: 103 / 255.0, blue: 166 / 255.0, alpha: 1.0)).cgColor, (UIColor(red: 73 / 255.0, green: 152.0 / 255.0, blue: 233 / 255.0, alpha: 1.0)).cgColor].compactMap { $0 }
            self.layer.insertSublayer(gradient, at: 0)
    }
}
