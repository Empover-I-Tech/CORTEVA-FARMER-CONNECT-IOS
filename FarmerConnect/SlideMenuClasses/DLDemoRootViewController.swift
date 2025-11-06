
//
//  DLDemoRootViewController.swift
//  DLHamburguerMenu
//
//  Created by Nacho on 5/3/15.
//  Copyright (c) 2015 Ignacio Nieto Carvajal. All rights reserved.
//

import UIKit

class DLDemoRootViewController: DLHamburguerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func awakeFromNib() {
        self.contentViewController = self.storyboard?.instantiateViewController(withIdentifier: "NavigationViewController")
        self.menuViewController = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuViewController")
        
          let isLogin = UserDefaults.standard.value(forKey: "login") as? Bool
            
            if isLogin == true && isLogin != nil{
                
                if let hamburguerViewController =  self.contentViewController{
                    let navController  = hamburguerViewController as? UINavigationController
                    
                    if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController{
                        navController!.viewControllers = [viewController]
                        
                        if let hamburguerViewController = self.findHamburguerViewController() {
                            hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in

                                hamburguerViewController.contentViewController = navController
                            })
                        }
                    }
                }
            }
         else{
            let isShown = UserDefaults.standard.value(forKey: "isWalkThruShown") as? Bool
            
            if isShown == false || isShown == nil{
                
                if let hamburguerViewController =  self.contentViewController{
                    let navController  = hamburguerViewController as? UINavigationController
                    
                    if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as? PageContentViewController{
                        navController!.viewControllers = [viewController]
                        
                        if let hamburguerViewController = self.findHamburguerViewController() {
                            hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
                                
                                hamburguerViewController.contentViewController = navController
                            })
                        }
                    }
                }
            }
        }


    }
}
