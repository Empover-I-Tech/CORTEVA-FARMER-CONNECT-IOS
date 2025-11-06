//
//  CropNotificationDetailsViewController.swift
//  FarmerConnect
//
//  Created by Empover on 08/01/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit
import Alamofire


open class CropNotificationDetailsViewController: BaseViewController,AudioPlayerDelegate {

    @IBOutlet weak var tblViewCropNotificationDetails: UITableView!
    
    var arrayFromCropNotifVC = NSArray()
    var navBarTitleStr = ""
     var mutArrayToDisplay = NSMutableArray()
    
    var cropAdvisoryDocumentsDirectory = NSString()
    
    /// used third party library AudioPlayer to play the audio files
    var audioPlayer : AudioPlayer?
    
    var isPlaying = false
    
    var selectedStageEnt : CropAdvisoryDetailCell?
    var selectedNotification : CropAdvisoryNotifications?
    var currentIndexPath : NSIndexPath?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      //   let appDelegate = UIApplication.shared.delegate as! AppDelegate
         //cropAdvisoryDocumentsDirectory = appDelegate.getCropAdvisoryFolderPath() as NSString
        tblViewCropNotificationDetails.dataSource = self
        tblViewCropNotificationDetails.delegate = self
        tblViewCropNotificationDetails.tableFooterView = UIView()
        tblViewCropNotificationDetails.separatorStyle = .none
        if selectedNotification != nil{
            self.arrayFromCropNotifVC = selectedNotification?.messageList ?? NSArray()
            let shareButton = UIButton(frame: CGRect(x:UIScreen.main.bounds.size.width-42,y: 6,width: 40,height: 40))
            shareButton.backgroundColor =  UIColor.clear
            shareButton.setImage( UIImage(named: "Share"), for: UIControl.State())
            shareButton.addTarget(self, action: #selector(CropNotificationDetailsViewController.shareButtonClick(_:)), for: UIControl.Event.touchUpInside)
            self.topView?.addSubview(shareButton)
        }
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        if #available(iOS 10.0, *) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        super.viewWillAppear(true)
        self.topView?.isHidden = false
        lblTitle?.text = navBarTitleStr
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        
        self.mutArrayToDisplay.removeAllObjects()
        for i in 0 ..< (arrayFromCropNotifVC.object(at: 0) as! NSArray).count{
            let cropStagesDic = (arrayFromCropNotifVC.object(at: 0) as! NSArray).object(at: i) as? NSDictionary
            let cropStage = CropAdvisoryDetailCell(dict: cropStagesDic!)
            self.mutArrayToDisplay.add(cropStage)
        }
        print(mutArrayToDisplay)
    }
    
    override func backButtonClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func shareButtonClick( _ sender: UIButton)
    {
        if self.selectedNotification != nil {
            let urlPath = String(format: "%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@", Module,Crop_Advisori_Registration,User_Category, self.selectedNotification?.categoryId ?? "",State_Id,self.selectedNotification?.stateId ?? "",Crop_Id,self.selectedNotification?.cropId ?? "",Season_Id,self.selectedNotification?.seasonId ?? "",Hybrid_Id,self.selectedNotification?.hybridId ?? "")
            let finalUrl = String(format: "%@%@", deepLinkBaseUrl,urlPath)
            let message = String(format: "Crop Advisory %@ %@ %@", self.selectedNotification?.seasonName ?? "",self.selectedNotification?.cropName ?? "", self.selectedNotification?.hybridName ?? "")
            let activityControl = Validations.showShareActivityController(viewController: self, fileUrl: URL(string: finalUrl)!, userName: "", message: message)
            let userObj = Constatnts.getUserObject()
            let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,CA_Category:self.selectedNotification!.categoryName!,STATE:self.selectedNotification!.stateName!,CROP:self.selectedNotification!.cropName!,HYBRID:self.selectedNotification!.hybridName ?? "",SEASON:self.selectedNotification!.seasonName!] as [String : Any]
            self.registerFirebaseEvents(CA_Share, "", "", "", parameters: firebaseParams as NSDictionary)
            self.present(activityControl, animated: true, completion: nil)
        }
    }
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
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
        let buttonPosition = sender.convert(CGPoint(x:0,y:0), to: tblViewCropNotificationDetails)
        let indexPath = self.tblViewCropNotificationDetails!.indexPathForRow(at: buttonPosition)
        if indexPath != nil {
            if let cropStageEnt = mutArrayToDisplay.object(at: (indexPath?.row)!) as? CropAdvisoryDetailCell{
                if selectedStageEnt != nil {
                    if (cropStageEnt.isEqual(selectedStageEnt)) {
                        currentIndexPath = indexPath as NSIndexPath?
                       
                        var filePath = NSString()
                        
                        filePath = self.getDocumentPath(cropStageEnt.voiceFileURL as NSString)
                        let isFileExists = self.checkIfFileExists(atPath: filePath as String)
                        if isFileExists == true {
                            self.audioPlayerInitializationAndControl(stagesEnt: cropStageEnt, indexPath: indexPath! as NSIndexPath, playBtn: sender, filePath: filePath as String)

                        }
                        else{
                            self.audioPlayerInitializationAndControl(stagesEnt: cropStageEnt, indexPath: indexPath! as NSIndexPath, playBtn: sender, filePath: cropStageEnt.voiceFileURL as String)
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
                                tblViewCropNotificationDetails.reloadRows(at: [currentIndexPath! as IndexPath], with: .none)
                                // self.cropAdvisoryDetailsTblView.contentOffset = loc
                            }
                        }
                        currentIndexPath = indexPath as NSIndexPath?
                        var filePath = NSString()
                        
                        filePath = self.getDocumentPath(cropStageEnt.voiceFileURL as NSString)
                        let isFileExists = self.checkIfFileExists(atPath: filePath as String)
                        if isFileExists == true {
                            self.audioPlayerInitializationAndControl(stagesEnt: cropStageEnt, indexPath: indexPath! as NSIndexPath, playBtn: sender, filePath: filePath as String)
                            
                        }
                        else{
                            self.audioPlayerInitializationAndControl(stagesEnt: cropStageEnt, indexPath: indexPath! as NSIndexPath, playBtn: sender, filePath: cropStageEnt.voiceFileURL as String)
                        }
                    }
                }
                else{
                    currentIndexPath = indexPath as NSIndexPath?
                    selectedStageEnt = cropStageEnt
                    var filePath = NSString()
                    
                    filePath = self.getDocumentPath(cropStageEnt.voiceFileURL as NSString)
                    let isFileExists = self.checkIfFileExists(atPath: filePath as String)
                    if isFileExists == true {
                        self.audioPlayerInitializationAndControl(stagesEnt: cropStageEnt, indexPath: indexPath! as NSIndexPath, playBtn: sender, filePath: filePath as String)
                        
                    }
                    else{
                        self.audioPlayerInitializationAndControl(stagesEnt: cropStageEnt, indexPath: indexPath! as NSIndexPath, playBtn: sender, filePath: cropStageEnt.voiceFileURL as String)
                    }
                }
            }
        }
    }
    
    //MARK: audioPlayerInitializationAndControl
    func audioPlayerInitializationAndControl(stagesEnt: CropAdvisoryDetailCell, indexPath: NSIndexPath?,playBtn:UIButton, filePath : String){
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
            // self.view.makeToast(Story_Download_Fail_Message)
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
                
                //self.cropAdvisoryDetailsTblView.canCancelContentTouches = true
                //self.cropAdvisoryDetailsTblView.beginUpdates()
                //let loc = self.cropAdvisoryDetailsTblView.contentOffset
                UIView.setAnimationsEnabled(false)
                UIView.performWithoutAnimation {
                    self.tblViewCropNotificationDetails.reloadRows(at: [self.currentIndexPath! as IndexPath], with: .none)
                }
                //self.cropAdvisoryDetailsTblView.contentOffset = loc
                //self.cropAdvisoryDetailsTblView.endUpdates()
            }
        }
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

extension CropNotificationDetailsViewController : UITableViewDataSource, UITableViewDelegate{
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mutArrayToDisplay.count
    }
    
  public  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellIdentifier =  "NormalCell"
        let dictToChkKey = (arrayFromCropNotifVC.object(at: 0) as! NSArray).object(at: indexPath.row) as! NSDictionary
        let mutDict = mutArrayToDisplay.object(at: indexPath.row) as! CropAdvisoryDetailCell
        let audioFileToChk = (Validations.checkKeyNotAvail(dictToChkKey, key: "voiceFileURL") as?NSString)!
        if Validations.isNullString(audioFileToChk) == false{
            cellIdentifier =  "CropNotificationWithAudioCell"
            tblViewCropNotificationDetails.register(UINib.init(nibName: "CropNotificationWithAudioCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
            let cell:CropNotificationWithAudioCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CropNotificationWithAudioCell
            cell.lblSentOn.text = mutDict.sentOn! as String
            
            cell.lblNumOfDays.text = mutDict.noOfDays! as String
            cell.lblStage.text = mutDict.stageName! as String
            cell.lblMessage.text = mutDict.message as String
            cell.lblMsgInLocalLang.text = mutDict.messageInLocalLang as String
            cell.lblExpectedDate.text = mutDict.supposeToBeOn! as String
            
            cell.playPauseBtn.tag = indexPath.row
            cell.playPauseBtn.addTarget(self, action:  #selector(CropNotificationDetailsViewController.playPauseBtn), for: .touchUpInside)
            if mutDict.isPlaying == true {
                cell.playPauseBtn.setImage(UIImage(named:"VideoPauseIcon"),for: .normal)//PauseSmall
            }
            else {
                cell.playPauseBtn.setImage(UIImage(named:"VideoIcon"),for: .normal)
            }
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        let lblSentOn = cell.viewWithTag(100) as? UILabel
        let lblMsg = cell.viewWithTag(101) as? UILabel
        
        lblSentOn?.text = mutDict.sentOn! as String
        lblMsg?.text = mutDict.message as String
        
        return cell
    }
}
