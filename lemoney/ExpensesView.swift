import SwiftUI

struct ExpensesView: View {
    
    var category: Int
    @State var categories: [Category]
    @State var deleteAlertShown = false
    @State var expenseId = UUID()
    
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
                        HStack {
                            Text(expense.name)
                            Spacer()
                            Text("$\(String(format: "%.2f", expense.price))")
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button {
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
            .navigationTitle(categories[category].name)
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Budget: $\(String(format: "%.2f", categories[category].budget))")
                        .fontWeight(.semibold)
                }
            }
        }
        .alert("Are you sure you want to delete this expense?", isPresented: $deleteAlertShown) {
            Button("Delete", role: .destructive) {
                categories[category].expenses = categories[category].expenses.filter { $0.id != expenseId }
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}
