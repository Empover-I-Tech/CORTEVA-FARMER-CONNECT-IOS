//
//  PropOverTableDropDownViewController.swift
//  PioneerEmployee
//
//  Created by Admin on 28/08/19.
//  Copyright © 2019 Empover. All rights reserved.
//

import UIKit

protocol SavingViewControllerDelegate
{
    func yearSelected( strText : NSString)
}

class PropOverTableDropDownViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var arrYears : NSMutableArray?
    var farmerMobileNumber : String?
    var delegate : SavingViewControllerDelegate?
    var selectedYear : NSString!

    @IBOutlet weak var tblViewYears: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if arrYears?.count != 0 {
            tblViewYears.delegate = self
            tblViewYears.dataSource = self
            tblViewYears.reloadData()
        }

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrYears?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = String(format: "%@",self.arrYears?.object(at: indexPath.row) as! CVarArg )
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (self.delegate) != nil
        {
            delegate?.yearSelected(strText: arrYears?.object(at: indexPath.row) as? NSString ?? "0")
            self.dismiss(animated: true, completion: nil)
        }        
    }
}
