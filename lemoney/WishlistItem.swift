import Foundation

enum WishlistType: Codable {
    case need, want
}

struct WishlistItem: Identifiable, Codable {
    var id = UUID()
    
    var type: WishlistType
    var name: String
    var price: Double
    var date: String
    var categoryId: UUID
    var amtSetAside: Double = 0
}
