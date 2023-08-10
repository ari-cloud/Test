import UIKit

class RootViewController: UIViewController {

    @IBOutlet weak var camSegmentView: UIView!
    @IBOutlet weak var doorSegmentView: UIView!
    
    @IBAction func camButton(_ sender: Any) {
        camSegmentView.backgroundColor = .systemBlue
        doorSegmentView.backgroundColor = .lightGray
    }
    
    @IBAction func doorButton(_ sender: Any) {
        camSegmentView.backgroundColor = .lightGray
        doorSegmentView.backgroundColor = .systemBlue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

