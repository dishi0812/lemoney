import Foundation

enum WishlistType {
    case need, want
}

struct WishlistItem {
    var type: WishlistType
    var name: String
    var price: Double
    var date: Date
    var category: Category
}
