import Foundation

struct Bottle: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var date: Date = Date()
    var bottleName: String
    var price: String
    var originNote: String
}
