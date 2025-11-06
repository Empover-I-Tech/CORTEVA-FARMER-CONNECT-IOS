//
//  CropDetailsPhaseViewController.swift
//  CropAdvisoryFramework
//
//  Created by Apple on 04/12/19.
//  Copyright © 2019 Empover iTech Pvt Ltd. All rights reserved.
//

import UIKit
import AVKit
import CoreAudio
import Alamofire
import Foundation

//import KDEAudioPlayer


open class CropDetailsPhaseViewController: BaseViewController,AudioPlayerDelegate  {
   
    
   // let delegate: AudioPlayerDelegate =  AudioPlayerDelegate()
        var isFromSideMenu = false
        var SelectedCropString = "Corn PS3456"
        @IBOutlet weak var lblNoDataAvailable: UILabel!
        @IBOutlet weak var lblDisplayDate: UILabel!
        
        @IBOutlet weak var lblStage: UILabel!
        @IBOutlet weak var cropDetailTableView: UITableView!
        @IBOutlet weak var lbl_prevPhaseDays: UILabel!
        @IBOutlet weak var img_prevPhase: UIImageView!
        @IBOutlet weak var lbl_prevPhaseTitle: UILabel!
        @IBOutlet weak var btnNext: UIButton!
        @IBOutlet weak var lblMessageOtherLang: UILabel!
        @IBOutlet weak var lblMessageEnglish: UILabel!
        @IBOutlet weak var lblExpectedDate: UILabel!
        @IBOutlet weak var btnPrevious: UIButton!
        @IBOutlet weak var view_previous: UIView!
        @IBOutlet weak var view_next: UIView!
        @IBOutlet weak var playOrangeBtn: UIButton!
        @IBOutlet weak var img_nextPhase: UIImageView!
       
        
        @IBOutlet weak var lbl_nextPhaseDays: UILabel!
        @IBOutlet weak var lbl_nextPhaseTitle: UILabel!
        var topLabel = UILabel()
        var arrayFromCropNotifVC = NSArray()
        var navBarTitleStr = ""
        var mutArrayToDisplay = NSMutableArray()
        var csStageSelectedStr = ""
        var selectedindex = 0
        var cropAdvisoryDocumentsDirectory = NSString()
        
        /// used third party library AudioPlayer to play the audio files
        var audioPlayer : AudioPlayer?
        
        var isPlaying = false
        var selectedStageEnt : GrowthCASubPhasesDetailBO?
        var selectedNotification : CropAdvisoryNotifications?
        var currentIndexPath : NSIndexPath?
        var DetailsFromPrevousScrenArray = NSMutableArray()
        var selectedSubscriptionArray = NSMutableArray()
        var isFromSubscriptionList = false
        var profileButton = UIButton(frame: CGRect(x:0,y: 0,width: 100,height: 50))
        let profileImage = UIImageView(frame: CGRect(x:50,y: 5,width: 40,height: 40))
        var playIndex = Int()
        var userObj : NSMutableDictionary!
    
    var cropName : String = ""
    var stageID : String = ""
    var  cropID : String = ""
      var  cropType : String = ""
    var cropPhaseID : String = ""
    
        
        //MARK:- VIEW DID LOAD
        override open func viewDidLoad() {
            super.viewDidLoad()
          //  let appDelegate = UIApplication.shared.delegate as! AppDelegate
            cropAdvisoryDocumentsDirectory =  "" //appDelegate.getCropAdvisoryFolderPath() as NSString
         
            // lblNoDataAvailable.isHidden = true
//    CoreDataManager.shared.addLogEvent(UserID: self.userObj.value(forKey: "customerId")  as? String ?? "", mobileNumber: self.userObj.value(forKey: "mobileNumber")  as? String ?? "", screenName: "CropDetailsPhaseViewController", eventName: "CropDetails_Load", eventType: "PageLoad",captureTime:self.getCurrentDateAndTime(), currentLocation: "0.0,0.0", moduleType: "CropAdvisory")
            
            let parameters  = ["capturedtime" : self.getCurrentDateAndTime() , "currentLocation" :  self.userObj.value(forKey: "geoLocation")  as? String ?? "" ,"eventName" :  "CropDetails_Load" , "moduleType" : "CropAdvisory","deviceType" : "iOS" , "Mobile_Number" : self.userObj.value(forKey: "mobileNumber")  as? String ?? "" ,"screen_name" :  "CropDetailsPhaseViewController" , "User_Id" :  self.userObj.value(forKey: "customerId")  as? String ?? ""]
                                                                                                                                                     
            self.registerFirebaseEvents("CropDetails_Load", "", "", "CropDetailsPhaseViewController", parameters: parameters as NSDictionary)
            
            
          //  self.registerFirebaseEvents(PV_CA_Notifications_Screen, "", "", "", parameters: nil)
            
            if mutArrayToDisplay.count == 0{
                cropDetailTableView.isHidden = true
            }else{
                
                if self.selectedindex >= 0{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
                        let nextItem: IndexPath = IndexPath(item: self.selectedindex, section: 0)
                        self.cropDetailTableView.scrollToRow(at: nextItem, at: .top, animated: false)
                        let dicObj : GrowthCASubPhasesDetailBO = self.mutArrayToDisplay.object(at: nextItem.row) as! GrowthCASubPhasesDetailBO
                        self.cropName = dicObj.cropName as String? ?? ""
                        self.stageID = dicObj.caStageId as String? ?? ""
                    }
                }
            }
            
            
        }
        
        @IBAction func shareAction(_ sender: UIButton){
            
//            CoreDataManager.shared.addSubscriptionShareLogEvent(UserID: self.userObj.value(forKey: "customerId")  as? String ?? "", mobileNumber: self.userObj.value(forKey: "mobileNumber")  as? String ?? "", screenName: "CropDetailsPhaseViewController", eventName: "CA_Share", eventType: "Share Click",captureTime:self.getCurrentDateAndTime(), currentLocation: "0.0,0.0", moduleType: "CropAdvisory", caStageId: self.selectedNotification?.stateId as String? ?? "" as String, cropTypeId: self.selectedNotification?.cropId as String? ?? "" , cropPhaseId: "0")
            
            let parameters  = ["capturedtime" : self.getCurrentDateAndTime() , "currentLocation" :  self.userObj.value(forKey: "geoLocation")  as? String ?? "" ,"eventName" :  "CA_Share" , "moduleType" : "CropAdvisory","deviceType" : "iOS" , "Mobile_Number" : self.userObj.value(forKey: "mobileNumber")  as? String ?? "" ,"screen_name" :  "CropDetailsPhaseViewController" , "User_Id" :  self.userObj.value(forKey: "customerId")  as? String ?? "" , "cropName": self.cropName , "caStageId" : csStageSelectedStr  , "cropTypeId": cropID ,"cropPhaseId": cropPhaseID] as [String : Any]
                                                   
         self.registerFirebaseEvents("CA_Share", "", "", "CropDetailsPhaseViewController", parameters: parameters as NSDictionary)
            
  
            let urlPath = String(format: "%@=%@&%@=%@&%@=%@&%@=%@&%@=%@", Module,"cropDetails",Crop_Id, self.cropID,cropTypeId,cropType,cropPhaseId,"0",stageId,csStageSelectedStr)
            let finalUrl = String(format: "%@%@", deepLinkBaseUrl,urlPath)
            print(finalUrl)
            let message = String(format: "Crop Staging Details")
            let activityControl = Validations.showShareActivityController(viewController: self, fileUrl: URL(string: finalUrl)!, userName: "", message: message)
            
            self.present(activityControl, animated: true, completion: nil)
            
        }
        
        
        //MARK:- BACK ACTION
        @IBAction func backAction(_ sender: Any) {
                  let appDelegate = UIApplication.shared.delegate as! AppDelegate
                   appDelegate.myOrientation = .portrait
            self.navigationController?.popViewController(animated: false)
            if isFromSideMenu == true{
                self.navigationController?.popViewController(animated: true)
            }
            else{
                self.navigationController?.popViewController(animated: true)
            }
        }
    override open func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            UIApplication.shared.isStatusBarHidden = false
            
        }
        
    override open var prefersStatusBarHidden: Bool {
            return true
        }
        
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return .landscape
        }
        
    override open func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.topView?.isHidden = false
        
        
        let defaults = UserDefaults.standard
        //defaults.set(decryptData , forKey: "OTPResponseData")
        defaults.set(true, forKey: "Landscape")
        defaults.synchronize()
            
            
            UIApplication.shared.isStatusBarHidden = true
            
            if self.view.frame.width < self.view.frame.height{
                let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
                self.topView?.frame = frame
            }
            print(self.view.frame)
            self.lblTitle?.text = ""//SelectedCropString
            self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
            profileImage.layer.cornerRadius = profileImage.frame.size.height/2
            profileImage.layer.masksToBounds = true
            
            profileImage.backgroundColor =  UIColor.clear
            profileImage.image = UIImage(named: "image_placeholder.png")
            // profileImage.setImage( UIImage(named: "image_placeholder.png"), for: UIControlState())
        profileButton.addTarget(self, action: #selector(CropDetailsPhaseViewController.backAction(_:)), for: UIControl.Event.touchUpInside)
            self.topView?.addSubview(profileImage)
            
            
            profileButton.backgroundColor =  UIColor.clear
            // profileButton.setImage( UIImage(named: "subscribeHand"), for: UIControlState())
            //shareButton.addTarget(self, action: #selector(SubscriptionGrowthDurationViewController.addSubscriptionAction(_:)), for: UIControlEvents.touchUpInside)
            self.topView?.addSubview(profileButton)
            
            topLabel.frame =  CGRect(x:profileButton.frame.maxX ,y: 0,width: 200,height: 50)
            topLabel.text = SelectedCropString
            topLabel.textColor = UIColor.white
            topLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
            self.topView?.addSubview(topLabel)
            
            
            let shareButton = UIButton(frame: CGRect(x:UIScreen.main.bounds.size.width-42,y: 6,width: 40,height: 40))
            shareButton.backgroundColor =  UIColor.clear
        shareButton.setImage( UIImage(named: "Share"), for: UIControl.State())
        shareButton.addTarget(self, action: #selector(CropDetailsPhaseViewController.shareAction(_:)), for: UIControl.Event.touchUpInside)
            self.topView?.addSubview(shareButton)
        }
        
        @objc func forcelandscapeLeft() {
            if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft{
                let value = UIInterfaceOrientation.landscapeLeft.rawValue
                UIDevice.current.setValue(value, forKey: "orientation")
                
            }
            else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight{
                let value = UIInterfaceOrientation.landscapeRight.rawValue
                UIDevice.current.setValue(value, forKey: "orientation")
            }
            else{
                let value = UIInterfaceOrientation.landscapeLeft.rawValue
                UIDevice.current.setValue(value, forKey: "orientation")
            }
            
            if self.topView?.frame.width ?? 0 < self.view.frame.height{
                let frame = CGRect(x: 0, y: 0, width: self.view.frame.height, height: 50)
                self.topView?.frame = frame
                
                
                let shareButton = UIButton(frame: CGRect(x:UIScreen.main.bounds.size.width-60,y: 0,width: 50,height: 50))
                shareButton.backgroundColor =  UIColor.clear
                shareButton.setImage( UIImage(named: "subscribeHand"), for: UIControl.State())
                shareButton.addTarget(self, action: #selector(SubscriptionGrowthDurationViewController.addSubscriptionAction(_:)), for: UIControl.Event.touchUpInside)
                //  self.topView?.addSubview(shareButton)
            }
        }
        
        @objc func forceOrientationPortrait() {
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.myOrientation = .portrait
            
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
        
        
        //MARK: checkVoiceFileAvailable
        func checkVoiceFileAvailable(URLStr: String) -> NSURL{
            var url = NSURL()
            if Validations.validateUrl(urlString: URLStr as NSString) == false{
                let docPath = self.getDocumentPath(URLStr as NSString)
                let isFileExists = self.checkIfFileExists(atPath: docPath as String)
                if isFileExists == true {
                    let imgURL = NSURL(fileURLWithPath: docPath as String)
                    url = NSURL(string:imgURL.absoluteString!)!
                    return url
                }
                else{
                    if Reachability.isConnectedToNetwork() {
                        let voiceURL =  NSURL(string: URLStr)
                        url = NSURL(string:(voiceURL?.absoluteString!)!)!
                        DispatchQueue.global().async {
                            self.downloadAssetAndStore(inDocumentsDirectory: URLStr as NSString)
                        }
                        return url
                    }
                    else{
                        self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
                    }
                }
            }
            return url
        }
        
        //MARK: getDocumentPath
        func getDocumentPath(_ assetStr: NSString) -> NSString {
            let assetArray = assetStr.components(separatedBy: "/") as NSArray
            let filePath = String(format: "%@/%@", cropAdvisoryDocumentsDirectory,assetArray.lastObject as! NSString) as NSString
            return filePath
        }
        
        //MARK: downloadAssetAndStore
        func downloadAssetAndStore(inDocumentsDirectory assetStr: NSString) {
            SwiftLoader.show(animated: true)
            let docPath = self.getDocumentPath(assetStr)
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                let url = NSURL(fileURLWithPath: docPath as String)
                return (url as URL, [.removePreviousFile])
            }
            Alamofire.download(assetStr as String, to: destination).response { response in
                if response.destinationURL != nil {
                    SwiftLoader.hide()
                    print(response.destinationURL!)
                    print("disease image file saved when clicked")
                }
            }
        }
        
        //MARK: checkIfFileExists
        func checkIfFileExists(atPath strPath: String) -> Bool {
            let fileExists: Bool = FileManager.default.fileExists(atPath: strPath)
            return fileExists
        }
        
        
        //MARK: PlayPause Button
        @objc func playPauseBtn (sender : UIButton){
            self.playIndex = sender.tag
            let buttonPosition = sender.convert(CGPoint(x:0,y:0), to: cropDetailTableView)
            let indexPath = self.cropDetailTableView!.indexPathForRow(at: buttonPosition)
            if indexPath != nil {
                if let cropStageEnt = mutArrayToDisplay.object(at: (indexPath?.row)!) as? GrowthCASubPhasesDetailBO{
                    if selectedStageEnt != nil {
                        if (cropStageEnt.isEqual(selectedStageEnt)) {
                            currentIndexPath = indexPath as NSIndexPath?
                            
                            var filePath = NSString()
                            
                            filePath = self.getDocumentPath(cropStageEnt.voiceFileName ?? "")
                            let isFileExists = self.checkIfFileExists(atPath: filePath as String)
                            if isFileExists == true {
                                self.audioPlayerInitializationAndControl(stagesEnt: cropStageEnt, indexPath: indexPath! , playBtn: sender, filePath: filePath as String)
                                
                            }
                            else{
                                self.audioPlayerInitializationAndControl(stagesEnt: cropStageEnt, indexPath: indexPath! , playBtn: sender, filePath: cropStageEnt.voiceFileName as String? ?? "" as String)
                            }
                        }
                        else{
                            selectedStageEnt?.isPlaying = false
                            if currentIndexPath != nil {
                                if audioPlayer != nil{
                                    audioPlayer?.stop()
                                }
                                UIView.setAnimationsEnabled(false)
                                UIView.performWithoutAnimation {
                                    //let loc = self.cropAdvisoryDetailsTblView.contentOffset
                                    cropDetailTableView.reloadRows(at: [currentIndexPath! as IndexPath], with: .none)
                                    // self.cropAdvisoryDetailsTblView.contentOffset = loc
                                }
                            }
                            currentIndexPath = indexPath as NSIndexPath?
                            var filePath = NSString()
                            
                            filePath = self.getDocumentPath(cropStageEnt.voiceFileName ?? "")
                            let isFileExists = self.checkIfFileExists(atPath: filePath as String)
                            if isFileExists == true {
                                self.audioPlayerInitializationAndControl(stagesEnt: cropStageEnt, indexPath: indexPath!, playBtn: sender, filePath: filePath as String)
                                
                            }
                            else{
                                self.audioPlayerInitializationAndControl(stagesEnt: cropStageEnt, indexPath: indexPath!, playBtn: sender, filePath: cropStageEnt.voiceFileName as String? ?? "" as String )
                            }
                        }
                    }
                    else{
                        currentIndexPath = indexPath as NSIndexPath?
                        selectedStageEnt = cropStageEnt
                        var filePath = NSString()
                        
                        filePath = self.getDocumentPath(cropStageEnt.voiceFileName ?? "")
                        let isFileExists = self.checkIfFileExists(atPath: filePath as? NSString as String? ?? "" as String)
                        if isFileExists == true {
                            self.audioPlayerInitializationAndControl(stagesEnt: cropStageEnt, indexPath: indexPath!, playBtn: sender, filePath: filePath as String)
                            
                        }
                        else{
                            self.audioPlayerInitializationAndControl(stagesEnt: cropStageEnt, indexPath: indexPath! , playBtn: sender, filePath: cropStageEnt.voiceFileName as String? ?? "" as String )
                        }
                    }
                }
            }
        }
        
        // FIXME: test fix me
        //MARK: audioPlayerInitializationAndControl
        func audioPlayerInitializationAndControl(stagesEnt: GrowthCASubPhasesDetailBO, indexPath: IndexPath ,playBtn:UIButton, filePath : String){
            if audioPlayer != nil{
                if (selectedStageEnt!.isEqual(stagesEnt)) {
                    if audioPlayer?.state.isPlaying == true {
                        audioPlayer?.pause()
                        selectedStageEnt?.isPlaying = false
                    }
                    else{
                        selectedStageEnt?.isPlaying = true
                        audioPlayer?.resume()
                        //audioPlayer?.play()
                    }
                    if indexPath != nil {
                        //cropAdvisoryDetailsTblView.reloadRows(at: [indexPath! as IndexPath], with:.fade)
                    }
                    return
                }
                if audioPlayer != nil {
                    audioPlayer?.stop()
                    audioPlayer = nil
                    if selectedStageEnt != nil{
                        selectedStageEnt?.isPlaying = false
                    }
                }
                do {
                    audioPlayer = AudioPlayer()
                    audioPlayer?.delegate = self
                    
                    let audioUrl : URL?
                    if filePath.hasPrefix("http") || filePath.hasPrefix("https"){
                        audioUrl = URL(string: filePath)
                    }
                    else{
                        audioUrl = URL(fileURLWithPath: filePath)
                    }
                    let item = AudioItem(mediumQualitySoundURL: audioUrl as URL?)
                    self.audioPlayer?.play(item: item!)
                    stagesEnt.isPlaying = true
                    
                }
                //            catch let error as NSError {
                //                print("Error: ", error.localizedDescription)
                //            }
            }
            else{
                
                if audioPlayer != nil {
                    audioPlayer?.stop()
                    audioPlayer = nil
                }
                do {
                    audioPlayer = AudioPlayer()
                    audioPlayer?.delegate = self
                    let audioUrl : URL?
                    if filePath.hasPrefix("http") || filePath.hasPrefix("https"){
                        audioUrl = URL(string: filePath)
                    }
                    else{
                        audioUrl = URL(fileURLWithPath: filePath)
                    }
                    let item = AudioItem(mediumQualitySoundURL: audioUrl as URL?)
                    
                    self.audioPlayer?.play(item: item!)
                    stagesEnt.isPlaying = true
                   
                  
                }
                //            catch let error as NSError {
                //                print("Error: ", error.localizedDescription)
                //            }
            }
            selectedStageEnt = stagesEnt
            if indexPath != nil {
                //cropAdvisoryDetailsTblView.reloadRows(at: [indexPath! as IndexPath], with: .fade)
            }
            
        }
        
        //MARK: AudioPlayer Delegate Methods
    public func audioPlayer(_ audioPlayer: AudioPlayer, didChangeStateFrom from: AudioPlayerState, to state: AudioPlayerState){
            switch state {
            case .buffering:
                //btnPlay?.setImage(UIImage(named:"Pause"), for: .normal)
                break
            case .playing:
                if audioPlayer == self.audioPlayer {
                    if selectedStageEnt != nil {
                        selectedStageEnt?.isPlaying = true
                    }
                }
                else{
                }
                break
            case .paused:
                if audioPlayer == self.audioPlayer {
                    if selectedStageEnt != nil {
                        selectedStageEnt?.isPlaying = false
                    }
                }
                else{
                }
                break
            case .stopped:
                if audioPlayer == self.audioPlayer {
                    if selectedStageEnt != nil {
                        selectedStageEnt?.isPlaying = false
                    }
                    self.audioPlayer?.stop()
                    self.selectedStageEnt = nil
                    self.audioPlayer = nil
                    if currentIndexPath != nil {
                        
                        // cropAdvisoryDetailsTblView.reloadRows(at: [currentIndexPath! as IndexPath], with: .none)
                    }
                }
                else{
                }
                break
            case .waitingForConnection:
                break
            case .failed(AudioPlayerError.maximumRetryCountHit):
                //print("Player error \(error.lo)")
                // self.view.makeToast[(Story_Download_Fail_Message)
                if audioPlayer == self.audioPlayer {
                    if selectedStageEnt != nil {
                        selectedStageEnt?.isPlaying = false
                    }
                    self.audioPlayer?.stop()
                    self.selectedStageEnt = nil
                    self.audioPlayer = nil
                    if currentIndexPath != nil {
                        //cropAdvisoryDetailsTblView.reloadRows(at: [currentIndexPath! as IndexPath], with: .none)
                    }
                }
                else{
                }
                break
            case .failed(AudioPlayerError.foundationError):
                //let error = AudioPlayerError.foundationError as! (Error)
                // print("Player error \(AudioPlayerError.foundationError)")
                // self.view.makeToast(Story_Download_Fail_Message)
                if audioPlayer == self.audioPlayer {
                    if selectedStageEnt != nil {
                        selectedStageEnt?.isPlaying = false
                    }
                    self.audioPlayer?.stop()
                    self.selectedStageEnt = nil
                    self.audioPlayer = nil
                    if currentIndexPath != nil {
                        // cropAdvisoryDetailsTblView.reloadRows(at: [currentIndexPath! as IndexPath], with: .none)
                    }
                }
                else{
                }
                break
                /*default:
                 btnPlay?.setImage(UIImage(named:"Play"), for: .normal)
                 break*/
            }
            if currentIndexPath != nil {
                DispatchQueue.main.async {
                    UIView.setAnimationsEnabled(false)
                    UIView.performWithoutAnimation {
                        self.cropDetailTableView.reloadRows(at: [self.currentIndexPath! as IndexPath], with: .none)
                    }
                }
            }
        }
    public func audioPlayer(_ audioPlayer: AudioPlayer, willStartPlaying item: AudioItem) {
       if playIndex != nil {
              let index = IndexPath(row: playIndex, section: 0)
            let cell =  self.cropDetailTableView.cellForRow(at: index ) as? CropSubscribscriptionDetailsCellTableViewCell
//          if (audioPlayer.player?.currentItem?.currentTime().seconds) != nil {
              let item =  (audioPlayer.player?.currentItem?.duration.seconds)!

                      
          }
        }
    
    public func audioPlayer(_ audioPlayer: AudioPlayer, didUpdateProgressionTo time: TimeInterval, percentageRead: Float) {
        
        if playIndex != nil {
            let index = IndexPath(row: playIndex, section: 0)
            let cell =  self.cropDetailTableView.cellForRow(at:index ) as? CropSubscribscriptionDetailsCellTableViewCell
            if (audioPlayer.player?.currentItem?.currentTime().seconds) != nil {
                let item =  (audioPlayer.player?.currentItem?.currentTime().seconds)!
                let totalDuration = (audioPlayer.player?.currentItem?.duration.seconds)!
                    let secs = Int(item)
                    let totalSec = Float(secs)
                    let totalTime = Float(totalDuration)
                    print(String(format: "%02d:%02d", secs/60, secs%60))//"\(secs/60):\(secs%60)"
                cell?.lblValue.text = String(format: "%02d:%02d", secs/60, secs%60)
                
                cell?.custSlider.maximumValue = totalTime
                cell?.custSlider.minimumValue = 0.0
                cell?.custSlider.value = totalSec
            }
        }
    }

    @IBAction func sliderValueChanged(sender : AnyObject) {
        let index = IndexPath(row: sender.tag, section: 0)
        let cell =  self.cropDetailTableView.cellForRow(at: index) as? CropSubscribscriptionDetailsCellTableViewCell
        self.audioPlayer?.player?.seek(to: CMTime(seconds: Double((cell?.custSlider.value)!), preferredTimescale: .max))
        
    }
    
        
}

    //MARK:- UITABLEVIEW DELEGATE METHODS
    extension CropDetailsPhaseViewController : UITableViewDataSource, UITableViewDelegate{
        
        
        @IBAction func nextAction(_ sender: Any) {
            
            // let visibleItems: NSArray = self.cropDetailTableView.indexPathsForVisibleItems as NSArray
            let visibleItems: NSArray = self.cropDetailTableView.indexPathsForVisibleRows as NSArray? ?? []
            if(visibleItems.count>0){
                if audioPlayer != nil {
                    audioPlayer?.stop()
                    audioPlayer = nil
                }
                let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
                let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
                if nextItem.row < mutArrayToDisplay.count {
                    self.cropDetailTableView.scrollToRow(at: nextItem, at: .top, animated: false)
                }
            }
        }
        
        
        @IBAction func previousAction(_ sender: Any) {
            let visibleItems: NSArray = self.cropDetailTableView.indexPathsForVisibleRows as NSArray? ?? []
            let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
            let nextItem: IndexPath = IndexPath(item: currentItem.item - 1, section: 0)
            if nextItem.row < mutArrayToDisplay.count && nextItem.row >= 0{
                if audioPlayer != nil {
                    audioPlayer?.stop()
                    audioPlayer = nil
                }
                self.cropDetailTableView.scrollToRow(at: nextItem, at: .top, animated: false)
            }
        }
        
        
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.mutArrayToDisplay.count
        }
        
        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cellIdentifier =  "Cell"
            let cell:CropSubscribscriptionDetailsCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CropSubscribscriptionDetailsCellTableViewCell
            
            let dicObj : GrowthCASubPhasesDetailBO = mutArrayToDisplay.object(at: indexPath.row) as! GrowthCASubPhasesDetailBO
            
            let strMesage = String(format : "%@ \n \n %@",dicObj.localLanguageMessage as String? ?? "",dicObj.englishMessage as? String ?? "")
            cell.messageTextView.text = strMesage//dicObj.localLanguageMessage as? String ?? ""
            cell.lblStage.text = dicObj.stage as String? ?? ""
            topLabel.text =   String(format :"%@ - %@",dicObj.cropName  as String? ?? "",dicObj.hybridName  as String? ?? "") //dicObj.cropName  as String? ?? ""
            cell.lblExpectedDate.text = ""
            
            cell.playOrangeBtn.tag = indexPath.row
            cell.custSlider.tag = indexPath.row
            cell.playOrangeBtn.addTarget(self, action:  #selector(CropDetailsPhaseViewController.playPauseBtn), for: .touchUpInside)
            cell.btnPrevious.addTarget(self, action:  #selector(CropDetailsPhaseViewController.previousAction), for: .touchUpInside)
            cell.btnNext.addTarget(self, action:  #selector(CropDetailsPhaseViewController.nextAction), for: .touchUpInside)
            if dicObj.isPlaying == true {
                cell.playOrangeBtn.setImage(UIImage(named:"pause"),for: .normal)//PauseSmall
            }
            else {
                cell.playOrangeBtn.setImage(UIImage(named:"play"),for: .normal)
            }
//            cell.custSlider.thumbRect(forBounds: CGRect(x: cell.custSlider.frame.origin.x, y: cell.custSlider.frame.origin.y, width: 5, height: 5), trackRect: cell.custSlider!.bounds, value: 5)
            cell.lblExpectedDate.text = dicObj.expectedDate  as String? ?? ""
            let url = URL(string:dicObj.thumImageName as String? ?? "")
          //  profileImage.kf.setImage(with: url , placeholder: UIImage(named:"image_placeholder.png"), options: nil, progressBlock: nil, completionHandler: nil)
            DispatchQueue.main.async {
                cell.custSlider.setThumbImage(UIImage(named: "thumb"), for: .normal)
            }
            cell.custSlider.tintColor = UIColor.lightGray
            cell.custSlider.addTarget(self, action: #selector(CropDetailsPhaseViewController.sliderValueChanged), for: .valueChanged)
            DispatchQueue.main.async{
                self.profileImage.kf.setImage(with : url, placeholder: UIImage(named:"image_placeholder.png"))
            }
           
            
            if (indexPath.row - 1) >= 0{
                let dicObjPrev : GrowthCASubPhasesDetailBO = mutArrayToDisplay.object(at: indexPath.row - 1) as! GrowthCASubPhasesDetailBO
                //PRevious obj
                let urlPrev = URL(string:dicObjPrev.thumImageName as String? ?? "")
               // cell.img_prevPhase.kf.setImage(with: urlPrev , placeholder: UIImage(named:"image_placeholder.png"), options: nil, progressBlock: nil, completionHandler: nil)
                 DispatchQueue.main.async{
                  cell.img_prevPhase.kf.setImage(with : urlPrev, placeholder: UIImage(named:"image_placeholder.png"))
                }
                cell.lbl_prevPhaseTitle.text = dicObjPrev.stage  as String? ?? ""

                cell.lbl_prevPhaseDays.text = dicObjPrev.startDate  as String? ?? ""
                cell.lbl_prevObjDate.text =  ""
                cell.view_previous.isHidden = false
                cell.btnPrevious.isHidden = false
            }
            if (indexPath.row - 1) == -1{
                cell.btnPrevious.isHidden = true
                cell.view_previous.isHidden = true
            }
            
            if (indexPath.row + 1) < mutArrayToDisplay.count {
                let dicObjnext : GrowthCASubPhasesDetailBO = mutArrayToDisplay.object(at: indexPath.row + 1) as! GrowthCASubPhasesDetailBO
                //PRevious obj
                //next obj
                let urlnext = URL(string:dicObjnext.thumImageName as String? ?? "")
                DispatchQueue.main.async{
                cell.img_nextPhase.kf.setImage(with : urlnext, placeholder: UIImage(named:"image_placeholder.png"))
                }
//                cell.img_nextPhase.kf.setImage(with: urlnext , placeholder: UIImage(named:"image_placeholder.png"), options: nil, progressBlock: nil, completionHandler: nil)
                cell.lbl_nextPhaseTitle.text = dicObjnext.stage  as String? ?? ""
                
                cell.lbl_nextObjDate.text = ""
                cell.view_next.isHidden = false
                cell.btnNext.isHidden = false
                cell.lbl_nextPhaseDays.text = dicObjnext.startDate  as String? ?? ""
                  
//                if   let totalDur = self.audioPlayer?.player?.currentItem?.currentTime().ap_timeIntervalValue {
//                    cell.lblValue.text = "\(Float(totalDur))"
//                }
                
            }
            if (indexPath.row + 1) == mutArrayToDisplay.count{
                
                
                cell.btnNext.isHidden = true
                cell.view_next.isHidden = true
            }

            return cell
        }
      
        
        public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 0
        }
        
        public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UIScreen.main.bounds.size.height - 60
        }

}

