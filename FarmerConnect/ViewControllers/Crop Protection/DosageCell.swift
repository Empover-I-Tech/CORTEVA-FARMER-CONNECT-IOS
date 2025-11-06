//
//  DosageCell.swift
//  FarmerConnect
//
//  Created by Empover-i-Tech on 31/03/20.
//  Copyright © 2020 ABC. All rights reserved.
//

import UIKit

class DosageCell: UITableViewCell {
    
    @IBOutlet weak var dosageItemCollectionView :  UICollectionView!
   
    var dosageItems = TableData()
    var arrDosageItems  = [String] ()
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.arryaDosageItems = ["dk" ,"difskfl","djfkj","dfff"]
  
        self.dosageItemCollectionView.delegate = self
        self.dosageItemCollectionView.dataSource = self
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension DosageCell : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrDosageItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = dosageItemCollectionView.dequeueReusableCell(withReuseIdentifier: "dosageItem", for: indexPath) as! DosageItem
            cell.lbl_dosageItem.text = arrDosageItems[indexPath.row]
            return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width/CGFloat(self.arrDosageItems.count), height: 40)
    }
        
    
}
