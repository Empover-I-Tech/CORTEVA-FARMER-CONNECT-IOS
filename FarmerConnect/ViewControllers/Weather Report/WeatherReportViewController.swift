//
//  HomeViewController.swift
//  Weather Plugin
//
//  Created by Admin on 31/08/17.
//  Copyright © 2017 Empover. All rights reserved.
//

import UIKit

class WeatherReportViewController: BaseViewController {

    @IBOutlet weak var segmentControl : UISegmentedControl!
    var currentViewController : UIViewController?
    var oldController : UIViewController?
    var viewContriollersArray : NSMutableArray?
    let controllersArray : [String] = ["WeatherViewController","HourlyForecastViewController"]

    @IBOutlet var containerView : UIView?
    
    var isFromHome = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.segmentControl.setTitle(NSLocalizedString("day", comment: ""), forSegmentAt: 0)
        self.segmentControl.setTitle(NSLocalizedString("hour", comment: ""), forSegmentAt: 1)
        
        // Do any additional setup after loading the view.
        viewContriollersArray = NSMutableArray()
        //currentViewController = self.storyboard?.instantiateViewController(withIdentifier: "WeatherViewController")
        //viewContriollersArray?.add(currentViewController!)
        //self.addChildViewController(currentViewController!)
        //self.containerView!.addSubview((currentViewController?.view)!)
        //self.currentViewController!.didMove(toParentViewController: self)
        self.view.layoutSubviews()
        self.view.updateConstraintsIfNeeded()
        self.view.layoutIfNeeded()
        self.changePageWithSegmentValue(index: 0)
        self.currentViewController?.view.updateConstraintsIfNeeded()
        self.currentViewController?.view.layoutIfNeeded()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //self.currentViewController?.view.updateConstraintsIfNeeded()
        //self.currentViewController?.view.layoutIfNeeded()
        self.topView?.isHidden = false
        lblTitle?.text =  NSLocalizedString("weather_report", comment: "") //"Weather Report"
        self.isFromHome = (UserDefaults.standard.value(forKey: "isFromHome") as? Bool)!
        if isFromHome == false {
            self.backButton?.setImage(UIImage(named: "Menu"), for: .normal)
        }else {
             self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        }
    }
    
    override func backButtonClick(_ sender: UIButton) {
        if isFromHome == true {
            self.navigationController?.popViewController(animated: true)
        }
        else{
            self.findHamburguerViewController()?.showMenuViewController()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //self.currentViewController?.view.updateConstraintsIfNeeded()
        //self.currentViewController?.view.layoutIfNeeded()
    }
    
    @IBAction func segmentChangeValue(sender: UISegmentedControl){
        self.changePageWithSegmentValue(index: sender.selectedSegmentIndex)
    }
    
    func changePageWithSegmentValue(index: Int){
        let storyBoardIdentifier = controllersArray[index]
        if storyBoardIdentifier == currentViewController?.restorationIdentifier {
            return
        }
        currentViewController = self.instanciateViewControllerWithIdentifier(storyBoardIdentifier)
        currentViewController?.viewWillAppear(true)
         self.isFromHome = (UserDefaults.standard.value(forKey: "isFromHome") as? Bool)!
      if self.isFromHome == false {
                            self.backButton?.setImage(UIImage(named: "Menu"), for: .normal)
                        }else {
                             self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
                        }
        if let controller = childViewControllers.last{
            oldController = controller
            oldController!.willMove(toParentViewController: nil)
            oldController!.view.removeFromSuperview()
            oldController!.removeFromParentViewController()
        }
        self.addChildViewController(currentViewController!)
        self.containerView!.addSubview((currentViewController?.view)!)
        self.currentViewController!.didMove(toParentViewController: self)
           if self.isFromHome == false {
                                 self.backButton?.setImage(UIImage(named: "Menu"), for: .normal)
                             }else {
                                  self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
                             }
        
        
    }
    
    func instanciateViewControllerWithIdentifier(_ identifier: String) -> UIViewController {
        //If we have a storyboard created
        let storyBoard = UIStoryboard(name: "Main", bundle: nil) as UIStoryboard?
        if storyBoard != nil{
            var currentViewController : UIViewController?
            for viewController in viewContriollersArray! {
                if let tempViewController = viewController as? UIViewController{
                    let storyBoardid = tempViewController.restorationIdentifier
                    if storyBoardid == identifier {
                        currentViewController = viewController as? UIViewController
                    }
                }
            }
            if currentViewController == nil{
                currentViewController = storyBoard?.instantiateViewController(withIdentifier: identifier)
                if viewContriollersArray!.contains(currentViewController!) == false{
                    viewContriollersArray!.add(currentViewController!)
                }
            }
             return currentViewController!
        }
       
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
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
