import Foundation

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
}
