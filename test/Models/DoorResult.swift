import Foundation

// MARK: - Result
struct DoorResult: Codable {
    let success: Bool
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    let name: String
    let room: String?
    let id: Int
    let favorites: Bool
    let snapshot: String?
}
