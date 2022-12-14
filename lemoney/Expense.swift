import Foundation

struct Expense: Identifiable, Codable {
    var id = UUID()
    
    var name: String
    var price: Double
    var date: Date
    var categoryId: UUID
    
    var isFromSetAside = false
    var wishlistId: UUID? = nil
}
