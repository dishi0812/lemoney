import Foundation

struct Expense: Identifiable, Codable {
    var id = UUID()
    
    var name: String
    var price: Double
    var date: Date
}
