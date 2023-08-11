import UIKit

class DetailViewController: UIViewController {
    
    var imageString: String = ""
    var vcTitle: String = ""
    
    @IBOutlet weak var lockView: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var opentDoorButton: UIButton!
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private let network = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: false)
        let titleColor = UIColor(red: CGFloat(0.2), green: CGFloat(0.2), blue: CGFloat(0.2), alpha: CGFloat(1.0))
        let textAttributes = [NSAttributedString.Key.foregroundColor: titleColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.title = vcTitle
        network.getImage(with: imageString, for: image)
        opentDoorButton.layer.cornerRadius = 15
    }
}
