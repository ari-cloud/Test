import Foundation
import RealmSwift

class StorageManager {

    let realm = try! Realm()
    
    func getCams() -> Results<Cams>? {
            return realm.objects(Cams.self)
    }
    
    func saveCams(data: CamResult) {
        let cams = Cams()
        cams.rooms.append(objectsIn: data.data.room) 
        for item in data.data.cameras {
            let cam = Cam(value: [item.name,
                                  item.snapshot,
                                  item.room ?? "",
                                  item.id,
                                  item.favorites,
                                  item.rec])
            cams.cams.append(cam)
        }
        DispatchQueue.main.async { [self] in
            try? self.realm.write { () -> Void in
                self.realm.add(cams)
            }
        }
    }
    
    func getDoors() -> Results<Doors>? {
            return realm.objects(Doors.self)
    }
    
    func saveDoors(data: DoorResult) {
        let doors = Doors()
        for item in data.data {
            let door = Door(value: [item.name,
                                    item.room ?? "",
                                    item.id,
                                    item.favorites,
                                    item.snapshot ?? ""])
            doors.doors.append(door)
        }
        DispatchQueue.main.async { [self] in
            try? self.realm.write { () -> Void in
                self.realm.add(doors)
            }
        }
    }
}

class Cams: Object {
    let rooms = List<String>()
    let cams = List<Cam>()
}

class Cam: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var snapshot: String = ""
    @objc dynamic var room: String = ""
    @objc dynamic var id: Int = 0
    @objc dynamic var favorites: Bool = false
    @objc dynamic var rec: Bool = false
}

class Doors: Object {
    let doors = List<Door>()
}

class Door: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var room: String = ""
    @objc dynamic var id: Int = 0
    @objc dynamic var favorites: Bool = false
    @objc dynamic var snapshot: String = ""
}
