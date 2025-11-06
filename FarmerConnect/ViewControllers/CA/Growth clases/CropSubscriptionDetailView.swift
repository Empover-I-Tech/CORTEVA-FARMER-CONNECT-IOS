//
//  CropSubscriptionDetailView.swift
//  CropAdvisoryFramework
//
//  Created by Apple on 04/12/19.
//  Copyright © 2019 Empover iTech Pvt Ltd. All rights reserved.
//

import UIKit

open class CropSubscriptionDetailView: UIView {
    
    
    @IBOutlet var contentViews: UIView!
    @IBOutlet weak var contentVieww: UIView!
    
    @IBOutlet weak var phaseTitleLbl: UILabel!
    @IBOutlet weak var CropImage: UIImageView!
    @IBOutlet weak var PlayBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    
    private func  commonInit(){

//        Bundle.main.loadNibNamed("CropSubscriptionDetailView", owner: self, options: nil)
//        addSubview(contentViews)
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CropSubscriptionDetailView", bundle: bundle)
        self.contentViews = nib.instantiate(withOwner: self, options: nil).first as? UIView
        addSubview(contentViews)
        
        contentViews.frame = self.bounds
        contentViews.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        contentViews.layer.cornerRadius = 2.0
        contentViews.layer.borderWidth = 0.0
//        contentViews.layer.borderColor = UIColor.gray.cgColor
    }
    
}
