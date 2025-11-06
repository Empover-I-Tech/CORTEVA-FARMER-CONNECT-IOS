
import UIKit

open class CA_CropCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cropPhaseTitleLbl: UILabel!
    
    @IBOutlet weak var cropImage: UIImageView!
    @IBOutlet weak var longDurationDaysLbl: UILabel!
    @IBOutlet weak var LongDurationLbl: UILabel!
    @IBOutlet weak var mediumDurationTitleLbl: UILabel!
    @IBOutlet weak var mediumDurationDaysLbl: UILabel!
    @IBOutlet weak var startDurationDaysLbl: UILabel!
    @IBOutlet weak var startDurationTextLbl: UILabel!
    @IBOutlet weak var LongDurationView: UIView!
    @IBOutlet weak var MediumDurationView: UIView!
    @IBOutlet weak var startDurationView: UIView!
    @IBOutlet weak var DaysStackView: UIStackView!
    @IBOutlet weak var longDurationFull: UILabel!
    @IBOutlet weak var mediumDurationFull: UILabel!
    @IBOutlet weak var startDurationFull: UILabel!
    @IBOutlet weak var seperatorOrangDot: UILabel!
    @IBOutlet weak var seperatorLine: UILabel!
}
