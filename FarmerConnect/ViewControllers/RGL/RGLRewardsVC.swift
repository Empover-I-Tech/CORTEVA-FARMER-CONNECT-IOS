//
//  RGLRewardsVC.swift
//  FarmerConnect
//
//  Created by Empover on 04/11/24.
//  Copyright © 2024 ABC. All rights reserved.
//

import UIKit

class RGLRewardsVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    var isFromHome : Bool = false
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var listTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblTitle?.text = NSLocalizedString("onlyRewards", comment: "")
        let nib = UINib(nibName: "RGLRewardsViewCell", bundle:nil)
        self.listTable.register(nib, forCellReuseIdentifier: "RGLRewardsViewCell")
        self.listTable.separatorStyle = .none
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  listTable.dequeueReusableCell(withIdentifier: "RGLRewardsViewCell", for: indexPath) as! RGLRewardsViewCell
        cell.orderIdValueLbl.text = "35333433"
        cell.dateValueLbl.text = "2024-10-29"
        cell.orderQunValueLbl.text = "2"
        cell.approvedValueLbl.text = "4"
        cell.redeemValueLbl.text = "1"
        cell.addRewardValueLbl.text = "3"
        cell.orderStatusValueLbl.text = "Order Placed"
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
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
