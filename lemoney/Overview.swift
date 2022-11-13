import Foundation

struct MonthOverview: Identifiable, Codable {
    var id = UUID()
    
    var categories: [String:Double]
    var spendings: Double
    var savings: Double
    var month: String
}
