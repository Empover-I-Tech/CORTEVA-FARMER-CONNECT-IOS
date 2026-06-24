//
//  RHRDSuccessStoryViewController.swift
//  FarmerConnect
//
//  Created by Empover on 09/09/21.
//  Copyright © 2021 ABC. All rights reserved.
//


import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import Alamofire

class RHRDSuccessStoryViewController: BaseViewController,UIScrollViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate , UICollectionViewDelegate,UICollectionViewDataSource{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var shareAndPreview: UIButton!
    var documentInteractionController:UIDocumentInteractionController!
    var isimageSelected =  false
    var isMessageSelected = false
    @IBOutlet weak var shareOnMediaStack: UIStackView!
    @IBOutlet weak var sharingStatement: UICollectionView!
    @IBOutlet weak var img_upload: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var fieldSharingOnLabel: UILabel!
    @IBOutlet weak var uploadedPictureLbl: UILabel!
    @IBOutlet weak var placeholderLblLbl: UILabel!
    @IBOutlet weak var sharestoryLbl: UITextView!
    @IBOutlet weak var selectSharingStatement: UILabel!
    @IBOutlet weak var uploadPhotolbl: UILabel!
    var unsavedChangesAlert : UIView?
    var arrayFieldSharing = NSMutableArray()
    var alertController = UIAlertController()
    @IBOutlet weak var facebook: UILabel!
    @IBOutlet weak var whatsApp: UILabel!
    var selectedStr = ""
    var arrSelected = NSMutableArray()
    @IBOutlet weak var succuesssStoryTextView: UITextView!
    @IBOutlet weak var successstoryTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        fieldSharingOnLabel.text = NSLocalizedString("cep_Field_Sharing_social", comment: "")
        uploadedPictureLbl.text = NSLocalizedString("cep_Field_Sharing_uploadPictureFrame", comment: "")
        selectSharingStatement.text = NSLocalizedString("rhrd_share_Story_Ttilee", comment: "")
        uploadPhotolbl.text = NSLocalizedString("cep_Field_Sharing_upload_photo", comment: "")
        shareAndPreview.setTitle(NSLocalizedString("cep_shareAndPreview", comment: ""), for: .normal)//
        placeholderLblLbl.text = " \(NSLocalizedString("rhrd_Enter_Story_Ttilee", comment: ""))"
        shareOnMediaStack.isHidden = true
        let refreshButton = UIButton(type: .custom)
        refreshButton.frame = CGRect(x: (self.topView?.frame.size.width)! - 60, y: 10, width: 30, height: 30)
        refreshButton.addTarget(self, action: #selector(self.refreshButtonClick(_:)), for: .touchUpInside)
        refreshButton.setImage(UIImage(named: "RefreshWhite"), for: .normal)
        self.topView?.addSubview(refreshButton)

    }
    
    override func backButtonClick(_ sender: UIButton) {
        if self.isimageSelected == false || isMessageSelected ==  false{
            self.unsavedChangesAlert = CustomAlert.alertPopUpView(self, frame: self.view.frame, title: NSLocalizedString("alert", comment: "") as NSString, message: String(format: NSLocalizedString("unsaved_changes_alert", comment: "")) as NSString, okButtonTitle:NSLocalizedString("yes", comment: "") , cancelButtonTitle: NSLocalizedString("no", comment: "")) as? UIView
            self.view.addSubview(self.unsavedChangesAlert!)
            
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: alertYesBtnAction
    /**
     YES button action of the alertView which is displayed to the user
     when already logged in other device
     */
    @objc func alertYesBtnAction(){
        
        if self.unsavedChangesAlert != nil {
            self.unsavedChangesAlert?.removeFromSuperview()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func infoAlertSubmit(){
        
        if self.unsavedChangesAlert != nil {
            self.unsavedChangesAlert?.removeFromSuperview()
        }
    }
    //MARK: alertNoBtnAction
    /**
     NO button action of the alertView which is displayed to the user
     when already logged in other device
     */
    @objc func alertNoBtnAction(){
        unsavedChangesAlert?.removeFromSuperview()
    }
    
    
    @IBAction func refreshButtonClick(_ sender : UIButton){
        img_upload.image = UIImage(named: "PlaceHolderImage.png")
        var selectedStr = ""
        if arrSelected.count>0{
            arrSelected.removeAllObjects()
            sharingStatement.reloadData()
        }
        succuesssStoryTextView.text = ""
        placeholderLblLbl.text = ""+NSLocalizedString("rhrd_Enter_Story_Ttilee", comment: "")
        isimageSelected = false
        isMessageSelected = false
        shareOnMediaStack.isHidden = true
        shareAndPreview.isUserInteractionEnabled = true
        shareAndPreview.backgroundColor = App_Theme_Orange_Color
    }
    
    
    @IBAction func camerOrGalleryAction(_ sender: Any) {
        let userObj = Constatnts.getUserObject()
        // let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,CROP:cropNameFromCropDiagnosisVC ?? ""]
        //        self.registerFirebaseEvents(CDI_Capture_Photo_Hint_OK, "", "", "", parameters: firebaseParams as NSDictionary)
        let attributedString = NSAttributedString(string: NSLocalizedString("choose_option", comment: ""), attributes: [
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20),
            NSAttributedStringKey.foregroundColor : UIColor.orange
        ])
        alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alertController.setValue(attributedString, forKey: "attributedMessage")
        let sendButton = UIAlertAction(title: NSLocalizedString("camera", comment: ""), style: .default, handler: { (action) -> Void in
            print("Camera button tapped")
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.camera()
                //let userObj = Constatnts.getUserObject()
                //let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,CROP:self.cropNameFromCropDiagnosisVC ?? ""]
                //self.registerFirebaseEvents(CD_Crop_Camera, "", "", "", parameters: firebaseParams as NSDictionary)
            }
            else{
                print("not compatible")
            }
        })
        
        let  deleteButton = UIAlertAction(title: NSLocalizedString("gallery", comment: ""), style: .default, handler: { (action) -> Void in
            print("Gallery button tapped")
            self.photoLibrary()
            //let userObj = Constatnts.getUserObject()
            //let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,CROP:self.cropNameFromCropDiagnosisVC ?? ""]
            //self.registerFirebaseEvents(CD_Crop_Gallery, "", "", "", parameters: firebaseParams as NSDictionary)
        })
        let  cancelButton = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        alertController.addAction(sendButton)
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        self.navigationController!.present(alertController, animated: true, completion: nil)
        
    }
    
    //MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //print(info)
        if let image_data = info[UIImagePickerControllerEditedImage] as? UIImage {
            img_upload.image = image_data
            isimageSelected = true
        }
        if Reachability.isConnectedToNetwork(){
            if let image_data = info[UIImagePickerControllerEditedImage] as? UIImage {
                img_upload.image = image_data
                if let data = UIImagePNGRepresentation(image_data) as Data? {
                    //print("There were \(data.count) bytes")
                    let bcf = ByteCountFormatter()
                    bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
                    bcf.countStyle = .file
                    let string = bcf.string(fromByteCount: Int64(data.count))
                    //print("original image size: \(string)")
                }
                
                let resizedImg = resized(image: image_data)
                if let data1 = UIImagePNGRepresentation(resizedImg!) as Data? {
                    //print("There were \(data1.count) bytes")
                    let bcf = ByteCountFormatter()
                    bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
                    bcf.countStyle = .file
                    let string = bcf.string(fromByteCount: Int64(data1.count))
                    //print("resized image size: \(string)")
                }
                let imageData:Data = UIImagePNGRepresentation(resizedImg!)!
                let imageStr = imageData.base64EncodedString()
                // self.registerFirebaseEvents(CDI_Capture_Photo_Success, "", "", Capture_Photo, parameters: nil)
                
                // self.uploadingWithMultiPartFormData(image_data)
            }
            
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                dismiss(animated: false) { [self] in
                    self.img_upload.image = image
                    
                }
            }
        }
        else{
            self.view.makeToast(CHECK_NETWORK_CONNECTION_MESSAGE)
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: resized image
    func resized (image: UIImage) -> UIImage?{
        var actualHeight: Float = Float(image.size.height)
        var actualWidth: Float = Float(image.size.width)
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = 320.0 / 480.0
        if imgRatio != maxRatio {
            if imgRatio < maxRatio {
                imgRatio = 480.0 / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = 480.0
            }
            else {
                imgRatio = 320.0 / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = 320.0
            }
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData:Data = UIImageJPEGRepresentation(img!, 1)!
        UIGraphicsEndImageContext()
        return UIImage(data: imageData)!
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        let userObj = Constatnts.getUserObject()
        let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,Screen_Name_Param: "CropDiagnosisHintScreen"]
        // self.registerFirebaseEvents(CEP_Capture_Photo_Cancel, "", "", "", parameters: firebaseParams as NSDictionary)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func camera()
    {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.allowsEditing = true
        myPickerController.sourceType = UIImagePickerControllerSourceType.camera
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    //MARK: photo library
    func photoLibrary()
    {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.allowsEditing = true
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    @IBAction func previewAndShareAction(_ sender: Any) {
        if isimageSelected && succuesssStoryTextView.text != ""{
            //            shareOnMediaStack.isHidden = false
            //            shareAndPreview.isUserInteractionEnabled = false
            //            shareAndPreview.backgroundColor = .gray
            
            let deviceID = UIDevice.current.identifierForVendor!.uuidString.replacingOccurrences(of: "-", with: "") as String
            let net = NetworkReachabilityManager(host: "www.google.com")
            if net?.isReachable == true{
                
                let userObj = Constatnts.getUserObject()
                let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,]
                self.registerFirebaseEvents(PV_CEP_Update_Profile_Submit, "", "", "", parameters: firebaseParams as NSDictionary)
                self.recordScreenView("HeighestViewController", "HeighestViewController")
                
                let currentTime = Constatnts.getCurrentMillis()
                let imgFileName = String(currentTime).replacingOccurrences(of: "-", with: "")
                let strSubmitted = String(format:"%@.jpg",imgFileName)
                let dic : NSDictionary = [
                    "imagePath": strSubmitted,
                    "successStory": succuesssStoryTextView.text,
                    
                ]
                
                let paramsDic = NSMutableDictionary(dictionary: dic)
                // paramsDic.setValue(userObj.deviceToken, forKey: "deviceToken")
                let paramsStr = Constatnts.nsobjectToJSON(paramsDic as NSDictionary)
                let params =  ["data" : paramsStr]
                print(params)
                let net = NetworkReachabilityManager(host: "www.google.com")
                if net?.isReachable == true{
                    uploadingWithMultiPartFormData(paramsStr, nmae: strSubmitted)
                }
                
            }
        }
        else if isimageSelected && succuesssStoryTextView.text == "" {
            self.view.makeToast(NSLocalizedString("RHRD_SuccessStory_Validationfor_text", comment: ""))
        }
        
        else{
            self.view.makeToast(NSLocalizedString("RHRD_capture_or_selectImage", comment: ""))
        }
    }
    
    //MARK:- uploadingWithMultiPartFormData UPLOAD CAPTURE IMAGE FOR
    func uploadingWithMultiPartFormData( _ str : String,nmae: String){
        let userObj = Constatnts.getUserObject()
        let firebaseParams = [MOBILE_NUMBER:userObj.mobileNumber!,USER_ID:userObj.customerId!,]
        //   self.registerFirebaseEvents(CDI_Peat_Integration_Request, "", "", "", parameters: firebaseParams as NSDictionary)
        
        //UPDATE
        //self.recordScreenView("UploadEVENT", Capture_Photo)
        
        SwiftLoader.show(animated: true)
        //let image = UIImage(named: "profile_icon.png")!
        
        let params = ["data" : str]
        //let paramsStr = Constatnts.nsobjectToJSON(params as NSDictionary)
        let data = NSKeyedArchiver.archivedData(withRootObject: params)
        
        var stringAPI = ""
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(params) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
                stringAPI = jsonString
            }
        }
        
        print(data)
        let headers: HTTPHeaders = [
            "userAuthorizationToken": userObj.userAuthorizationToken! as String,
            "mobileNumber": userObj.mobileNumber! as String,
            "customerId": userObj.customerId! as String,
            "deviceId": userObj.deviceId! as String]
        
        Alamofire.upload(multipartFormData: {(multipartFormData) in
            multipartFormData.append(stringAPI.data(using: String.Encoding.utf8)!, withName: "encodedData")
            
            // import image to request
            DispatchQueue.main.async {
                if let imageData = UIImageJPEGRepresentation(self.img_upload.image ?? UIImage(), 1) {
                    multipartFormData.append(imageData, withName: "multipartFile", fileName: nmae, mimeType: "image/png")
                }
            }
        }, usingThreshold: 60, to: String(format :"%@%@",BASE_URL,GET_RHRD_SUCCESSTORY), method: .post, headers: headers, encodingCompletion: {(encodeResult) in
            switch encodeResult {
            case .success(let upload, _, _):
                upload.validate().responseJSON { response in
                    
                    
                    SwiftLoader.hide()
                    //
                    //debugPrint(response)
                    print(response)
                    if response.result.error == nil{
                        if let json = response.result.value{
                            print(json)
                            let responseStatusCode =  (json as? NSDictionary)?.value(forKey: "statusCode") as? String ?? ""
                            self.shareOnMediaStack.isHidden = false
                            self.shareAndPreview.isUserInteractionEnabled = false
                            self.shareAndPreview.backgroundColor = .gray
                            if responseStatusCode == STATUS_CODE_200{
                                // self.registerFirebaseEvents(PV_CEP_profile_update_success, "", "", "", parameters: firebaseParams as NSDictionary)
                                
                                let okStr = NSLocalizedString("ok", comment: "")//
                                let msgStr = NSLocalizedString("Submitted_Successfully", comment: "")
                                //                            UIApplication.shared.keyWindow?.makeToast(msg as String)
                                
                                
                                
                            }else if responseStatusCode == STATUS_CODE_601{
                                Constatnts.logOut()
                                if let msg = ((json as! NSDictionary).value(forKey: "message") as? NSString){
                                    print(msg)
                                    self.view.makeToast(msg as String)
                                }
                            }else {  }
                        }
                    }
                    else{
                        //                        self.registerFirebaseEvents(PV_CEP_profile_update_failure, "", "", "", parameters: firebaseParams as NSDictionary)
                        //                        self.view.makeToast(response.result.error?.localizedDescription ?? "")
                        
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                self.registerFirebaseEvents(PV_CEP_profile_update_failure, "", "", "", parameters: firebaseParams as NSDictionary)
                self.view.makeToast(encodingError.localizedDescription)
            }
        })
    }
    
    
    @IBAction func whatsAppShareAction(_ sender: Any) {
        let urlWhats = "https://wa.me/9985789922?text=I'm%20interested%20in%20your%20car%20for%20sale"    // 2
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            // 3
            if let whatsappURL = NSURL(string: urlString) {
                // 4
                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                    // 5
                    UIApplication.shared.open(whatsappURL as URL, options: [:], completionHandler: nil)
                } else {
                    // 6
                    print("Cannot Open Whatsapp")
                }
            }
        }
    }
    
    @IBAction func facebookShareAction(_ sender: Any) {
        
        let photo = SharePhoto(image: img_upload.image!, isUserGenerated: true)
        let content = SharePhotoContent()
        content.photos = [photo]
        photo.caption = self.selectedStr
        let showDialog = ShareDialog(viewController: self, content: content, delegate: self)
        // showDialog.mode = .feedWeb
        showDialog.show()
        if (showDialog.canShow) {
            showDialog.show()
        } else {
            self.view.makeToast("It looks like you don't have the Facebook mobile app on your phone.")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.topView?.isHidden = false
        self.homeButton?.isHidden = true
        self.whatsApp.text = NSLocalizedString("RHRD_Whatsap", comment: "")
        self.facebook.text = NSLocalizedString("RHRD_FACEBOOK", comment: "")
        arrayFieldSharing = [ NSLocalizedString("cep_Share_statement_one", comment: ""),
                              NSLocalizedString("Ab Pure Honge Sapne Hazzar", comment: ""),
                              NSLocalizedString("Tarraki ka Naya Savera", comment: "")
        ]
        
        self.lblTitle?.text = NSLocalizedString("rhrd_share_succesStory_and_get_luckydraw", comment: "")
        
        self.backButton?.setImage(UIImage(named: "Back"), for: .normal)
        
    }
    
    @IBAction func whatsAppShare(_ sender: Any)
    {
        let urlWhats = "whatsapp://send?text=\(selectedStr)"
        
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            // 3
            if let whatsappURL = NSURL(string: urlString) {
                // 4
                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                    // 5
                    UIApplication.shared.open(whatsappURL as URL, options: [:], completionHandler: nil)
                } else {
                    // 6
                    print("Cannot Open Whatsapp")
                }
            }
        }
        
        
    }
    
    //MARK: UICollectionView Datasource and Delegate methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrayFieldSharing.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.sharingStatement?.dequeueReusableCell(withReuseIdentifier: "cepShare", for: indexPath)
        let shareButton = cell?.viewWithTag(100) as? UIButton
        let sharetext = cell?.viewWithTag(102) as? UILabel
        sharetext?.text = arrayFieldSharing.object(at: indexPath.row) as? String ?? ""
        // shareButton?.setTitle(arrayFieldSharing.object(at: indexPath.row) as? String ?? "", for: .normal)
        shareButton?.setImage(UIImage(named: "radioEmpty"), for: .normal)
        if arrSelected.contains(arrayFieldSharing.object(at: indexPath.row) as? String ?? ""){
            shareButton?.setImage(UIImage(named: "radio"), for: .normal)
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        arrSelected.removeAllObjects()
        arrSelected.add(arrayFieldSharing.object(at: indexPath.row) as? String ?? "")
        self.sharingStatement.reloadData()
        isMessageSelected = true
        self.selectedStr = arrayFieldSharing.object(at: indexPath.row) as? String ?? ""
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)//top,left,bottom,right
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    
    
}

extension RHRDSuccessStoryViewController : UIDocumentInteractionControllerDelegate{
    public func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    public func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
        documentInteractionController = nil
        
    }
}
extension RHRDSuccessStoryViewController: SharingDelegate {
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        print("didCompleteWithResults")
        
    }
    
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        print("didFailWithError: \(error.localizedDescription)")
    }
    
    func sharerDidCancel(_ sharer: Sharing) {
        print("sharerDidCancel")
    }
}
extension RHRDSuccessStoryViewController{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLblLbl.text = ""
        
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        placeholderLblLbl.text = ""
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if succuesssStoryTextView.text != ""{
            placeholderLblLbl.text = ""
        }
        else{
            placeholderLblLbl.text = ""+NSLocalizedString("rhrd_Enter_Story_Ttilee", comment: "")
        }
    }
}


