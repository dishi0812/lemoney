import Foundation

struct Category: Identifiable {
    var id = UUID()
    
    var name: String;
    var expenses: [Expense] = []
    var spendings: Double {
        expenses.reduce(0) { $0 + $1.price }
    }
    var budget: Double
    
    var isStartingCategory: Bool
}
