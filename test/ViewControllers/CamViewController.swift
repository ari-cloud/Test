import UIKit
import RealmSwift

class CamViewController: UIViewController {
    
    var cams : Results<Cams>?
    
    private let network = NetworkManager()
    private let storage = StorageManager()
    
    override func viewDidLoad() {
        cams = storage.getCams()
        guard let cams else { return }
        if cams.isEmpty {
            network.getData(CamResult.self, url: "http://cars.cprogroup.ru/api/rubetek/cameras/") { result in
                self.storage.saveCams(data: result)
            }
        }
    }
}
