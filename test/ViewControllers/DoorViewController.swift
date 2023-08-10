import UIKit
import RealmSwift

class DoorViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var doors: Results<Doors>?
    
    private let network = NetworkManager()
    private let storage = StorageManager()
    
    override func viewDidLoad() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.register(DoorTableViewCell.nib(), forCellReuseIdentifier: "doorCell")
        doors = storage.getDoors()
        if ((doors?.isEmpty) != nil) {
            network.getData(DoorResult.self, url: "http://cars.cprogroup.ru/api/rubetek/doors/") { result in
                self.storage.saveDoors(data: result)
            }
        }
        
    }
}

extension DoorViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        doors?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "doorCell", for: indexPath) as? DoorTableViewCell
        else{
            fatalError("TableViewCell is nil")
        }
        cell.name.text = doors?[0].doors[indexPath.row].name ?? ""
        cell.status.isHidden = ((doors?[0].doors[indexPath.row].snapshot.isEmpty) != nil)
        cell.favorites.isHidden = !(doors?[0].doors[indexPath.row].favorites ?? true)
        return cell
    }

}
