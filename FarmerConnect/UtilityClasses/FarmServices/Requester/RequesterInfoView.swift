//
//  RequesterInfoView.swift
//  FarmerConnect
//
//  Created by Admin on 24/01/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit

class RequesterInfoView: UIView {

    @objc var nibName: String {
        return String(describing: type(of: self))
    }
    
    /**
     *  Called when first loading the nib.
     *  Defaults to `[NSBundle bundleForClass:[self class]]`
     *
     *  @return The bundle in which to find the nib.
     */
    @objc var nibBundle: Bundle {
        return Bundle(for: type(of: self))
    }
    
    /**
     *  Use the 2 methods above to instanciate the correct instance of UINib for the view.
     *  You can override this if you need more customization.
     *
     *  @return An instance of UINib
     */
    
    @objc var nib: UINib {
        return UINib(nibName: self.nibName, bundle: self.nibBundle)
    }
    
    @objc class func instanceFromNib() -> RequesterInfoView {
        return UINib(nibName: "RequesterInfoView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RequesterInfoView
    }
    fileprivate var shouldAwakeFromNib: Bool = true
    
    @objc override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
        //self.createFromNib()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    @objc override open func awakeFromNib() {
        super.awakeFromNib()
        self.shouldAwakeFromNib = false
        self.commonInit()
    }
    
    @objc func commonInit(){
        
    }
    @IBAction func closeInfoViewButtonClick(_ sender: UIButton){
        UIView.animate(withDuration: 0.5, animations: {
            self.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height + 40, width: self.frame.size.width, height: self.frame.size.height)
        }) { (status) in
            self.removeFromSuperview()
        }
    }

}
