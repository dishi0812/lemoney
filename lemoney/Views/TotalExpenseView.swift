import SwiftUI

struct TotalExpenseView: View {
    
    @Binding var userSettings: UserSettings
    @Binding var categories: [Category]
    @Binding var wishlist: [WishlistItem]
    var viewOnly: Bool
    @State var deleteAlertShown = false
    
    @State var categoryId = UUID()
    @State var expenseId = UUID()
    
    @State var addExpenseSheetShown = false
    @State var editExpenseSheetShown = false
    
    var totalSpendings: Double {
        categories.reduce(0) { $0 + $1.spendings }
    }
    
    var allExpenses: [Expense] { categories.reduce([]) {$0 + $1.expenses}.sorted(by: { $0.date.timeIntervalSince1970 > $1.date.timeIntervalSince1970 }) }
    
    func categoryIndexFromId(_ id: UUID) -> Int {
        return categories.firstIndex(where: { $0.id == id })!
    }
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            HStack {
                Text("Spendings: $\(String(format: "%.2f", totalSpendings))")
                    .fontWeight(.semibold)
                Spacer()
                Text("Left: $\(String(format: "%.2f", userSettings.budgetGoal - totalSpendings))")
                    .fontWeight(.semibold)
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 40)
            .padding(.vertical, 10)
            
            List {
                if (!allExpenses.isEmpty) {
                    if (!viewOnly) {
                        ForEach(allExpenses, id: \.id) { expense in
                            VStack(alignment: .trailing) {
                                HStack {
                                    Text(expense.name).fontWeight(.medium)
                                    Spacer()
                                    Text("$\(String(format: "%.2f", expense.price))").fontWeight(.medium)
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
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button {
                                    categoryId = expense.categoryId
                                    expenseId = expense.id
                                    deleteAlertShown = true
                                } label: {
                                    Image(systemName: "trash")
                                }
                                .tint(.red)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button {
                                    expenseId = expense.id
                                    categoryId = expense.categoryId
                                    editExpenseSheetShown = true
                                } label: {
                                    Image(systemName: "pencil")
                                }
                                .tint(Color(.systemGray3))
                            }
                            .alert("Are you sure you want to delete this expense?", isPresented: $deleteAlertShown) {
                                Button("Delete", role: .destructive) {
                                    let categoryIndex = categories.firstIndex(where: { $0.id == expense.categoryId })!
                                    let expense = categories[categoryIndex].expenses.first(where: { $0.id == expenseId })!
                                    
                                    if (categories[categoryIndex].expenses.first(where: { $0.id == expenseId })!.isFromSetAside) {
                                        let wishlistId = expense.wishlistId
                                        if (wishlistId != nil) {
                                            // deduct from wishlist's set aside and remove from set aside expenses array
                                            let wishlistIndex = try? wishlist.firstIndex(where: { $0.id == wishlistId })
                                            if (wishlistIndex != nil) {
                                                wishlist[wishlistIndex!].amtSetAside -= expense.price
                                                wishlist[wishlistIndex!].setAsideExpenses = wishlist[wishlistIndex!].setAsideExpenses.filter { $0 != expense.id }
                                            }
                                        }
                                    }
                                    
                                    userSettings.balance += expense.price
                                    categories[categoryIndex].expenses = categories[categoryIndex].expenses.filter { $0.id != expenseId }
                                }
                                Button("Cancel", role: .cancel) {}
                            }
                            .listRowBackground(colorScheme == .dark ? Color(.systemGray6) : .white)
                        }
                    } else {
                        ForEach(allExpenses, id: \.id) { expense in
                            VStack(alignment: .trailing) {
                                HStack {
                                    Text(expense.name).fontWeight(.medium)
                                    Spacer()
                                    Text("$\(String(format: "%.2f", expense.price))").fontWeight(.medium)
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
                            .listRowBackground(colorScheme == .dark ? Color(.systemGray6) : .white)
                        }
                    }
                } else {
                    Text("No Expenses")
                        .font(.subheadline)
                        .listRowBackground(colorScheme == .dark ? Color(.systemGray6) : .white)
                }
            }
            .scrollContentBackground(.hidden)
            .background(colorScheme == .dark ? Color(.systemGray6) : .white)
            .navigationTitle("All Expenses")
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Budget: $\(String(format: "%.2f", userSettings.budgetGoal))")
                        .fontWeight(.semibold)
                }
                if (!viewOnly) {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            addExpenseSheetShown = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
        .background(colorScheme == .dark ? Color(.systemGray6) : .white)
        .sheet(isPresented: $addExpenseSheetShown) {
            AddExpenseSheet(categoryIndex: 0, userSettings: $userSettings , categories: $categories)
        }
        .sheet(isPresented: $editExpenseSheetShown) {
            let expense = categories[categoryIndexFromId(categoryId)].expenses.first(where: {$0.id == expenseId})!
            EditExpenseSheet(categoryIndex: categoryIndexFromId(categoryId), expenseName: expense.name, expensePrice: expense.price, userSettings: $userSettings, categories: $categories, expenseId: expenseId)
        }
    }
}
