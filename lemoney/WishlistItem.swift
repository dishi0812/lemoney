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
    
    var setAsideExpenses: [UUID] = []
    
    var daysLeft: Int {
        if Date().formatted(.dateTime.day().month()) == getDateFromString(date).formatted(.dateTime.day().month()) {
            return 1
        } else {
            return Calendar.current.dateComponents([.day], from: Date(), to: getDateFromString(date)).day! + 2
        }
    }
}
