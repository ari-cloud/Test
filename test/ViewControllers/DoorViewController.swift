import UIKit
import RealmSwift

class DoorViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var doors: Results<Doors>?
    var doorsFromNetwork: DoorResult?
    var rows = 0
    
    private let network = NetworkManager()
    private let storage = StorageManager()
    
    override func viewDidLoad() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.register(DoorTableViewCell.nib(), forCellReuseIdentifier: "doorCell")
        doors = storage.getDoors()
        network.getData(DoorResult.self, url: "http://cars.cprogroup.ru/api/rubetek/doors/") { result in
            DispatchQueue.main.async {
                self.storage.saveDoors(data: result)
                self.doors = self.storage.getDoors()
                self.doorsFromNetwork = result
                self.rows = result.data.count
                self.tableView.reloadData()
            }
        }
    }
}

extension DoorViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "doorCell", for: indexPath) as? DoorTableViewCell
        else{
            fatalError("TableViewCell is nil")
        }
        if let doors = self.doors, let doorsFromNetwork = self.doorsFromNetwork {
            if doors.isEmpty {
                cell.name.text = doorsFromNetwork.data[indexPath.row].name
                cell.status.isHidden = doorsFromNetwork.data[indexPath.row].snapshot?.isEmpty ?? true
                cell.favorites.isHidden = !(doorsFromNetwork.data[indexPath.row].favorites)
                cell.imageView?.isHidden = doorsFromNetwork.data[indexPath.row].snapshot?.isEmpty ?? true
                cell.height.constant = doorsFromNetwork.data[indexPath.row].snapshot?.isEmpty ?? true ?  80 : 290
                if !(doorsFromNetwork.data[indexPath.row].snapshot?.isEmpty ?? false) {
                    network.getImageForDoor(with: doorsFromNetwork.data[indexPath.row].snapshot ?? "", in: cell)
                }
                return cell
            } else {
                cell.name.text = doors[0].doors[indexPath.row].name
                cell.status.isHidden = doors[0].doors[indexPath.row].snapshot.isEmpty
                cell.favorites.isHidden = !(doors[0].doors[indexPath.row].favorites)
                cell.imageView?.isHidden = doors[0].doors[indexPath.row].snapshot.isEmpty
                cell.height.constant = doors[0].doors[indexPath.row].snapshot.isEmpty ?  80 : 290
                if !doors[0].doors[indexPath.row].snapshot.isEmpty {
                    network.getImageForDoor(with: doors[0].doors[indexPath.row].snapshot, in: cell)
                }
                return cell
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let doors = self.doors, let doorsFromNetwork = self.doorsFromNetwork {
            if doors.isEmpty {
                return doorsFromNetwork.data[indexPath.row].snapshot?.isEmpty ?? true ? 90 : 300
            } else {
                return doors[0].doors[indexPath.row].snapshot.isEmpty ? 90 : 300
            }
        }
        return 0
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

