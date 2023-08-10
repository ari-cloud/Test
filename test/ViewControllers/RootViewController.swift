import UIKit

class RootViewController: UIViewController {

    @IBOutlet weak var camSegmentView: UIView!
    @IBOutlet weak var doorSegmentView: UIView!
    @IBOutlet weak var camContainer: UIView!
    @IBOutlet weak var doorContainer: UIView!
    
    @IBAction func camButton(_ sender: Any) {
        camSegmentView.backgroundColor = .systemBlue
        doorSegmentView.backgroundColor = .lightGray
        camContainer.isHidden = false
        doorContainer.isHidden = true
    }
    
    @IBAction func doorButton(_ sender: Any) {
        camSegmentView.backgroundColor = .lightGray
        doorSegmentView.backgroundColor = .systemBlue
        camContainer.isHidden = true
        doorContainer.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        camContainer.isHidden = false
        doorContainer.isHidden = true
    }

}

