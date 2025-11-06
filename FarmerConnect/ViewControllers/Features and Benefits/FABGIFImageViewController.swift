//
//  FABGIFImageViewController.swift
//  PioneerEmployee
//
//  Created by Empover on 18/10/17.
//  Copyright © 2017 Empover. All rights reserved.
//

import UIKit
import Alamofire

class FABGIFImageViewController: UIViewController {

    @IBOutlet weak var gifImgView: UIImageView!
    
    var assetDictFromFABDetailsVC : NSDictionary?
    
    var fabDocumentsDirectory = NSString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
     
        //self.view.backgroundColor = UIColor(white: 1, alpha: 0.5) //UIColor.black.withAlphaComponent(0.5)
        //self.view.isOpaque = false
        self.presentedViewController?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        fabDocumentsDirectory = appDelegate.getFABFolderPath() as NSString
        print(fabDocumentsDirectory)
        self.checkGIFFileAvailable()
    }
    
    //MARK: checkGIFFileAvailable
    func checkGIFFileAvailable(){
        let docPath = self.getDocumentPath(assetDictFromFABDetailsVC?.value(forKey: "videoFile") as! NSString)
        let isFileExists = self.checkIfFileExists(atPath: docPath as String)
        if isFileExists == true {
            let gifURL = NSURL(fileURLWithPath: docPath as String)
            let imgURL = UIImage.gifImageWithURL(gifURL.absoluteString!)
            gifImgView.image = imgURL
        }
        else{
            if Reachability.isConnectedToNetwork() {
                let gifURL =  NSURL(string: assetDictFromFABDetailsVC?.value(forKey: "videoFile") as! String)
                let imgURL = UIImage.gifImageWithURL((gifURL?.absoluteString!)!)
                gifImgView.image = imgURL
                DispatchQueue.global().async {
                    self.downloadAssetAndStore(inDocumentsDirectory: self.assetDictFromFABDetailsVC?.value(forKey: "videoFile") as! NSString)
                }
            }
            else{
                self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
            }
        }
    }

    //MARK: getDocumentPath
    func getDocumentPath(_ assetStr: NSString) -> NSString {
        let assetArray = assetStr.components(separatedBy: "/") as NSArray
        let filePath = String(format: "%@/%@", fabDocumentsDirectory,assetArray.lastObject as! NSString) as NSString
        return filePath
    }
    
    //MARK: downloadAssetAndStore
    func downloadAssetAndStore(inDocumentsDirectory assetStr: NSString) {
        SwiftLoader.show(animated: true)
        let docPath = self.getDocumentPath(assetStr)
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let url = NSURL(fileURLWithPath: docPath as String)
            return (url as URL, [.removePreviousFile])
        }
        Alamofire.download(assetStr as String, to: destination).response { response in
            if response.destinationURL != nil {
                print(response.destinationURL!)
                print("gif file saved when clicked")
            }
        }
    }

    //MARK: checkIfFileExists
    func checkIfFileExists(atPath strPath: String) -> Bool {
        let fileExists: Bool = FileManager.default.fileExists(atPath: strPath)
        return fileExists
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeBtn_Touch_Up_Inside(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
