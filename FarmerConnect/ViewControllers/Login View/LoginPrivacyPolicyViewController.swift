//
//  LoginPrivacyPolicyViewController.swift
//  ActivityTracker
//
//  Created by Empover on 04/12/17.
//  Copyright © 2017 Empover. All rights reserved.
//

import UIKit
import Alamofire
import WebKit

class LoginPrivacyPolicyViewController: BaseViewController,WKNavigationDelegate {
    
    @IBOutlet weak var privacyPolicyWebView: WKWebView!
    
    var privacyPolicyURLStr = NSString()
    var isFromCanellationPolicy : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let net = NetworkReachabilityManager(host: "www.google.com")
        if net?.isReachable == true{
            privacyPolicyWebView.navigationDelegate = self
            SwiftLoader.show(animated: true)
            let url =  NSURL(string: privacyPolicyURLStr as String)
            let req = URLRequest(url: url! as URL)
            privacyPolicyWebView.load(req)
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.topView?.isHidden = false
        if isFromCanellationPolicy == true{
            self.lblTitle?.text =  NSLocalizedString("cancelpolicy", comment: "")
        }
    }
    
      func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
          SwiftLoader.show(animated: true)
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
              SwiftLoader.hide()
        }
        
   
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
           SwiftLoader.hide()
           self.view.makeToast(error.localizedDescription, duration: 1.0, position: .center)
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
//    }
    
    @IBAction func closeBtn_Touch_Up_Inside(_ sender: Any) {
        SwiftLoader.hide()
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
