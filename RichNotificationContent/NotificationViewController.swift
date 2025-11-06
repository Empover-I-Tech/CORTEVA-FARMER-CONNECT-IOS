//
//  NotificationViewController.swift
//  RichNotificationContent
//
//  Created by Empover-i-Tech on 04/05/20.
//  Copyright © 2020 ABC. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    @IBOutlet var imgAttachment: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
        
        let attachments = notification.request.content.attachments
        for attachment in attachments {
            if attachment.identifier == "picture" {
                print("imageurl :",attachment.url)
            }
            guard let data  = try? Data(contentsOf: attachment.url)else {
                return
            }
            imgAttachment?.image = UIImage(data: data)
        }
    }

}
