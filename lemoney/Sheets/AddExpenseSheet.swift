import SwiftUI

struct AddExpenseSheet: View {
    // 'add' mode
    @State var categoryIndex: Int
    @State var expenseName = ""
    @State var expensePrice = Double()
    
    @Binding var userSettings: UserSettings
    @Binding var categories: [Category]
    
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
                            Picker("Category", selection: $categoryIndex) {
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
                    .navigationTitle("New Expense")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                if (expensePrice <= 0.00) {
                                    // alert
                                    invalidValueAlert = true
                                } else {
                                    // add expense
                                    categories[categoryIndex].expenses.append(Expense(name: expenseName == "" ? categories[categoryIndex].name : expenseName, price: expensePrice, date: Date(), categoryId: categories[categoryIndex].id))
                                    userSettings.balance -= expensePrice
                                    dismiss()
                                }
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
                    .alert("Please fill in the 'Price' input with positive values", isPresented: $invalidValueAlert) {
                        Button("OK", role: .cancel) {}
                    }
                }
            }
        }
    }
}
