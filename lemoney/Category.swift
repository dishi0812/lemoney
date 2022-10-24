import Foundation

struct Category: Identifiable {
    var id = UUID()
    
    var name: String;
    var expenses: [Expense] = []
    var spendings: Double
    var budget: Double
}
