//
//  CollapsibleTableViewHeader.swift
//  ios-swift-collapsible-table-section
//
//  Created by Yong Su on 5/30/16.
//  Copyright © 2016 Yong Su. All rights reserved.
//

import UIKit

public struct Section {
    var name: String
    var items: NSArray
    var collapsed: Bool
    
    public init(name: String, items: NSArray, collapsed: Bool = true) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
}
//extension UIColor {
//
//    convenience init(hex:Int, alpha:CGFloat = 1.0) {
//        self.init(
//            red:   CGFloat((hex & 0xFF0000) >> 16) / 255.0,
//            green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
//            blue:  CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
//            alpha: alpha
//        )
//    }
//
//}


extension UIView {
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        self.layer.add(animation, forKey: nil)
    }
}
protocol CollapsibleTableViewHeaderDelegate {
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int)
}

class CollapsibleTableViewHeader: UITableViewHeaderFooterView {
    
    var delegate: CollapsibleTableViewHeaderDelegate?
    var section: Int = 0
     let bgView = UIView()
    let titleLabel = UILabel()
    let arrowLabel = UILabel()
    let seperatorViewBottom = UIView()
    let seperatorViewTop = UIView()
    let arrowBtn = UIButton()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        // Content View
        contentView.backgroundColor = UIColor.clear //UIColor(hex: 0x2E3944)
        
        //let marginGuide = contentView.layoutMarginsGuide
        
        bgView.frame = CGRect(x: 2, y: 2, width: UIScreen.main.bounds.size.width-20 , height: self.contentView.frame.height - 4)
        // bgView.backgroundColor = UIColor.lightGray
        contentView.addSubview(bgView)
        seperatorViewTop.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width-16 , height: 1)
        seperatorViewTop.backgroundColor = UIColor.clear
        contentView.addSubview(seperatorViewTop)
        
      
     
        // Title label
        titleLabel.frame = CGRect(x: 8, y: 2, width: UIScreen.main.bounds.size.width-100 , height: 30)
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "Helvetica Neue", size: 14.0)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        
        self.contentView.addSubview(titleLabel)
       
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
//        titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
//        titleLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
//        //titleLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
//        titleLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: -8.0).isActive = true
        
        // Arrow label
        arrowBtn.frame = CGRect(x: UIScreen.main.bounds.size.width-80, y: 8, width: 20 , height: 20)
        //arrowLabel.textColor = UIColor.black
        arrowBtn.setImage(UIImage(named: "upArrow"), for: .normal)
        contentView.addSubview(arrowBtn)
        //
        //        arrowLabel.translatesAutoresizingMaskIntoConstraints = false
        //        arrowLabel.widthAnchor.constraint(equalToConstant: 12).isActive = true
        //        arrowLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        //        arrowLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        //        arrowLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true

        seperatorViewBottom.frame = CGRect(x: 0, y: 34, width: UIScreen.main.bounds.size.width-16 , height: 1)
        seperatorViewBottom.backgroundColor = UIColor.lightGray
        contentView.addSubview(seperatorViewBottom)
  
//        seperatorView.translatesAutoresizingMaskIntoConstraints = false
//        seperatorView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
//        seperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
//        //seperatorView.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
//        seperatorView.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 5.0).isActive = true
//        seperatorView.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
//        seperatorView.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        //
        // Call tapHeader when tapping on this header
        //
        
     
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CollapsibleTableViewHeader.tapHeader(_:))))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    // Trigger toggle section when tapping on the header
    //
    @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? CollapsibleTableViewHeader else {
            return
        }
        
        delegate?.toggleSection(self, section: cell.section)
    }
    
    func setCollapsed(_ collapsed: Bool) {
        //
        // Animate the arrow rotation (see Extensions.swf)
        //
        
        arrowBtn.rotate(collapsed ? 0.0 : -.pi/2)
    }
    
    func setCollapsedCrop(_ collapsed: Bool) {
        //
        // Animate the arrow rotation (see Extensions.swf)
        //
        arrowBtn.rotate(collapsed ? -.pi/2 : 0.0)
    }
}
