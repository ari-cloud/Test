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
        guard let doors else { return }
        if doors.isEmpty {
            network.getData(DoorResult.self, url: "http://cars.cprogroup.ru/api/rubetek/doors/") { result in
                self.storage.saveDoors(data: result)
                self.doors = self.storage.getDoors()
            }
        }
    }
}

extension DoorViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let doors else { return 0}
        return doors[0].doors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "doorCell", for: indexPath) as? DoorTableViewCell
        else{
            fatalError("TableViewCell is nil")
        }
        guard let doors else { return cell }
        cell.name.text = doors[0].doors[indexPath.row].name
        cell.status.isHidden = doors[0].doors[indexPath.row].snapshot.isEmpty
        cell.favorites.isHidden = !(doors[0].doors[indexPath.row].favorites)
        cell.imageView?.isHidden = doors[0].doors[indexPath.row].snapshot.isEmpty
        cell.height.constant = doors[0].doors[indexPath.row].snapshot.isEmpty ?  80 : 290
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let doors else { return 75 }
        return doors[0].doors[indexPath.row].snapshot.isEmpty ? 90 : 300
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .destructive, title: nil) { _, _, complete in
            complete(true)
        }
        editAction.image = UIImage(named: "edit")
        editAction.backgroundColor = UIColor(red: CGFloat(0.949), green: CGFloat(0.949), blue: CGFloat(0.969), alpha: CGFloat(1.0))
        let favoriteAction = UIContextualAction(style: .destructive, title: nil) { _, _, complete in
            complete(true)
        }
        favoriteAction.image = UIImage(named: "roundStar")
        favoriteAction.backgroundColor = UIColor(red: CGFloat(0.949), green: CGFloat(0.949), blue: CGFloat(0.969), alpha: CGFloat(1.0))
        let configuration = UISwipeActionsConfiguration(actions: [editAction, favoriteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }

}
