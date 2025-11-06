//
//  FarmerTimeLineSmallCollectionViewCell.swift
//  PioneerEmployee
//
//  Created by Admin on 27/08/19.
//  Copyright © 2019 Empover. All rights reserved.
//

import UIKit
import Kingfisher

class FarmerTimeLineSmallCollectionViewCell: UICollectionViewCell,UICollectionViewDelegate,UICollectionViewDataSource {
   
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    var arrFarmerTimeLineData : NSArray = NSArray()
    
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
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewItemCell", for: indexPath)
        let fcModel = arrFarmerTimeLineData.object(at: indexPath.row) as? FarmerActivitiesModel
        
        let lblTop = cell.contentView.viewWithTag(100) as! UILabel
        let imgView = cell.contentView.viewWithTag(101) as! UIImageView
        let lblBottom = cell.contentView.viewWithTag(102) as! UILabel
        
        let imageUrl = URL(string: fcModel?.activityImage as String? ?? "" )
        
        DispatchQueue.main.async{
            imgView.kf.setImage(with: imageUrl as Resource?, placeholder: UIImage(named:"image_placeholder.png"), options: nil, progressBlock: nil)
        }
        
        lblTop.text = fcModel?.activityType as String?
        lblBottom.text = fcModel?.activityName as String?
        
        return cell
        
    }
    

}
