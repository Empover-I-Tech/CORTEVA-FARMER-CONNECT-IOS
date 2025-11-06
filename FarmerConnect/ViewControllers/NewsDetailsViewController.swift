//
//  NewsDetailsViewController.swift
//  FarmerConnect
//
//  Created by Empover i-Tech Pvt Ltyd on 19/04/19.
//  Copyright © 2019 ABC. All rights reserved.
//

import UIKit

class NewsDetailsViewController: BaseViewController {

    @IBOutlet var lblNewsTitle: UILabel!
    @IBOutlet var lblHeader1: UILabel!
    
    @IBOutlet var txtViewDesc: UITextView!
    @IBOutlet var lblHeader2: UILabel!
    
    @IBOutlet var lblHeader3: UILabel!
    
    var newsData : NewsEntityDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        lblNewsTitle.text = newsData?.value(forKey: "newsType") as? String
        lblHeader1.text = newsData?.value(forKey: "heading1") as? String
        lblHeader2.text = newsData?.value(forKey: "heading2") as? String
        lblHeader3.text = newsData?.value(forKey: "heading3") as? String
   
        txtViewDesc.text = newsData?.value(forKey: "newsDescription") as? String

}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isHidden = false
        self.topView?.isHidden = false
        self.lblTitle?.text = NSLocalizedString("news", comment: "") //"News"
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
