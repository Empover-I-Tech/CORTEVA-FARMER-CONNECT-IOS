//
//  BprofileCollectionViewCell.swift
//  Meetintro
//
//  Created by Empover i-Tech Pvt Ltyd on 21/11/17.
//  Copyright © 2017 Smaat Apps and Technologies. All rights reserved.
//

import UIKit

class EquipDateCollectionViewCell: UICollectionViewCell {
    
    var dateButton : UIButton!
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialization()
    }
    func initialization(){
        dateButton = UIButton(type: .custom)
        dateButton.frame = CGRect(x: 0, y: 0, width: 26  , height: 26)
        dateButton.titleLabel?.textAlignment = .center
        dateButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        dateButton.isUserInteractionEnabled = false
        contentView.addSubview(dateButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
