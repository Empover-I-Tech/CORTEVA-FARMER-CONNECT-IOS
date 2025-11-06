//
//  BookNowTimeCell.swift
//  FarmerConnect
//
//  Created by Koya Anilkumar on 12/30/17.
//  Copyright © 2017 ABC. All rights reserved.
//

import UIKit

class BookNowTimeCell: UICollectionViewCell {
    @IBOutlet var btnSelect : UIButton?
    let Available_Color = UIColor(red: 204.0/255.0, green: 242.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    var isOutofRange : Bool = false {
        didSet {
            switch isOutofRange {
            case true:
                self.btnSelect?.backgroundColor = UIColor.gray//CalendarView.Style.CellColorToday
            case false:
                if isSelected == false{
                    self.btnSelect?.backgroundColor = Available_Color
                }
            }
        }
    }
    
    override var isSelected : Bool {
        didSet {
            switch isSelected {
            case true:
                self.btnSelect?.backgroundColor = App_Theme_Blue_Color
            case false:
                return
//                if isOutofRange == false{
//                    self.btnSelect?.backgroundColor = Available_Color
//                }
            }
        }
    }
}
