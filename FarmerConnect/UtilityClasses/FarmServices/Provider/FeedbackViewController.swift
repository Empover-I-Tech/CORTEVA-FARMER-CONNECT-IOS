//
//  FeedbackViewController.swift
//  FarmerConnect
//
//  Created by Admin on 08/01/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class FeedbackViewController: ProviderBaseViewController,FloatRatingViewDelegate,UITableViewDelegate,UITableViewDataSource {
    var selectedFeedback : Feedback?
    @IBOutlet var scrollView : UIScrollView?
    @IBOutlet var contentView : UIView?
    @IBOutlet var equipmentDetailsView : UIView?
    @IBOutlet var ratingView : FloatRatingView?
    @IBOutlet var serviceFailedView : UIView?
    @IBOutlet var serviceFailedTopConstraint : NSLayoutConstraint?
    @IBOutlet var serviceFailedCommentTopConstraint : NSLayoutConstraint?
    @IBOutlet var contentViewHeightConstraint : NSLayoutConstraint?
    @IBOutlet var tableViewHeight : NSLayoutConstraint?
    @IBOutlet var btnServiceComplete : ISRadioButton?
    @IBOutlet var btnServiceFail : ISRadioButton?
    @IBOutlet var txtComments : KMPlaceholderTextView?
    @IBOutlet var imgEquipment : UIImageView?
    @IBOutlet var lblBookedDate : UILabel?
    @IBOutlet var lblFromLocation : UILabel?
    @IBOutlet var lblToLocation : UILabel?
    @IBOutlet var tblQuestions : UITableView?
    var arrRateQuestions = NSMutableArray()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ratingView?.delegate = self
        ratingView?.type = .wholeRatings
        ratingView?.minRating = 0
        if selectedFeedback != nil{
            lblBookedDate?.text = selectedFeedback?.bookedDate as String? ?? ""
            lblFromLocation?.text = selectedFeedback?.fromLocation as String? ?? ""
            lblToLocation?.text = selectedFeedback?.toLocation as String? ?? ""
            let imageUrl = URL(string: selectedFeedback?.equipImage! as String? ?? "")
            imgEquipment?.kf.setImage(with: imageUrl as Resource?, placeholder: UIImage(named:"PlaceHolderImage"), options: nil, progressBlock: nil)
        }
        btnServiceComplete?.isSelected = true
        tblQuestions?.tableFooterView = UIView()
        tblQuestions?.estimatedRowHeight = 35
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.topView?.isHidden = false
        self.lblTitle?.text = "Feedback"
        self.backButton?.isHidden = true
        self.contentViewHeightConstraint?.constant = (600)
        self.tblQuestions?.isHidden = true
        self.scrollView?.contentSize = CGSize(width: (self.scrollView?.frame.size.width)!, height: 600)
    }
    
    func submitEquipmentRating(_ parameters: NSDictionary){
        let headers : HTTPHeaders = self.getProviderHeaders()
        //print(headers)
        SwiftLoader.show(animated: true)
        let urlString = String(format: "%@%@", arguments: [BASE_URL,Submit_Equipment_Feedback])
        let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
        let params =  ["data" : paramsStr]
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        //let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        //let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        //print("Response after decrypting data:\(decryptData)")
                        let appDelegate = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.window?.makeToast(Feedback_Submitted_Successfully)
                        self.navigationController?.dismiss(animated: true, completion: nil)
                    }
                    else{
                        if let message = (json as! NSDictionary).value(forKey: "message") as? String {
                            self.view.makeToast(message)
                        }
                    }
                }
            }
            else{
                self.view.makeToast((response.error?.localizedDescription)!)
            }
        }
    }
    
    func fetchRatingRelatedQuestionsFromServer(_ rating: Double){
        let headers : HTTPHeaders = self.getProviderHeaders()
        //print(headers)
        SwiftLoader.show(animated: true)
        let urlString = String(format: "%@%@", arguments: [BASE_URL,Get_Rating_Questions])
        let parameters = ["rating": rating]
        let paramsStr = Constatnts.nsobjectToJSON(parameters as NSDictionary)
        let params =  ["data" : paramsStr]
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            SwiftLoader.hide()
            if response.result.error == nil {
                if let json = response.result.value {
                    //print("Response :\(json)")
                    let responseStatusCode = (json as! NSDictionary).value(forKey: "statusCode") as! String
                    if responseStatusCode == STATUS_CODE_200{
                        let respData = (json as! NSDictionary).value(forKey: "response") as! NSString
                        let decryptData  = Constatnts.decryptResult(StrJson: respData as String)
                        //print("Response after decrypting data:\(decryptData)")
                        if let arrQuestions = Validations.checkKeyNotAvailForArray(decryptData, key: "questions") as? NSArray{
                            if arrQuestions.count > 0{
                                self.arrRateQuestions.removeAllObjects()
                                self.tblQuestions?.isHidden = false
                                for index in 0..<arrQuestions.count{
                                    if let questionDic = arrQuestions.object(at: index) as? NSDictionary{
                                        let rateQuest = RateQuestion(dict: questionDic)
                                        self.arrRateQuestions.add(rateQuest)
                                        self.tblQuestions?.reloadData()
                                        self.tblQuestions?.layoutIfNeeded()
                                        self.tableViewHeight?.constant = min((self.tblQuestions?.frame.size.width)!, (self.tblQuestions?.contentSize.height)!)
                                        self.contentViewHeightConstraint?.constant = (580 + (self.tblQuestions?.contentSize.height)!)
                                        self.tblQuestions?.layoutIfNeeded()
                                        self.view.layoutIfNeeded()
                                        self.view.updateConstraintsIfNeeded()
                                        self.scrollView?.contentSize = CGSize(width: (self.scrollView?.frame.size.width)!, height: (self.contentView?.frame.maxY)!  + 10)
                                    }
                                }
                            }
                        }
                    }
                    else{
                        if let message = (json as! NSDictionary).value(forKey: "message") as? String {
                            self.view.makeToast(message)
                        }
                    }
                }
            }
            else{
                self.view.makeToast((response.error?.localizedDescription)!)
            }
        }
    }
    @IBAction func serviceCompletedButtonClick(_ sender: UIButton){
        self.serviceFailedTopConstraint?.constant = 20
        self.serviceFailedCommentTopConstraint?.constant = 6
        self.equipmentDetailsView?.isHidden = false
        self.ratingView?.isHidden = false
        self.txtComments?.text = ""
        self.view.layoutIfNeeded()
        self.view.updateConstraintsIfNeeded()
    }
    @IBAction func serviceFailedButtonClick(_ sender: UIButton){
        self.serviceFailedTopConstraint?.constant = -285
        self.serviceFailedCommentTopConstraint?.constant = -40
        self.ratingView?.isHidden = true
        self.equipmentDetailsView?.isHidden = true
        self.txtComments?.text = ""
        self.view.layoutIfNeeded()
        self.view.updateConstraintsIfNeeded()
    }
    @IBAction func submitFeedbackButtonClick(_ sender: UIButton){
        let userObj = Constatnts.getUserObject()
        let fireBaseParams = [MOBILE_NUMBER: userObj.mobileNumber!,USER_ID: userObj.customerId,ORDER_ID:selectedFeedback!.equipmentTransactionId ?? ""]
        self.registerFirebaseEvents(PV_FSR_Ratings_View, "", "", "", parameters: fireBaseParams as NSDictionary)
        self.view.endEditing(true)
        if btnServiceComplete?.isSelected == true {
            if ratingView?.rating == 0.0{
                self.view.makeToast(Please_Select_Rating)
            }
            else if Validations.isNullString(txtComments?.text as NSString? ?? "" as NSString) == true{
                self.view.makeToast(Please_Enter_your_Comments)
            }
            else{
                if selectedFeedback != nil{
                    if selectedFeedback?.equipmentTransactionId?.integerValue != 0{
                        let parameters = NSMutableDictionary()
                       parameters.setValue(selectedFeedback!.equipmentTransactionId!, forKey: "equipmentTransactionId")
                        parameters.setValue("true", forKey: "transactionHappened")
                        parameters.setValue(txtComments!.text, forKey: "comments")
                        parameters.setValue(ratingView!.rating, forKey: "rating")
                        var questionIds = ""
                        if arrRateQuestions.count > 0{
                            let predicate = NSPredicate(format: "isSelected == YES")
                            let arrResult = self.arrRateQuestions.filtered(using: predicate)
                            if arrResult.count > 0{
                                for index in 0..<arrResult.count{
                                    if let question = arrRateQuestions.object(at: index) as? RateQuestion{
                                        if index == 0{
                                            questionIds = question.questionId as String!
                                        }
                                        else{
                                            questionIds = questionIds.appendingFormat(",%@", question.questionId as String!)
                                        }
                                    }
                                }
                            }
                        }
                        if Validations.isNullString(questionIds as NSString) == false{
                            parameters.setValue(questionIds, forKey: "questionIds")
                        }
                        if Validations.isNullString(selectedFeedback?.equipmentId ?? "") == false{
                            if selectedFeedback!.equipmentId!.integerValue > 0{
                                parameters.setValue(selectedFeedback!.equipmentId, forKey: "equipmentId")
                            }
                        }
                        self.submitEquipmentRating(parameters)
                    }
                }
            }
        }
        else if btnServiceFail?.isSelected == true{
            if Validations.isNullString(txtComments?.text as NSString!) == true{
                self.view.makeToast(Please_Enter_your_Comments)
            }
            else{
                let parameters = NSMutableDictionary()
                parameters.setValue(selectedFeedback!.equipmentTransactionId!, forKey: "equipmentTransactionId")
                parameters.setValue("false", forKey: "transactionHappened")
                parameters.setValue(txtComments!.text, forKey: "reason")
                if Validations.isNullString(selectedFeedback?.equipmentId ?? "") == false{
                    if selectedFeedback!.equipmentId!.integerValue > 0{
                        parameters.setValue(selectedFeedback!.equipmentId, forKey: "equipmentId")
                    }
                }
                self.submitEquipmentRating(parameters)
            }
        }
    }
    
    //MARK: UITableview delegate and datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRateQuestions.count
    }
    /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return UITableViewAutomaticDimension
     }*/
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)){
            cell.separatorInset = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)) {
            cell.preservesSuperviewLayoutMargins = false
        }
        if cell.responds(to: #selector(setter: UIView.layoutMargins)){
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier =  "QuestionCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let order = arrRateQuestions.object(at: indexPath.row) as? RateQuestion
        let checkMark = cell.viewWithTag(102) as? UIButton
        let lblQuestion = cell.viewWithTag(101) as? UILabel
        checkMark?.isSelected = false
        if order?.isSelected == true {
            checkMark?.isSelected = true
        }
        lblQuestion?.text = order?.question as String!
        lblQuestion?.sizeToFit()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let question = arrRateQuestions.object(at: indexPath.row) as? RateQuestion
        if question?.isSelected == true{
            question?.isSelected = false
        }
        else{
            question?.isSelected = true
        }
        self.tblQuestions?.reloadData()
    }
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        //liveLabel.text = String(format: "%.2f", self.floatRatingView.rating)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        //updatedLabel.text = String(format: "%.2f", self.floatRatingView.rating)
        self.contentViewHeightConstraint?.constant = (600)
        self.tblQuestions?.isHidden = true
        self.scrollView?.contentSize = CGSize(width: (self.scrollView?.frame.size.width)!, height: (self.contentView?.frame.maxY)!  + 20)
        if self.ratingView!.rating > Double(0.0) {
            self.arrRateQuestions.removeAllObjects()
            self.tblQuestions?.reloadData()
            self.fetchRatingRelatedQuestionsFromServer(self.ratingView!.rating)
        }
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
