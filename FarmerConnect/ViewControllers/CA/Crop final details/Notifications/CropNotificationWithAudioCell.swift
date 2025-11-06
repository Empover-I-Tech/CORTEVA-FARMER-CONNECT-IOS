//
//  CropNotificationWithAudioCell.swift
//  FarmerConnect
//
//  Created by Empover on 08/01/18.
//  Copyright © 2018 ABC. All rights reserved.
//

import UIKit

open class CropNotificationWithAudioCell: UITableViewCell {
    
    @IBOutlet weak var lblSentOn: UILabel!
    
    @IBOutlet weak var lblNumOfDays: UILabel!
    
    @IBOutlet weak var lblStage: UILabel!
    
    @IBOutlet weak var lblExpectedDate: UILabel!
    
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet weak var lblMsgInLocalLang: UILabel!
    
    @IBOutlet weak var playPauseBtn: UIButton!
    
    convenience init() {
        self.init()
        playPauseBtn = UIButton()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
