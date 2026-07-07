import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    static let freeLimit = 12

    @Published var items: [Bottle] = []
    @Published var isPro: Bool = false

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("winetab_items.json")
        load()
    }

    var canAddMore: Bool {
        isPro || items.count < Store.freeLimit
    }

    func add(_ item: Bottle) {
        items.insert(item, at: 0)
        save()
    }

    func update(_ item: Bottle) {
        if let idx = items.firstIndex(where: { $0.id == item.id }) {
            items[idx] = item
            save()
        }
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: Bottle) {
        items.removeAll { $0.id == item.id }
        save()
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([Bottle].self, from: data) else {
            items = Store.seedData()
            save()
            return
        }
        items = decoded
    }

    func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    static func seedData() -> [Bottle] {
        [
        Bottle(date: Date().addingTimeInterval(-86400), bottleName: "Cabernet Reserve", price: "32.00", originNote: "Napa Valley 2019"),
        Bottle(date: Date().addingTimeInterval(-172800), bottleName: "Chianti Classico", price: "18.50", originNote: "Italy 2021"),
        Bottle(date: Date().addingTimeInterval(-259200), bottleName: "Malbec Estate", price: "24.00", originNote: "Argentina 2020")
        ]
    }
}
