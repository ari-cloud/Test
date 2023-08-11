import UIKit

class CamTableViewCell: UITableViewCell {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var favorites: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view.layer.cornerRadius = 10
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "CamTableViewCell", bundle: nil)
    }
    
}
