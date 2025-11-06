//
//  DiseaseCell.swift
//  Sample
//
//  Created by Santosh on 26/12/19.
//  Copyright © 2019 Santosh. All rights reserved.
//

import UIKit

class DiseaseCell: UITableViewCell {
    var timer: Timer?
    var currentMinute: Int?
    var currentSecond: Int?
    
    var totalTimeInSec: CGFloat?
    
    var count : CGFloat = 0
    
    var countdownTimer: Timer!
    var totalTime = 30
    @IBOutlet weak var btn_ImagesCount: UIButton!
    @IBOutlet weak var imgCropType: UIImageView!
    @IBOutlet weak var lbl_DiseaseSubmittedDate: UILabel!
    @IBOutlet weak var lbl_diseaseNAme: UILabel!
    @IBOutlet weak var lbl_scientificName: UILabel!
    @IBOutlet weak var img_diesease: UIImageView!
    @IBOutlet weak var viewDisease: UIView!
    @IBOutlet weak var progressView: CircularProgressBar!
     @IBOutlet weak var progressLbl: BRCircularProgressView!
    
    @IBOutlet weak var imgDisease: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      //  self.viewDisease.roundCorners(corners: [.topLeft], radius: 10)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
        func setProgressView(_ Percentage : String){
           progressLbl.setCircleStrokeWidth(0)
           progressLbl.backgroundColor = UIColor.clear
           progressLbl.setCircleStrokeColor(UIColor.clear, circleFillColor: UIColor.clear, progressCircleStrokeColor: UIColor.clear, progressCircleFillColor: UIColor.clear)
           progressLbl.setProgressTextFont()
    
           
           progressLbl.setProgressText("\(Percentage)")
           progressView.lineColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.5)
           progressView.lineFinishColor = .blue
           progressView.lineBackgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.5)
           
           progressView.labelSize = 0
           
           let strPer = Percentage.replacingOccurrences(of: "%", with: "")

           let progressVlaue =    CGFloat(Double(strPer) ?? 0.0) / CGFloat(100 )
    
           progressView.setProgress(to: Double(progressVlaue), withAnimation: true)
           progressView.safePercent = Int(progressVlaue)
           
       }
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
            
            
        }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
    }
    
    
    
    //MARK: timerAction
    /**
     Used to calculate the timer value
     */
    @objc func timerAction(){
       
       
//            self.progressView.progress = count/totalTimeInSec!
           
                timer?.invalidate()
         
        
    }
    
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
