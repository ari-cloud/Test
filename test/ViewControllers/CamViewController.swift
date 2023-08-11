import UIKit
import RealmSwift

class CamViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var cams: Results<Cams>?
    var camsFromNetwork: CamResult?
    var rows = 0
    var sections: [CamSection] = []
    
    private let network = NetworkManager()
    private let storage = StorageManager()
    
    override func viewDidLoad() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.register(CamTableViewCell.nib(), forCellReuseIdentifier: "camCell")
        cams = storage.getCams()
        network.getData(CamResult.self, url: "http://cars.cprogroup.ru/api/rubetek/cameras/") { result in
            DispatchQueue.main.async {
                self.storage.saveCams(data: result)
                self.cams = self.storage.getCams()
                self.camsFromNetwork = result
                self.rows = result.data.cameras.count
                self.getSections()
                self.tableView.reloadData()
            }
        }
    }
    
    private func getSections() {
        if let cams = self.cams, let camsFromNetwork = self.camsFromNetwork {
            var emptySection = CamSection()
            if cams.isEmpty {
                for room in camsFromNetwork.data.room {
                    var section = CamSection(room: room)
                    for cam in camsFromNetwork.data.cameras {
                        if cam.room == room {
                            let cam = Camera(name: cam.name,
                                             snapshot: cam.snapshot,
                                             room: cam.room,
                                             id: cam.id,
                                             favorites: cam.favorites,
                                             rec: cam.rec)
                            section.cams.append(cam)
                        }
                    }
                    self.sections.append(section)
                }
                for cam in cams[0].cams {
                    if cam.room == "" {
                        let cam = Camera(name: cam.name,
                                         snapshot: cam.snapshot,
                                         room: cam.room,
                                         id: cam.id,
                                         favorites: cam.favorites,
                                         rec: cam.rec)
                        emptySection.cams.append(cam)
                    }
                }
                self.sections.append(emptySection)
            } else {
                for room in cams[0].rooms {
                    var section = CamSection(room: room)
                    for cam in cams[0].cams {
                        if cam.room == room {
                            let cam = Camera(name: cam.name,
                                             snapshot: cam.snapshot,
                                             room: cam.room,
                                             id: cam.id,
                                             favorites: cam.favorites,
                                             rec: cam.rec)
                            section.cams.append(cam)
                        }
                    }
                    self.sections.append(section)
                }
                for cam in cams[0].cams {
                    if cam.room == "" {
                        let cam = Camera(name: cam.name,
                                         snapshot: cam.snapshot,
                                         room: cam.room,
                                         id: cam.id,
                                         favorites: cam.favorites,
                                         rec: cam.rec)
                        emptySection.cams.append(cam)
                    }
                }
                self.sections.append(emptySection)
            }
        }
    }
}

extension CamViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "camCell", for: indexPath) as? CamTableViewCell
        else{
            fatalError("TableViewCell is nil")
        }
        let section = sections[indexPath.section].cams
        cell.name.text = section[indexPath.row].name
        cell.favorites.isHidden = !section[indexPath.row].favorites
        network.getImageForCam(with: section[indexPath.row].snapshot, in: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: 70.0))
        view.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1.0)
        let titleLabel = UILabel(frame: CGRect(x: 17.0, y: 0.0, width: view.frame.size.width, height: 17.0))
        titleLabel.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        titleLabel.font = UIFont(name: "Helvetica neue", size: 17)
        titleLabel.text = sections[section].room
        view.addSubview(titleLabel)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favoriteAction = UIContextualAction(style: .destructive, title: nil) { _, _, complete in
            complete(true)
        }
        favoriteAction.image = UIImage(named: "roundStar")
        favoriteAction.backgroundColor = UIColor(red: CGFloat(0.949), green: CGFloat(0.949), blue: CGFloat(0.969), alpha: CGFloat(1.0))
        let configuration = UISwipeActionsConfiguration(actions: [favoriteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = mainStoryboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        vc.imageString = sections[indexPath.section].cams[indexPath.row].snapshot
        vc.vcTitle = sections[indexPath.section].cams[indexPath.row].name
        navigationController?.pushViewController(vc, animated: true)
    }
}


