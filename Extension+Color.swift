//
//  Extension+Color.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 22/06/20.
//  Copyright © 2020 ABC. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static var backgroundColor : UIColor {
            if #available(iOS 13.0, *) {
                return UIColor.systemBackground
            } else {
                // Fallback on earlier versions
                if ColorSettings.shared.interfaceStyle == .light {
                    return .white
                }else {
                    return .black
                }
            }
        
    }
    static var textColor : UIColor {
              if #available(iOS 13.0, *) {
                  return UIColor.systemGray
              } else {
                  // Fallback on earlier versions
                  if ColorSettings.shared.interfaceStyle == .light {
                      return .black
                  }else {
                    return .white
                  }
              }
          
      }
    
    static var buttonTextColor : UIColor {
               if #available(iOS 13.0, *) {
                   return UIColor.systemBlue
               } else {
                   // Fallback on earlier versions
                   if ColorSettings.shared.interfaceStyle == .light {
                       return .blue
                   }else {
                    return .white
                   }
               }
           
       }
}
