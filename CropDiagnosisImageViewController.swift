//
//  CropDiagnosisImageViewController.swift
//  PioneerEmployee
//
//  Created by Empover on 26/02/18.
//  Copyright © 2018 Empover. All rights reserved.
//

import UIKit

class CropDiagnosisImageViewController: BaseViewController,UIScrollViewDelegate {

    @IBOutlet var btnClose : UIButton?
    var CDImageView : UIImageView = UIImageView()
    var scrollView : UIScrollView = UIScrollView()
    var CDImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if CDImage != nil {
            self.CDImageView.image = CDImage
        }
        else{
            self.dismiss(animated: true, completion: nil)
        }
        scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
        self.view.addSubview(scrollView)
        CDImageView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        CDImageView.contentMode = .scaleAspectFit
        CDImageView.backgroundColor = UIColor.black.withAlphaComponent(0.44)
        scrollView.addSubview(CDImageView)
        self.view.bringSubview(toFront: btnClose!)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.topView?.isHidden = true
    }
    
    @IBAction func closeImagePreviewButtonClick(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return CDImageView
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
