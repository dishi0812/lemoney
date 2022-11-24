import SwiftUI

struct ExpensesView: View {
    
    var category: Int
    @Binding var userSettings: UserSettings
    @Binding var categories: [Category]
    @Binding var wishlist: [WishlistItem]
    
    @State var deleteAlertShown = false
    @State var expenseId = UUID()
    
    @State var addExpenseSheetShown = false
    @State var editExpenseSheetShown = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            HStack {
                Text("Spendings: $\(String(format: "%.2f", categories[category].spendings))")
                    .fontWeight(.semibold)
                Spacer()
                Text("Left: $\(String(format: "%.2f", categories[category].budget - categories[category].spendings))")
                    .fontWeight(.semibold)
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 40)
            .padding(.vertical, 10)
            
            List {
                if (!categories[category].expenses.isEmpty) {
                    ForEach(categories[category].expenses, id: \.id) { expense in
                        HStack(alignment: .center) {
                            VStack(alignment: .leading) {
                                Text(expense.name)
                                    .fontWeight(.medium)
                                Text("\(expense.date.formatted(.dateTime.hour().minute().weekday().day().month()))")
                                    .opacity(0.6)
                                    .fontWeight(.light)
                            }
                            Spacer()
                            Text("$\(String(format: "%.2f", expense.price))")
                                .font(.title2)
                                .fontWeight(.medium)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
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
                                editExpenseSheetShown = true
                            } label: {
                                Image(systemName: "pencil")
                            }
                            .tint(Color(.systemGray3))
                        }
                        .listRowBackground(colorScheme == .dark ? Color(.systemGray6) : .white)
                    }
                } else {
                    Text("No Expenses")
                        .font(.subheadline)
                        .listRowBackground(colorScheme == .dark ? Color(.systemGray6) : .white)
                }
            }
            .scrollContentBackground(.hidden)
            .background(colorScheme == .dark ? Color(.systemGray6) : .white)
            .navigationTitle(categories[category].name)
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Budget: $\(String(format: "%.2f", categories[category].budget))")
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
            AddExpenseSheet(categoryIndex: category, userSettings: $userSettings, categories: $categories)
        }
        .sheet(isPresented: $editExpenseSheetShown) {
            let expense = categories[category].expenses.first(where: {$0.id == expenseId})!
            EditExpenseSheet(categoryIndex: category, expenseName: expense.name, expensePrice: expense.price, userSettings: $userSettings, categories: $categories, expenseId: expenseId)
        }
        .alert("Are you sure you want to delete this expense?", isPresented: $deleteAlertShown) {
            Button("Delete", role: .destructive) {
                let expense = categories[category].expenses.first(where: { $0.id == expenseId })!
                
                if (categories[category].expenses.first(where: { $0.id == expenseId })!.isFromSetAside) {
                    let wishlistId = expense.wishlistId
                    if (wishlistId != nil) {
                        // deduct from wishlist's set aside and remove from set aside expenses array
                        let wishlistIndex = wishlist.firstIndex(where: { $0.id == wishlistId })!
                        wishlist[wishlistIndex].amtSetAside -= expense.price
                        wishlist[wishlistIndex].setAsideExpenses = wishlist[wishlistIndex].setAsideExpenses.filter { $0 != expense.id }
                    }
                }
                
                userSettings.balance += expense.price
                categories[category].expenses = categories[category].expenses.filter { $0.id != expenseId }
            }
            Button("Cancel", role: .cancel) {}
        }
        .onAppear {
            categories[category].expenses.sort(by: {$0.date.timeIntervalSinceNow > $1.date.timeIntervalSinceNow})
        }
        .background(colorScheme == .dark ? Color(.systemGray6) : .white)
    }
}
