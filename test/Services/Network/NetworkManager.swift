import Foundation
import UIKit

class NetworkManager {
    let sessionConfiguration = URLSessionConfiguration.default
    let session = URLSession.shared
    let decoder  = JSONDecoder()
    
    func getData<T: Codable>(_ t: T.Type, url: String, succesCompletion: @escaping (T) -> Void){
        guard let url = URL(string: url) else { return }
        session.dataTask(with: url) { [weak self] data, response, error in
            guard let self else { return }
            if error == nil, let parsData = data {
                guard let data = try? self.decoder.decode(T.self, from: parsData) else {
                    return
                }
                succesCompletion(data)
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }.resume()
    }
    
    func getImageForCam(with url: String, in cell: CamTableViewCell) {
        guard let url = URL(string: url) else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    cell.cellImage.image = UIImage(data: data)
                }
            }
        }
    }
    
    func getImageForDoor(with url: String, in cell: DoorTableViewCell) {
        guard let url = URL(string: url) else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    cell.cellImage.image = UIImage(data: data)
                }
            }
        }
    }
    
    func getImage(with url: String, for image: UIImageView) {
        guard let url = URL(string: url) else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    image.image = UIImage(data: data)
                }
            }
        }
    }
}
