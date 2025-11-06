//
//  RateQuestionsViewController.swift
//  FarmerConnect
//
//  Created by Admin on 09/01/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit

class RateQuestionsViewController: UIViewController {

    var arrRatingQuestions : NSArray?
    @IBOutlet var tblQuestions : UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
