import Foundation

enum WishlistType {
    case need, want
}

struct WishlistItem: Identifiable {
    var id = UUID()
    
    var type: WishlistType
    var name: String
    var price: Double
    var date: Date
    var categoryId: UUID
    var amtSetAside: Double = 0
}
