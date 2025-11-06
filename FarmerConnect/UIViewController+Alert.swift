//
//  UIViewController+Alert.swift
//  UniqolabelMonolith
//
//  Created by cdp on 4/13/18.
//  Copyright © 2018 uniqolabel. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showNormalAlert( title : String, message: String) {
        let alertController = UIAlertController(title: title , message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showErrorAlert(alertMessage: String){
        let alertController = UIAlertController(title: title, message: alertMessage, preferredStyle: .alert)
        
        let backButtonAction = UIAlertAction(title: "OK", style: .cancel, handler: {
            alert -> Void in
            self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(backButtonAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

