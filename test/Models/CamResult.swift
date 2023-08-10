import Foundation

// MARK: - Result
struct CamResult: Codable {
    let success: Bool
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let room: [String]
    let cameras: [Camera]
}

// MARK: - Camera
struct Camera: Codable {
    let name: String
    let snapshot: String
    let room: String?
    let id: Int
    let favorites, rec: Bool
}
