//
//  DiseaseDetectedViewController.swift
//  PioneerEmployee
//
//  Created by Empover on 15/11/17.
//  Copyright © 2017 Empover. All rights reserved.
//

import UIKit
import Alamofire
import WebKit


class DiseaseDetectedViewController: BaseViewController,WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    var urlIDStr : NSString?
    var diseaseName : String?
    var diseaseRequestId : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let shareButton = UIButton(frame: CGRect(x:UIScreen.main.bounds.size.width-42,y: 6,width: 40,height: 40))
        shareButton.backgroundColor =  UIColor.clear
        shareButton.setImage( UIImage(named: "Share"), for: UIControlState())
        shareButton.addTarget(self, action: #selector(DiseaseDetectedViewController.shareButtonClick(_:)), for: UIControlEvents.touchUpInside)
        self.topView?.addSubview(shareButton)
            
        
        if Reachability.isConnectedToNetwork(){
        webView.navigationDelegate = self   //http://103.24.202.7:9090/CDI/
        let urlPath = String(format: "%@cropDiagnosis?screenType=cropDiseaseResponse&diseaseId=%@", arguments: [CDI_BASE_URL.replacingOccurrences(of: "rest/", with: ""),urlIDStr! as String])
        let url =  NSURL(string: urlPath as String)
        let req = URLRequest(url: url! as URL)
            self.webView!.load(req)
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
       
        let userObj = Constatnts.getUserObject()
               let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: "Disease List" , "Disease_Name" : ""] as [String : Any]
               self.registerFirebaseEvents(PV_CDI_Disease_Details, "", "", "", parameters: firebaseParams as NSDictionary)
    }
 
    
    @IBAction func shareButtonClick( _ sender: UIButton)
    {
        let urlPath = String(format: "%@=%@&%@=%@", Module,Disease_Details,Disease_Id,urlIDStr ?? "")
        let finalUrl = String(format: "%@%@", deepLinkBaseUrl,urlPath)
        let message = String(format: "Crop Diagnosis for  %@", diseaseName ?? "")

        let activityControl = Validations.showShareActivityController(viewController: self, fileUrl: URL(string: finalUrl)!, userName: "", message: message)
        self.present(activityControl, animated: true, completion: nil)
    }
//    //MARK: WebView delegate methods
//    func webViewDidStartLoad(_ webView: WKWebView) {
//        SwiftLoader.show(animated: true)
//    }
//
//    func webViewDidFinishLoad(_ webView: WKWebView) {
//        SwiftLoader.hide()
//        let zoom = webView.bounds.size.width / webView.scrollView.contentSize.width
//        webView.scrollView.setZoomScale(zoom, animated: true)
//    }
//
//    func webView(_ webView: WKWebView, didFailLoadWithError error: Error) {
//         SwiftLoader.hide()
//         self.view.makeToast(error.localizedDescription)
//    }
     func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
          SwiftLoader.show(animated: true)
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            SwiftLoader.hide()
                    let zoom = webView.bounds.size.width / webView.scrollView.contentSize.width
                    webView.scrollView.setZoomScale(zoom, animated: true)
        }
        
    
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            SwiftLoader.hide()
            self.view.makeToast(error.localizedDescription)
        }
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 10.0, *) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        super.viewWillAppear(true)
        self.topView?.isHidden = false
        lblTitle?.text = "Disease Detected"
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
    }
    
    override func backButtonClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
