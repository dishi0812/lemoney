import SwiftUI

struct setupView: View {
    @State var categories: [Category]
    @State var incomeText = ""
    @State var monthlyExpensesText = ""
    @State var budgetGoalsText = ""
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Income: ", text: $incomeText)
                    TextField("Monthly expenses: ", text: $monthlyExpensesText)
                    TextField("Budget goals: ", text: $budgetGoalsText)
                }
                Section {
                    Text("Transport:")
                    Text("Food:")
                    Text("Clothes:")
                    Text("Entertainment:")
                    Text("Stationery:")
                }
            }
            .navigationTitle("Setup")
        }
    }
}

struct setupView_Previews: PreviewProvider {
    static var previews: some View {
        setupView(categories: [
            Category(name: "Transport", expenses: [], budget: 150.00, isStartingCategory: true),
            Category(name: "Food", expenses: [], budget: 150.00, isStartingCategory: true),
            Category(name: "Clothes", expenses: [], budget: 150.00, isStartingCategory: true),
            Category(name: "Entertainment", expenses: [], budget: 150.00, isStartingCategory: true),
            Category(name: "Stationery", expenses: [], budget: 150.00, isStartingCategory: true)
        ])
    }
}
