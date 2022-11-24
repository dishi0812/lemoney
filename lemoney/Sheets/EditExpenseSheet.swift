import SwiftUI

struct EditExpenseSheet: View {
    // 'add' mode
    let categoryIndex: Int
    @State var editedCategoryIndex = 0
    @State var expenseName: String
    @State var expensePrice: Double
    
    @Binding var userSettings: UserSettings
    @Binding var categories: [Category]
    var expenseId: UUID
    
    @State var notFilledAlert = false
    @State var invalidValueAlert = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGray6)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Form {
                        // inputs
                        Section {
                            Picker("Category", selection: $editedCategoryIndex) {
                                ForEach(0 ..< categories.count) { i in
                                    Text("\(categories[i].name)")
                                }
                            }
                            .pickerStyle(.menu)
                            TextField("Name", text: $expenseName)
                            
                            // TODO: Add dollarsign behind double if there isn't one
                            TextField("Price", value: $expensePrice, formatter: CurrencyFormatter())
                                .keyboardType(.decimalPad)
                        }
                    }
                    .navigationTitle("Edit Expense")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                if (expensePrice <= 0.00) {
                                    // alert
                                    invalidValueAlert = true
                                    return
                                }

                                let oldDate = categories[categoryIndex].expenses.first(where: { $0.id == expenseId })!.date
                                let oldId = categories[categoryIndex].expenses.first(where: {$0.id == expenseId})!.id
                                
                                // delete expense in original category
                                userSettings.balance += categories[categoryIndex].expenses.first(where: { $0.id == expenseId })!.price
                                categories[categoryIndex].expenses = categories[categoryIndex].expenses.filter { $0.id != expenseId }
                                
                                // add edited expense in original category if left unchanged or category moved into (totally very effective way to edit expense, but it works)
                                categories[editedCategoryIndex].expenses.append(Expense(id: oldId, name: expenseName != "" ? expenseName : categories[editedCategoryIndex].name, price: expensePrice, date: oldDate, categoryId: categories[editedCategoryIndex].id))
                                userSettings.balance -= expensePrice
                                
                                dismiss()
                            
                            } label: {
                                Text("Done")
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
                    .alert("Fill in all the fields!", isPresented: $notFilledAlert) {
                        Button("OK", role: .cancel) {}
                    }
                    .alert("Price value is invalid!", isPresented: $invalidValueAlert) {
                        Button("OK", role: .cancel) {}
                    }
                }
            }
            .onAppear {
                editedCategoryIndex = categoryIndex
            }
        }
    }
}
