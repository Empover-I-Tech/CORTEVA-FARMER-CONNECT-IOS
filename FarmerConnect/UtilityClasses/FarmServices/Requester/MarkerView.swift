//
//  MarkerView.swift
//  FarmerConnect
//
//  Created by Admin on 10/01/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit
import Kingfisher

 @objc class MarkerView: UIView {

    @IBOutlet var imageEquipment : UIImageView?
    @IBOutlet var imageCount : UIImageView?


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
    
    @objc class func instanceFromNib() -> MarkerView {
        return UINib(nibName: "MarkerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MarkerView
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
    
    @objc func loadMarkerImageFromImageUrl( _ imageUrl: String?){
        if imageUrl != nil {
            let imageUrl = URL(string: imageUrl! as String!)
            self.imageEquipment?.kf.setImage(with: imageUrl as Resource!, placeholder: UIImage(named: "image_placeholder.png"), options: nil, progressBlock: nil)
        }
    }
}
