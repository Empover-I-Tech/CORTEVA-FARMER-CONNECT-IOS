//
//  TimelineTableViewCell.swift
//  TimelineTableViewCell
//
//  Created by Zheng-Xiang Ke on 2016/10/20.
//  Copyright © 2016年 Zheng-Xiang Ke. All rights reserved.
//

import UIKit
import SDWebImage


open class TimelineTableViewCell: UITableViewCell , UIPopoverControllerDelegate  {

    @IBOutlet weak open var lblDate: UILabel!
    @IBOutlet weak var titleLabelLeftMargin: NSLayoutConstraint!
    @IBOutlet weak var cvContents: UICollectionView!
    
    var arrFarmerTimeLineData = NSMutableArray()
    
//    var activityData = [TimeLineImageData]()
//    var broughtProductInfo = [BroughtProducts]()
    
    weak var cellDelegate:CustomCollectionViewCellDelegate?
    private let sectionInsets = UIEdgeInsets(top: 0.0,
                                             left: 0.0,
                                             bottom: 0.0,
                                             right: 0.0)
    
    private let itemsPerRow: CGFloat = 3
    private let itemsPerCloumn: CGFloat = 1
    
    open var viewsInStackView: [UIView] = []
    
    open var timelinePoint = TimelinePoint() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    open var timeline = Timeline() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    open var bubbleRadius: CGFloat = 2.0 {
        didSet {
            if (bubbleRadius < 0.0) {
                bubbleRadius = 0.0
            } else if (bubbleRadius > 6.0) {
                bubbleRadius = 6.0
            }
            self.setNeedsDisplay()
        }
    }
   
    open var bubbleColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
    open var bubbleEnabled = true

    
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        let nib = UINib(nibName: "ActivityCell", bundle: nil)
        self.cvContents.register(nib, forCellWithReuseIdentifier: "activityCell")
        self.cvContents.reloadData()
    }
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override open func draw(_ rect: CGRect) {
        for layer in self.contentView.layer.sublayers! {
            if layer is CAShapeLayer {
                layer.removeFromSuperlayer()
            }
        }

        timelinePoint.position = CGPoint(x: timeline.leftMargin, y: lblDate.frame.origin.y + lblDate.intrinsicContentSize.height / 2)

        timeline.start = CGPoint(x: timeline.leftMargin, y: 0)
        timeline.middle = CGPoint(x: timeline.start.x, y: timelinePoint.position.y)
        timeline.end = CGPoint(x: timeline.start.x, y: self.bounds.size.height)
        timeline.draw(view: self.contentView)

        timelinePoint.draw(view: self.contentView)

        if bubbleEnabled {
            drawBubble()
        }
        
    }
}

// MARK: - Fileprivate Methods
fileprivate extension TimelineTableViewCell {
    func drawBubble() {
        let padding: CGFloat = 8
        let bubbleRect = CGRect(
            x: (titleLabelLeftMargin.constant - 10) - padding,
            y: lblDate.frame.minY - padding,
            width: lblDate.intrinsicContentSize.width + padding * 2,
            height: lblDate.intrinsicContentSize.height + padding * 2)

        let path = UIBezierPath(roundedRect: bubbleRect, cornerRadius: bubbleRadius)
        let startPoint = CGPoint(x: bubbleRect.origin.x, y: bubbleRect.origin.y + bubbleRect.height / 2 - 8)
        path.move(to: startPoint)
        path.addLine(to: startPoint)
        path.addLine(to: CGPoint(x: bubbleRect.origin.x - 8, y: bubbleRect.origin.y + bubbleRect.height / 2))
        path.addLine(to: CGPoint(x: bubbleRect.origin.x, y: bubbleRect.origin.y + bubbleRect.height / 2 + 8))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = bubbleColor.cgColor
        
    }
}
extension TimelineTableViewCell : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout , UIPopoverPresentationControllerDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrFarmerTimeLineData.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = cvContents.dequeueReusableCell(withReuseIdentifier: "activityCell", for: indexPath) as! ActivityCell
        let obj = arrFarmerTimeLineData.object(at: indexPath.row) as? FarmerActivitiesModel
       
            
        cell.showPopOver.tag = indexPath.row
        cell.showPopOver.addTarget(self, action: #selector(showButtonAction(_:)), for: .touchUpInside)
       
        let urlImage = URL(string: obj!.activityImage!)
        cell.imgActivity.sd_setImage(with: urlImage, completed: nil)
        //        cell.imgActivity.contentMode = .scaleAspectFit
        cell.lblCropName.text = obj?.activityName
        cell.lblActivityName.text = obj?.activityType
        cell.showPopOver.tag = indexPath.row
        cell.showPopOver.addTarget(self, action: #selector(showButtonAction(_:)), for: .touchUpInside)
        cell.arrFarmerTimeLineData = arrFarmerTimeLineData
        return cell
    }
    
//    @objc func showButtonAction(_ sender: UIButton) {
//        let index = IndexPath(item: sender.tag, section: 0)
//        let cell = cvContents.cellForItem(at: index) as! ActivityCell
//        self.cellDelegate?.customCell(cell: cell, didTappedshow: sender, object: <#FarmerActivitiesModel#>)
//    }
//    func customCell(cell: ActivityCell, didTappedshow button: UIButton) {
//        self.cellDelegate?.customCell(cell: cell, didTappedshow: button, object: <#FarmerActivitiesModel#>)
//    }
    
    @objc func showButtonAction(_ sender: UIButton) {
        let fcModel : FarmerActivitiesModel = arrFarmerTimeLineData.object(at: sender.tag) as! FarmerActivitiesModel
        
        let index = IndexPath(item: sender.tag, section: 0)
        let cell = cvContents.cellForItem(at: index) as! ActivityCell
        self.cellDelegate?.customCell(cell: cell, didTappedshow: sender,object: fcModel)
    }
    
    func customCell(cell: ActivityCell, didTappedshow button: UIButton) {
        let fcModel : FarmerActivitiesModel = arrFarmerTimeLineData.object(at: button.tag) as! FarmerActivitiesModel
        
        self.cellDelegate?.customCell(cell: cell, didTappedshow: button, object: fcModel)
    }
    
    
//    private func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        //2
//        let paddingSpace = sectionInsets.left * (CGFloat(self.activityData.count) + 1)
//        let availableWidth = cvContents.frame.size.width - paddingSpace
//        let widthPerItem = availableWidth / CGFloat(self.activityData.count)
//
//        let paddingSpace1 = sectionInsets.bottom * (itemsPerCloumn + 1)
//        let availableHeight = cvContents.frame.size.height - paddingSpace1
//        let heightPerItem = availableHeight / itemsPerCloumn
//
//        return CGSize(width: widthPerItem, height: cvContents.frame.size.height)
//    }
////
    private func collectionView(_ collectionView: UICollectionView,
                                layout collectionViewLayout: UICollectionViewLayout,
                                sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:150
            , height: 150)
    }
  
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
        }

      
    



