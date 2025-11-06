//
//  ColorSettings.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 22/06/20.
//  Copyright © 2020 ABC. All rights reserved.
//

import UIKit

enum InterfaceStyle {
    case light
    case dark
}

struct ColorSettings {
    
    static var shared : ColorSettings = ColorSettings()
    var interfaceStyle  : InterfaceStyle{
        get{
            UserDefaults.standard.string(forKey: "interfaceStyle") == "light" ? InterfaceStyle.light : InterfaceStyle.dark
        }set {
            UserDefaults.standard.setValue(newValue == .light ? "light" : "dark", forKey: "interfaceStyle")
             self.sendNotification()
        }
      
    }
     func sendNotification(){
         NotificationCenter.default.post(name: NSNotification.Name("interfaceChanged"), object: nil)
     }
}

