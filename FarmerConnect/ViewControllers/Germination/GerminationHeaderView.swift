//
//  GerminationHeaderView.swift
//  PioneerEmployee
//
//  Created by Empover on 08/08/18.
//  Copyright © 2018 Empover. All rights reserved.
//

import UIKit

public struct GerminationSection {
    var name: String
    var items: NSArray
    
    public init(name: String, items: NSArray) {
        self.name = name
        self.items = items
    }
}
class GerminationHeaderView: UITableViewHeaderFooterView {
    var section: Int = 0
    let titleLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        // Content View
        contentView.backgroundColor = UIColor(red: 57.0/255.0, green: 96.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        
        //Title label
        titleLabel.frame = CGRect(x: 5, y: 0, width: UIScreen.main.bounds.size.width-10 , height: 30)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        self.contentView.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
