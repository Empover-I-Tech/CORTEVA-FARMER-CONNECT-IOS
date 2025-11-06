//
//  RGLOrderViewController.swift
//  FarmerConnect
//
//  Created by Empover on 11/11/24.
//  Copyright © 2024 ABC. All rights reserved.
//

import UIKit

class RGLOrderViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet weak var subTotalValueLbl: UILabel!
    @IBOutlet weak var rewardPointValueLbl: UILabel!
    @IBOutlet weak var totalAmountValueLbl: UILabel!
   
    @IBOutlet weak var historyBtn: UIButton!
    @IBOutlet weak var currentOrdersBtn: UIButton!
    @IBOutlet weak var historyTable: UITableView!
    @IBOutlet weak var currentOrderTable: UITableView!
    
    @IBOutlet weak var currentOrderView: UIView!
    
    @IBOutlet weak var HistoryView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblTitle?.text = NSLocalizedString("onlyRewards", comment: "")
        self.currentOrdersBtn.setTitle(NSLocalizedString("currentOrders", comment: ""), for: .normal)
        self.historyBtn.setTitle(NSLocalizedString("history", comment: ""), for: .normal)
        self.currentOrdersBtn.backgroundColor = UIColor(hex: 0x499BFC)
        self.currentOrdersBtn.setTitleColor(UIColor.white, for: .normal)
        
        self.historyBtn.backgroundColor = UIColor.white
        self.historyBtn.setTitleColor(UIColor(hex: 0x499BFC), for: .normal)
        self.currentOrderView.isHidden = false
        self.HistoryView.isHidden = true

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "RGLCurrentOrderCell", bundle:nil)
        self.currentOrderTable.register(nib, forCellReuseIdentifier: "RGLCurrentOrderCell")
        self.currentOrderTable.separatorStyle = .none
        
        let nib1 = UINib(nibName: "RGLHistoryCell", bundle:nil)
        self.historyTable.register(nib1, forCellReuseIdentifier: "RGLHistoryCell")
        self.historyTable.separatorStyle = .none
        
        self.subTotalValueLbl.text = "366"
        self.rewardPointValueLbl.text = "0.00"
        self.totalAmountValueLbl.text = "366"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  currentOrderTable.dequeueReusableCell(withIdentifier: "RGLCurrentOrderCell", for: indexPath) as! RGLCurrentOrderCell
        
        let cell1 =  historyTable.dequeueReusableCell(withIdentifier: "RGLHistoryCell", for: indexPath) as! RGLHistoryCell
        //cell.itemImage.setImage(UIImage(named: "radioEmpty") ?? "", for: .normal)
        if tableView == currentOrderTable {
            cell.itemTitleLbl.text = "DELEGATE (20.00ml)"
            cell.itemSubTitleLbl.text = "3666.00"
            cell.itemAmountLbl.text = "366.00"
            cell.itemImage.image = UIImage(named: "radioEmpty")
            cell.closeBtn.setTitle("", for: .normal)
        }
        else if tableView == historyTable {
            cell1.itemTitleLbl.text = "DELEGATE"
            cell1.itemSubTitleLbl.text = "Delivery by 2024-10-29"
            cell1.itemStatusLbl.text = "Order Placed"
            cell1.itemImage.image = UIImage(named: "radioEmpty")
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
    
    @IBAction func proceedBtnAction(_ sender: Any) {
    }
    @IBAction func historyBtnAction(_ sender: Any) {
        self.currentOrdersBtn.backgroundColor = UIColor.white
        self.currentOrdersBtn.setTitleColor(UIColor(hex: 0x499BFC), for: .normal)
        
        self.historyBtn.backgroundColor = UIColor(hex: 0x499BFC)
        self.historyBtn.setTitleColor(UIColor.white, for: .normal)
        
        self.currentOrderView.isHidden = true
        self.HistoryView.isHidden = false

    }
    @IBAction func currentOrderBtnAction(_ sender: Any) {
        self.currentOrdersBtn.backgroundColor = UIColor(hex: 0x499BFC)
        self.currentOrdersBtn.setTitleColor(UIColor.white, for: .normal)
        
        self.historyBtn.backgroundColor = UIColor.white
        self.historyBtn.setTitleColor(UIColor(hex: 0x499BFC), for: .normal)

        self.currentOrderView.isHidden = false
        self.HistoryView.isHidden = true
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
