import SwiftUI

struct BudgetView: View {
    
    @State var categories: [Category]
    @State var addExpenseSheetShown = false
    @State var selectedCategory = 0
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach($categories) { $category in
                        NavigationLink {
                            ExpensesView(category: categories.firstIndex(where: {$0.name == category.name})!, categories: categories)
                        } label: {
                            HStack {
                                Text(category.name)
                                Spacer()
                                Text("$\(String(format: "%.2f", category.budget - category.spendings)) Left")
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                selectedCategory = categories.firstIndex(where: {$0.name == category.name}) ?? 0
                                addExpenseSheetShown = true
                            } label: {
                                Image(systemName: "plus")
                            }
                            .tint(.green)
                        }
                    }
                    HStack {
                        Text("Total")
                            .fontWeight(.bold)
                        Spacer()
                        Text("$\(String(format: "%.2f", categories.reduce(0) { Double($0) + ($1.budget - $1.spendings) })) Left")
                            .fontWeight(.bold)
                    }
                } footer: {
                    Text("Swipe right to add an expense, click to view spendings")
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            selectedCategory = 0
                            addExpenseSheetShown = true
                        } label: {
                            Text("Expense")
                        }
                        Button {
                            
                        } label: {
                            Text("Category")
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationTitle("Budget")
        }
        .sheet(isPresented: $addExpenseSheetShown) {
            AddExpenseSheet(expenseCategoryIndex: selectedCategory, categories: $categories)
        }
    }
}

struct BudgetView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetView(categories: [
            Category(name: "Transport", expenses: [], spendings: 123.23, budget: 132.23),
            Category(name: "Food", expenses: [], spendings: 123.23, budget: 132.23),
            Category(name: "Clothes", expenses: [], spendings: 123.23, budget: 132.23),
            Category(name: "Entertainment", expenses: [], spendings: 123.23, budget: 132.23),
            Category(name: "Stationery", expenses: [], spendings: 123.23, budget: 132.23)
        ])
    }
}
