import Foundation

struct MonthOverview: Identifiable, Codable {
    var id = UUID()
    
    var categories: [String:Double]
    var savings: Double
    var spendings: Double {
        var total: Double = 0
        for (_, value) in categories {
            total += value
        }
        total -= savings
        return total
    }
    var month: String
}
