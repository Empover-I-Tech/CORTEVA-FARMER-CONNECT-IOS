//
//  FontHelper.swift
//  FarmerConnect
//
//  Created by Empover on 17/06/26.
//  Copyright © 2026 ABC. All rights reserved.
//

import UIKit
import ObjectiveC

struct AppFont {

    static let regular = "HelveticaNowText-Regular"
    static let bold    = "Gilroy-Bold"

    static func regularFont(size: CGFloat) -> UIFont {
        return UIFont(name: regular, size: size) ?? UIFont.systemFont(ofSize: size)
    }

    static func boldFont(size: CGFloat) -> UIFont {
        return UIFont(name: bold, size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
}

// MARK: - UILabel
//extension UILabel {
//
//    open override func awakeFromNib() {
//        super.awakeFromNib()
//        applyFont()
//    }
//
//    open override func didMoveToSuperview() {
//        super.didMoveToSuperview()
//        applyFont()
//    }
//
//    private func applyFont() {
//        let size = self.font.pointSize
//        let name = self.font.fontName
//        
//        print("Font applied to UILabel",self.font.fontName)
//
//        if name.contains("Bold") || name.contains("Semibold") || name.contains("SFUI") {
//            self.font = AppFont.boldFont(size: size)
//        } else {
//            self.font = AppFont.regularFont(size: size)
//        }
//    }
//}
extension UILabel {

    static let swizzleFontImplementation: Void = {
       
        let originalMethod = class_getInstanceMethod(UILabel.self, #selector(setter: UILabel.font))
        let swizzledMethod = class_getInstanceMethod(UILabel.self, #selector(UILabel.customSetFont(_:)))

        if let original = originalMethod, let swizzled = swizzledMethod {
            method_exchangeImplementations(original, swizzled)
        }
    }()

    @objc func customSetFont(_ font: UIFont) {
        let size = font.pointSize
        let name = font.fontName
        print("Font applied to UILabel",self.font.fontName)
        if name.contains("Bold") || name.contains("Semibold") || name.contains("SFUI") {
            self.customSetFont(AppFont.boldFont(size: size))
        } else {
            self.customSetFont(AppFont.regularFont(size: size))
        }
    }
}

// MARK: - UIButton
extension UIButton {

    open override func awakeFromNib() {
        super.awakeFromNib()
        applyFont()
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        applyFont()
    }

    private func applyFont() {
        guard let font = self.titleLabel?.font else { return }

        let size = font.pointSize
        let name = font.fontName

        if name.contains("Bold") || name.contains("SFUI") {
            self.titleLabel?.font = AppFont.boldFont(size: size)
        } else {
            self.titleLabel?.font = AppFont.regularFont(size: size)
        }
    }
}

// MARK: - UITextField
extension UITextField {

    open override func awakeFromNib() {
        super.awakeFromNib()
        applyFont()
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        applyFont()
    }

    private func applyFont() {
        let size = self.font?.pointSize ?? 14
        self.font = AppFont.regularFont(size: size)
    }
}

// MARK: - UITextView
extension UITextView {

    open override func awakeFromNib() {
        super.awakeFromNib()
        applyFont()
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        applyFont()
    }

    private func applyFont() {
        let size = self.font?.pointSize ?? 14
        self.font = AppFont.regularFont(size: size)
    }
}
