//
//  FABPdfViewController.swift
//  PioneerEmployee
//
//  Created by Empover on 09/10/17.
//  Copyright © 2017 Empover. All rights reserved.
//

import UIKit
import Alamofire
import WebKit

class FABPdfViewController: UIViewController,WKNavigationDelegate {

    var assetDictFromFABDetailsVC : NSDictionary?
    
    var fabDocumentsDirectory = NSString()
    
    @IBOutlet weak var pdfWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
        pdfWebView.navigationDelegate = self
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        fabDocumentsDirectory = appDelegate.getFABFolderPath() as NSString
        print(fabDocumentsDirectory)
        self.checkPDFFileAvailable()
        SwiftLoader.show(animated: true)
    }
    
//    //MARK: WebView delegate methods
//    func webViewDidStartLoad(_ webView: UIWebView) {
//        SwiftLoader.show(animated: true)
//    }
//
//    func webViewDidFinishLoad(_ webView: UIWebView) {
//        SwiftLoader.hide()
//    }
//
//    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
//        SwiftLoader.hide()
//        self.view.makeToast(error.localizedDescription, duration: 1.0, position: .center)
//        let _:Timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
//    }
     func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            SwiftLoader.show(animated: true)
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            SwiftLoader.hide()
        }
        
 
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
          SwiftLoader.hide()
        self.view.makeToast(error.localizedDescription, duration: 1.0, position: .center)
        let _:Timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
        }
    
    @objc func timerAction(){
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: checkPDFFileAvailable
    func checkPDFFileAvailable(){
        let docPath = self.getDocumentPath(assetDictFromFABDetailsVC?.value(forKey: "pdfFile") as! NSString)
        let isFileExists = self.checkIfFileExists(atPath: docPath as String)
        if isFileExists == true {
            let url = NSURL(fileURLWithPath: docPath as String)
            let req = URLRequest(url: url as URL)
            pdfWebView.load(req)
        }
        else{
            if Reachability.isConnectedToNetwork() {
                let url =  NSURL(string: assetDictFromFABDetailsVC?.value(forKey: "pdfFile") as! String)
                let req = URLRequest(url: url! as URL)
                pdfWebView.navigationDelegate = self
                pdfWebView.load(req)
                DispatchQueue.global().async {
                    self.downloadAssetAndStore(inDocumentsDirectory: self.assetDictFromFABDetailsVC?.value(forKey: "pdfFile") as! NSString)
                }
            }
            else{
                //self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE, duration: 1.0, position: .center)
                 self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                return
            }
        }
    }
    
    //MARK: getDocumentPath
    func getDocumentPath(_ assetStr: NSString) -> NSString {
        let assetArray = assetStr.components(separatedBy: "/") as NSArray
        let filePath = String(format: "%@/%@", fabDocumentsDirectory,assetArray.lastObject as! NSString) as NSString
        return filePath
    }
    
    //MARK: checkIfFileExists
    func checkIfFileExists(atPath strPath: String) -> Bool {
        let fileExists: Bool = FileManager.default.fileExists(atPath: strPath)
        return fileExists
    }

    //MARK: downloadAssetAndStore
    func downloadAssetAndStore(inDocumentsDirectory assetStr: NSString) {
         SwiftLoader.show(animated: true)
        let docPath = self.getDocumentPath(assetStr)
//        DispatchQueue.global().async {
//            
//            let urlToDownload = assetStr as String
//            print("download started :\(urlToDownload)")
//            
//            let url = NSURL(string: urlToDownload)
//            
//            print("url :\(url!)")
//            
//            DispatchQueue.main.async {
//                SwiftLoader.hide()
//                do {
//                    let dataObj = NSData(contentsOf: (url!) as URL)
//                    
//                    dataObj?.write(toFile: docPath as String, atomically: true)
//                }
//                print("file saved")
//            }
//        }
        print(assetStr)
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let url = NSURL(fileURLWithPath: docPath as String)
            return (url as URL, [.removePreviousFile])
        }
        Alamofire.download(assetStr as String, to: destination).response { response in
            if response.destinationURL != nil {
                print(response.destinationURL!)
                print("pdf file saved when clicked")
            }
        }
    }
    
    @IBAction func closeBtn_Touch_Up_Inside(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
