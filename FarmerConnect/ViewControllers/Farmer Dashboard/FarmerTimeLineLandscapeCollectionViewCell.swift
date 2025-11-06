//
//  FarmerTimeLineLandscapeCollectionViewCell.swift
//  PioneerEmployee
//
//  Created by Admin on 22/08/19.
//  Copyright © 2019 Empover. All rights reserved.
//

import UIKit
import Kingfisher


protocol CustomTableCellDelegate:class {
    func customCell(cell:FarmerTimeLineItemsCollectionViewCell, didTappedshow button:UIButton, object : FarmerActivitiesModel)
}
class FarmerTimeLineItemsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var showPopOver: UIButton!
    @IBOutlet weak var lblTop: UILabel!
    @IBOutlet weak var lblBottom: UILabel!
    @IBOutlet weak var imgView: UIImageView!
}
class FarmerTimeLineLandscapeCollectionViewCell: UICollectionViewCell,UICollectionViewDataSource,UICollectionViewDelegate {
    
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    var arrFarmerTimeLineData : NSArray = NSArray()
    weak var cellDelegate:CustomTableCellDelegate?

    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
        
        itemsCollectionView.delegate = dataSourceDelegate
        itemsCollectionView.dataSource = dataSourceDelegate
        itemsCollectionView.tag = row
        itemsCollectionView.reloadData()
        
    }
    
    override func awakeFromNib() {
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrFarmerTimeLineData.count
    }//collectionViewItemCells
   // FarmerTimeLineItemsCollectionViewCell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell:FarmerTimeLineItemsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewItemCells", for: indexPath) as! FarmerTimeLineItemsCollectionViewCell

        let fcModel = arrFarmerTimeLineData.object(at: indexPath.row) as? FarmerActivitiesModel
        
        let imageUrl = URL(string: fcModel?.activityImage as String? ?? "" )
        
        DispatchQueue.main.async{
            cell.imgView.kf.setImage(with: imageUrl as Resource?, placeholder: UIImage(named:"image_placeholder.png"), options: nil, progressBlock: nil)
        }
        cell.showPopOver.tag = indexPath.row
        cell.showPopOver.addTarget(self, action: #selector(showButtonAction(_:)), for: .touchUpInside)

        cell.lblTop.text = fcModel?.activityType as String?
        cell.lblBottom.text = fcModel?.activityName as String?
        
        return cell

    }
    
    @objc func showButtonAction(_ sender: UIButton) {
        let fcModel : FarmerActivitiesModel = arrFarmerTimeLineData.object(at: sender.tag) as! FarmerActivitiesModel
        
        let index = IndexPath(item: sender.tag, section: 0)
        let cell = itemsCollectionView.cellForItem(at: index) as! FarmerTimeLineItemsCollectionViewCell
        self.cellDelegate?.customCell(cell: cell, didTappedshow: sender,object: fcModel)
    }
    
    func customCell(cell: FarmerTimeLineItemsCollectionViewCell, didTappedshow button: UIButton) {
        let fcModel : FarmerActivitiesModel = arrFarmerTimeLineData.object(at: button.tag) as! FarmerActivitiesModel

        self.cellDelegate?.customCell(cell: cell, didTappedshow: button, object: fcModel)
    }

}
