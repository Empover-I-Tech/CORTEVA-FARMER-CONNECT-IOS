//
//  NotificationService.swift
//  NotificationMediaExtention
//
//  Created by Admin on 09/01/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit
import UserNotifications
import MobileCoreServices

public enum MediaType: String {
    case image = "image"
    case gif = "gif"
    case video = "video"
    case audio = "audio"
}

fileprivate struct Media {
    private var data: Data
    private var ext: String
    private var type: MediaType
    
    init(forMediaType mediaType: MediaType, withData data: Data, fileExtension ext: String) {
        self.type = mediaType
        self.data = data
        self.ext = ext
    }
    
    var attachmentOptions: [String: Any?] {
        switch(self.type) {
        case .image:
            return [UNNotificationAttachmentOptionsThumbnailClippingRectKey: CGRect(x: 0.0, y: 0.0, width: 1.0, height: 0.50).dictionaryRepresentation]
        case .gif:
            return [UNNotificationAttachmentOptionsThumbnailTimeKey: 0]
        case .video:
            return [UNNotificationAttachmentOptionsThumbnailTimeKey: 0]
        case .audio:
            return [UNNotificationAttachmentOptionsThumbnailHiddenKey: 1]
        }
    }
    
    var fileIdentifier: String {
        return self.type.rawValue
    }
    
    var fileExt: String {
        if self.ext.count > 0 {
            return self.ext
        } else {
            switch(self.type) {
            case .image:
                return "jpeg"
            case .gif:
                return "gif"
            case .video:
                return "mp4"
            case .audio:
                return "mp3"
            }
        }
    }
    
    var mediaData: Data? {
        return self.data
    }
}

fileprivate extension UNNotificationAttachment {
    static func create(fromMedia media: Media) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
        let tmpSubFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)
        do {
            try fileManager.createDirectory(at: tmpSubFolderURL, withIntermediateDirectories: true, attributes: nil)
            let fileIdentifier = "\(media.fileIdentifier).\(media.fileExt)"
            let fileURL = tmpSubFolderURL.appendingPathComponent(fileIdentifier)
            
            guard let data = media.mediaData else {
                return nil
            }
            
            try data.write(to: fileURL)
            return self.create(fileIdentifier: fileIdentifier, fileUrl: fileURL, options: media.attachmentOptions as [String : Any])
        } catch {
            print("error " + error.localizedDescription)
        }
        return nil
    }
    
    static func create(fileIdentifier: String, fileUrl: URL, options: [String : Any]? = nil) -> UNNotificationAttachment? {
        var n: UNNotificationAttachment?
        do {
            n = try UNNotificationAttachment(identifier: fileIdentifier, url: fileUrl, options: options)
        } catch {
            print("error " + error.localizedDescription)
        }
        return n
    }
}

private func resourceURL(forUrlString urlString: String) -> URL? {
    return URL(string: urlString)
}

fileprivate func loadAttachment(forMediaType mediaType: MediaType, withUrlString urlString: String, completionHandler: ((UNNotificationAttachment?) -> Void)) {
    guard let url = resourceURL(forUrlString: urlString) else {
        completionHandler(nil)
        return
    }
    
    do {
        let data = try Data(contentsOf: url)
        let media = Media(forMediaType: mediaType, withData: data, fileExtension: url.pathExtension)
        if let attachment = UNNotificationAttachment.create(fromMedia: media) {
            completionHandler(attachment)
            return
        }
        completionHandler(nil)
    } catch {
        print("error " + error.localizedDescription)
        completionHandler(nil)
    }
}
class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    var urlS : String  = ""

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            //bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            
            //contentHandler(bestAttemptContent)
             let info = bestAttemptContent.userInfo["fcm_options"] as? NSDictionary
            if  let attachmentString = info?["image"] as? String,
            let attachmentURL = URL(string: attachmentString){
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let downloadtask  = session.downloadTask(with: attachmentURL) { (url, _, error) in
                if let err = error{
                    print(err)
                }else if let url = url {
                    if attachmentString.contains("gif") {
                        let attachment = try! UNNotificationAttachment(identifier: attachmentString, url: url, options: [UNNotificationAttachmentOptionsTypeHintKey : kUTTypeGIF])
                                    bestAttemptContent.attachments = [attachment]
                    }else {
                    let attachment = try! UNNotificationAttachment(identifier: attachmentString, url: url, options: [UNNotificationAttachmentOptionsTypeHintKey : kUTTypePNG])
                    bestAttemptContent.attachments = [attachment]
                    }
                    
                }
              contentHandler(bestAttemptContent)
            }
        
            downloadtask.resume()
            
            }
        }
      
    }
    
    func downloadImageFromURL(url : URL , with completionHandler: UNNotificationAttachment?)-> Void {
        let task = URLSession.shared.downloadTask(with: url) { (downloadedUrl, response,error ) in
            guard let downloadedUrl = downloadedUrl else {
                return
            }
            
//            var urlpath = URL(fileURLWithPath: NSTemporaryDirectory())
//            let uniqueURLEnding = ProcessInfo.processInfo.globallyUniqueString + ".jpg"
//            urlpath = urlpath.appendingPathComponent(uniqueURLEnding)
//            try? FileManager.default.moveItem(at: downloadedUrl, to: urlpath)
            do{
                let attachment = try UNNotificationAttachment(identifier:self.urlS , url: downloadedUrl, options:nil ) // [UNNotificationAttachmentOptionsTypeHintKey : ]
                self.bestAttemptContent?.attachments = [attachment]
                
            }
            catch {
            }
          
        }
        task.resume()
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
