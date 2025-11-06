//
//  LocalisationExtension.swift
//  FarmerConnect
//
//  Created by Apple on 03/12/19.
//  Copyright © 2019 ABC. All rights reserved.
//

import UIKit

protocol Localizable {
    var localized: String { get }
}
extension String: Localizable {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
protocol XIBLocalizable {
    var xibLocKey: String? { get set }
}

extension UILabel: XIBLocalizable {
    @IBInspectable var xibLocKey: String? {
        get { return nil }
        set(key) {
            IQKeyboardManager.sharedManager().toolbarDoneBarButtonItemText = NSLocalizedString("done", comment: "")
            text = key?.localized
        }
    }
}
extension UIButton: XIBLocalizable {
    @IBInspectable var xibLocKey: String? {
        get { return nil }
        set(key) {
            setTitle(key?.localized, for: .normal)
        }
    }
}
extension UITextField: XIBLocalizable {
    @IBInspectable var xibLocKey: String? {
        get { return nil }
        set(key) {
            IQKeyboardManager.sharedManager().toolbarDoneBarButtonItemText = NSLocalizedString("done", comment: "")
            placeholder = key?.localized
        }
    }
}
