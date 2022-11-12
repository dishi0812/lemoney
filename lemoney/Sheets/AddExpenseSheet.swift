import SwiftUI

struct AddExpenseSheet: View {
    // 'add' mode
    @State var categoryIndex: Int
    @State var expenseName = ""
    @State var expensePrice = Double()
    
    @Binding var categories: [Category]
    @Binding var budgetGoal: Double
    @Binding var savingsGoal: Double
    @Binding var balance: Double
    
    @State var notFilledAlert = false
    @State var invalidValueAlert = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                // inputs
                Section {
                    Picker("Category", selection: $categoryIndex) {
                        ForEach(0 ..< categories.count) { i in
                            Text("\(categories[i].name)")
                        }
                    }
                    .pickerStyle(.menu)
                    TextField("Name", text: $expenseName)
                    
                    TextField("Price", value: $expensePrice, formatter: CurrencyFormatter())
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("New Expense")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        func handleSubmit() -> Void {
                            if (expenseName == "" || expensePrice <= 0) {
                                // alert
                                notFilledAlert = true
                                return
                            }
                            if (expensePrice <= 0.00) {
                                // alert
                                invalidValueAlert = true
                                return
                            }
                            if (expenseName != "" && expensePrice > 0.00) {
                                // add expense
                                categories[categoryIndex].expenses.append(Expense(name: expenseName, price: expensePrice, date: Date(), categoryId: categories[categoryIndex].id))
                                balance -= expensePrice
                                dismiss()
                            }
                        }
                        
                        handleSubmit()
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                                .padding(.trailing, -5)
                                .font(.subheadline)
                            Text("Add")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
            .alert("Please fill in all the blanks", isPresented: $notFilledAlert) {
                Button("OK", role: .cancel) {}
            }
            .alert("Please fill in the 'Price' input with valid values", isPresented: $invalidValueAlert) {
                Button("OK", role: .cancel) {}
            }
        }
    }
}
