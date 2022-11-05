import SwiftUI

struct setupView: View {
    @Binding var categories: [Category]
    @State var incomeText = ""
    @State var monthlyExpensesText = ""
    @State var budgetGoalsText = ""
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Income", text: $incomeText)
                    TextField("Monthly expenses", text: $monthlyExpensesText)
                    TextField("Budget goals", text: $budgetGoalsText)
                }
                Section {
                    ForEach($categories) { $category in
                        HStack {
                            Text("\(category.name)")
                            Spacer()
                            Text("$")
                            TextField("", value: $category.budget, formatter: NumberFormatter())
                                .frame(width: 45, height: 30)
                                .background(Color(.systemGray6))
                                .fontWeight(.bold)
                                .cornerRadius(8)
                        }
                    }
                }
                Button {
                    
                } label: {
                    Text("Start saving money!")
                }
            }
            .navigationTitle("Setup")
        }
    }
}
