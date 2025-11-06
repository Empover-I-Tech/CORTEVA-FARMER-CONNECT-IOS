//
//  SubscriptionCreatePop.swift
//  CropAdvisoryFramework
//
//  Created by Apple on 04/12/19.
//  Copyright © 2019 Empover iTech Pvt Ltd. All rights reserved.
//

import UIKit

open class SubscriptionCreatePop: UIView {

    
    @IBOutlet var contentViews: UIView!
    @IBOutlet weak var phaseTitleLbl: UILabel!
    @IBOutlet weak var hybridBgView: UIView!
    @IBOutlet weak var cropBgView: UIView!
    @IBOutlet weak var dateOfSowingview: UIView!
    @IBOutlet weak var hybridTf: UITextField!
    @IBOutlet weak var dateOfSowingTF: UITextField!
    @IBOutlet weak var cropTF: UITextField!
    
    @IBOutlet weak var categoryTxtFld: UITextField!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var cropDropDownArrow: UIImageView!
    @IBOutlet weak var hybridDropDownArrow: UIImageView!
    @IBOutlet weak var dateOfsowDropDownArrow: UIImageView!
    
    @IBOutlet weak var seasonBgView: UIView!
    @IBOutlet weak var categoryDropdownImg: UIImageView!
    @IBOutlet weak var seasonTxtFld: UITextField!
    
    
    @IBOutlet weak var seasonDropDownImg: UIImageView!
    @IBOutlet weak var SubscribeBtn: UIButton!
    @IBOutlet weak var exitBtn: UIButton!
    
    @IBOutlet weak var noOfacresBgView: UIView!
    @IBOutlet weak var noOfAcresTxtField: UITextField!
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
        //        inputTextField.delegate = self
    }
    
    public func  commonInit(){
        //do stuff here
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SubscriptionCreatePop", bundle: bundle)
        self.contentViews = nib.instantiate(withOwner: self, options: nil).first as? UIView
        addSubview(contentViews)
        
        
//        Bundle.main.loadNibNamed("SubscriptionCreatePop", owner: self, options: nil)
//        addSubview(contentViews)
        self.contentViews.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.contentViews.topAnchor.constraint(equalTo: self.topAnchor),
            self.contentViews.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.contentViews.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.contentViews.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            ])
        contentViews.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        contentViews.layer.cornerRadius = 10.0
        contentViews.layer.borderWidth = 100
        contentViews.layer.borderColor = UIColor.clear.cgColor
        cropBgView = getCorener(cropBgView)
        //   seasonBgView = getCorener(seasonBgView)
        categoryView = getCorener(categoryView)
        hybridBgView = getCorener(hybridBgView)
        dateOfSowingview = getCorener(dateOfSowingview)
        noOfacresBgView = getCorener(noOfacresBgView)
        exitBtn.roundCorners([.layerMinXMaxYCorner], radius: 10.0, borderColor: UIColor.lightGray, borderWidth: 1)
        SubscribeBtn.roundCorners([ .layerMaxXMaxYCorner], radius: 10.0, borderColor: UIColor.lightGray, borderWidth: 1)
        contentViews.roundCorners([.layerMinXMaxYCorner,.layerMaxXMaxYCorner], radius: 10.0, borderColor: UIColor.clear, borderWidth: 1)
        
        categoryTxtFld.setLeftPaddingPoints(10)
        cropTF.setLeftPaddingPoints(10)
        hybridTf.setLeftPaddingPoints(10)
        noOfAcresTxtField.setLeftPaddingPoints(10)
        dateOfSowingTF.setLeftPaddingPoints(10)
    }
    
    func getCorener(_ view :  UIView) -> UIView{
        let viewBg = view
        viewBg.layer.cornerRadius = 10.0
        viewBg.layer.borderWidth = 1.0
        viewBg.layer.borderColor = UIColor.gray.cgColor
        return viewBg
    }
    
    
}

