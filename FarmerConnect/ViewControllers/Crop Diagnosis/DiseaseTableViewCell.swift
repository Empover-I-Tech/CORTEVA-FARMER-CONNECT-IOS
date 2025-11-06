//
//  DiseaseTableViewCell.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 26/12/19.
//  Copyright © 2019 ABC. All rights reserved.
//

import UIKit

class DiseaseTableViewCell: UITableViewCell {

    @IBOutlet weak var btn_percentage: UIButton!
    @IBOutlet weak var lbl_DiseaseSubmittedDate: UILabel!
    @IBOutlet weak var lbl_diseaseNAme: UILabel!
    @IBOutlet weak var lbl_scientificName: UILabel!
    @IBOutlet weak var img_diesease: UIImageView!
    @IBOutlet weak var progressView: BRCircularProgressView!
    var totalTimeInSec : Double = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setProgressView(_ Percentage : String){
              progressView.backgroundColor = UIColor.clear
              progressView.setProgressText("\(Percentage)")
              
              totalTimeInSec = 100
              
              progressView.setCircleStrokeWidth(5)
              progressView.setProgressTextFont()
        progressView.setCircleStrokeColor(App_Theme_Blue_Color, circleFillColor: App_Theme_Blue_Color, progressCircleStrokeColor: App_Theme_Blue_Color, progressCircleFillColor: App_Theme_Blue_Color)
             
        let strPer = Percentage.replacingOccurrences(of: "%", with: "")
        progressView.progress = CGFloat(totalTimeInSec / (Double(strPer) ?? 100) )
        
        print(progressView.progress)
          }
}
