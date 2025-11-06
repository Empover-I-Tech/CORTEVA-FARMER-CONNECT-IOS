//
//  StackViewCell.swift
//  DropDownCells
//
//  Created by Max on 2/15/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit

class StackViewCell: UITableViewCell {
    
    var cellExists:Bool = false

    @IBOutlet var openView: UIView!
     @IBOutlet weak var topCon: NSLayoutConstraint!
    
    @IBOutlet var stuffView: UIView! {
        didSet {
            stuffView?.isHidden = true
            stuffView?.alpha = 0
        }
    }
    
    @IBOutlet var open: UIButton!

    
    @IBOutlet var textView: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func animate(duration:Double, c: @escaping () -> Void) {
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModePaced, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: duration, animations: {
                
                self.stuffView.isHidden = !self.stuffView.isHidden
                if self.stuffView.alpha == 1 {
                    self.stuffView.alpha = 0.5
                } else {
                    self.stuffView.alpha = 1
                }
                
            })
        }, completion: {  (finished: Bool) in
            print("animation complete")
            c()
        })
    }
    


    
}
