import SwiftUI

struct TotalExpenseView: View {
    @Binding var categories: [Category]
    @State var deleteAlertShown = false
    
    @State var categoryId = UUID()
    @State var expenseId = UUID()
    
    @State var addExpenseSheetShown = false
    
    @State var totalSpendings: Double
    @Binding var budgetGoal: Double
    @Binding var savingsGoal: Double
    @Binding var balance: Double
    
    @State var allExpenses: [Expense] = []
    
    var body: some View {
        VStack {
            HStack {
                Text("Spendings: $\(String(format: "%.2f", totalSpendings))")
                    .fontWeight(.semibold)
                Spacer()
                Text("Left: $\(String(format: "%.2f", budgetGoal - totalSpendings))")
                    .fontWeight(.semibold)
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 40)
            .padding(.vertical, 10)
            
            List {
                if (!allExpenses.isEmpty) {
                    ForEach(allExpenses, id: \.id) { expense in
                        VStack(alignment: .trailing) {
                            HStack {
                                Text(expense.name)
                                Spacer()
                                Text("$\(String(format: "%.2f", expense.price))")
                            }
                            HStack {
                                Text("\(expense.date.formatted(.dateTime.hour().minute().weekday().day().month()))")
                                    .opacity(0.8)
                                    .fontWeight(.light)
                                
                                Spacer()
                                Text("\(categories.first(where: { $0.id == expense.categoryId })!.name)")
                                    .fontWeight(.light)
                                    .opacity(0.8)
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button {
                                categoryId = expense.categoryId
                                expenseId = expense.id
                                deleteAlertShown = true
                            } label: {
                                Image(systemName: "trash")
                            }
                            .tint(.red)
                        }
                    }
                } else {
                    Text("No Expenses")
                        .font(.subheadline)
                }
            }
            .navigationTitle("All Expenses")
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Budget: $\(String(format: "%.2f", budgetGoal))")
                        .fontWeight(.semibold)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        addExpenseSheetShown = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $addExpenseSheetShown) {
            AddExpenseSheet(categoryIndex: 0, categories: $categories, budgetGoal: $budgetGoal, savingsGoal: $savingsGoal, balance: $balance)
        }
//        .alert("Are you sure you want to delete this expense?", isPresented: $deleteAlertShown) {
//            Button("Delete", role: .destructive) {
//                let categoryIndex = categories.firstIndex(where: {$0.id == categoryId})!
//                let value = categories[categoryIndex].expenses.first(where: { $0.id == expenseId })!.price
//                balance += value
//                totalSpendings -= value
//                categories[categoryIndex].expenses = categories[categoryIndex].expenses.filter { $0.id != expenseId }
//                allExpenses = categories.reduce([]) { $0 + $1.expenses }
//                allExpenses = allExpenses.sorted(by: { $0.date.timeIntervalSince1970 > $1.date.timeIntervalSince1970 })
//            }
//            Button("Cancel", role: .cancel) {}
//        }
//        .onChange(of: categories) {
//            allExpenses = categories.reduce([]) { $0 + $1.expenses }
//            allExpenses = allExpenses.sorted(by: { $0.date.timeIntervalSince1970 > $1.date.timeIntervalSince1970 })
//        }
    }
}