//
//  FABAudioViewController.swift
//  PioneerEmployee
//
//  Created by Empover on 06/10/17.
//  Copyright © 2017 Empover. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Alamofire

class FABAudioViewController: UIViewController {

    @IBOutlet weak var playPauseBtn: UIButton!
    
    @IBOutlet weak var progressSlider: UISlider!
    
    var audioTimer: Timer?
    
    var isDraggingTimeSlider = false
    var isPlaying = false
    
    var audioPlayer : AudioPlayer?

    var playerItem:AVPlayerItem?
    var player:AVPlayer?
    
    var targetTime:CMTime = CMTimeMake(0, 1)
    
    var fabDocumentsDirectory = NSString()
    
    var assetDictFromFABDetailsVC : NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        fabDocumentsDirectory = appDelegate.getFABFolderPath() as NSString
        //print(fabDocumentsDirectory)
        progressSlider.value = 0.0
        progressSlider.tintColor = UIColor.red
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        player = nil
    }
    
    //MARK: getDocumentPath
    func getDocumentPath(_ assetStr: NSString) -> NSString {
        let assetArray = assetStr.components(separatedBy: "/") as NSArray
        let filePath = String(format: "%@/%@", fabDocumentsDirectory,assetArray.lastObject as! NSString) as NSString
        return filePath
    }
    
    //MARK: checkIfFileExists
    func checkIfFileExists(atPath strPath: String) -> Bool {
        let fileExists: Bool = FileManager.default.fileExists(atPath: strPath)
        return fileExists
    }

     @IBAction func playPauseBtn(_ sender: Any) {
        let docPath = self.getDocumentPath(assetDictFromFABDetailsVC?.value(forKey: "voiceFile") as! NSString)
        let isFileExists = self.checkIfFileExists(atPath: docPath as String)
        if isFileExists == true && player == nil {
            let url = NSURL(fileURLWithPath: docPath as String)
            playerItem = AVPlayerItem(url: url as URL)
            player=AVPlayer(playerItem: playerItem!)
            //progressSlider.maximumValue = 1.0 //Float(CMTimeGetSeconds((player?.currentItem?.asset.duration)!))
            let duration : CMTime = (player?.currentItem?.asset.duration)!
            let seconds : Float64 = CMTimeGetSeconds(duration)
            progressSlider.maximumValue = Float(seconds)
            progressSlider.isContinuous = true
            NotificationCenter.default.addObserver(self, selector: #selector(FABAudioViewController.playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        }
        else{
            if Reachability.isConnectedToNetwork() && player == nil{
                let urlStr = NSURL(string: self.assetDictFromFABDetailsVC?.value(forKey: "voiceFile") as! String)
                self.playerItem = AVPlayerItem(url: urlStr! as URL)
                self.player=AVPlayer(playerItem: self.playerItem!)
                let duration : CMTime = (self.player?.currentItem?.asset.duration)!
                let seconds : Float64 = CMTimeGetSeconds(duration)
                self.progressSlider.maximumValue = Float(seconds)
                self.progressSlider.isContinuous = true
                NotificationCenter.default.addObserver(self, selector: #selector(FABAudioViewController.playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
                DispatchQueue.global().async {
                    self.downloadAssetAndStore(inDocumentsDirectory: self.assetDictFromFABDetailsVC?.value(forKey: "voiceFile") as! NSString)
                }
            }
        }
        
        if player?.rate == 0
        {
            if audioTimer != nil {
                audioTimer!.invalidate()
            }
            audioTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(FABAudioViewController.onTimer(_:)), userInfo: nil, repeats: true)
            isPlaying = true
            if targetTime.value != 0 {
                player!.seek(to: targetTime)
            }
            player?.play()
            playPauseBtn.setBackgroundImage(UIImage(named:"VideoPauseIcon"),for: .normal)//PauseSmall
        }
        else {
            player?.pause()
            isPlaying = false
            playPauseBtn.setBackgroundImage(UIImage(named:"VideoIcon"),for: .normal)//PlaySmall
        }
    }
    
    //MARK: Notification observer method
    @objc func playerDidFinishPlaying() {
        if progressSlider.maximumValue == progressSlider.value{
        player = nil
        targetTime = CMTimeMake(0, 1)
        playPauseBtn.setBackgroundImage(UIImage(named:"VideoIcon"),for: .normal)
        }
    }
    
    @objc func onTimer(_ timer: Timer) {
        // Check the audioPlayer. Get the current time and duration
        guard let _ = player?.currentItem?.currentTime(), let _ = player?.currentItem?.asset.duration else {
                        return
                    }
        
        let currentTimeInSeconds = CMTimeGetSeconds((player?.currentTime())!)
        let mins = currentTimeInSeconds / 60
        let secs = currentTimeInSeconds.truncatingRemainder(dividingBy: 60)
        let timeformatter = NumberFormatter()
        timeformatter.minimumIntegerDigits = 2
        timeformatter.minimumFractionDigits = 0
        timeformatter.roundingMode = .down
        guard let _ = timeformatter.string(from: NSNumber(value: mins)), let _ = timeformatter.string(from: NSNumber(value: secs)) else {
            return
        }
        if !isDraggingTimeSlider {
        progressSlider.value = Float(currentTimeInSeconds)
            targetTime.value = CMTimeValue(Int(progressSlider.value))

            if progressSlider.maximumValue == progressSlider.value{
            self.playerDidFinishPlaying()
            }
        }
    }

    @IBAction func progressSlider_Value_Changed_Action(_ sender: UISlider) {
        if player != nil{
            let seconds : Int64 = Int64(progressSlider.value)
            targetTime = CMTimeMake(seconds, 1)
            player!.seek(to: targetTime)
        }
        else{
            let seconds : Int64 = Int64(progressSlider.value)
            targetTime = CMTimeMake(seconds, 1)
        }
    }
    
    @IBAction func progressSliderTouchDown(_ sender: UISlider) {
        isDraggingTimeSlider = true
    }
    
    @IBAction func progressSliderTouchUpInside(_ sender: UISlider) {
        isDraggingTimeSlider = false
    }
    
    @IBAction func progressSliderTouchUpOutside(_ sender: UISlider) {
        isDraggingTimeSlider = false
    }

    //MARK: downloadAssetAndStore
    func downloadAssetAndStore(inDocumentsDirectory assetStr: NSString) {
        let docPath = self.getDocumentPath(assetStr)
//        DispatchQueue.global().async {
//            
//            let urlToDownload = assetStr as String
//            print("download started :\(urlToDownload)")
//            
//            let url = NSURL(string: urlToDownload)
//            
//            print("url :\(url!)")
//            
//            DispatchQueue.main.async {
//                do {
//                    let dataObj = NSData(contentsOf: (url!) as URL)
//                    
//                    dataObj?.write(toFile: docPath as String, atomically: true)
//                }
//                print("file saved")
//            }
//        }
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let url = NSURL(fileURLWithPath: docPath as String)
            return (url as URL, [.removePreviousFile])
        }
        Alamofire.download(assetStr as String, to: destination).response { response in
           //SwiftLoader.hide()
            if response.destinationURL != nil {
                print(response.destinationURL!)
                print("audio file saved when clicked")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeBtn_Touch_Up_Inside(_ sender: Any) {
        player = nil
        dismiss(animated: true, completion: nil)
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
