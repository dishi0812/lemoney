import SwiftUI

struct AddExpenseSheet: View {
    // 'add' mode
    @State var categoryIndex: Int
    @State var expenseName = ""
    @State var expensePrice = "5.00"
    @Binding var categories: [Category]
    
    @State var notFilledAlert = false
    @State var invalidValueAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            // inputs
            Section {
                Picker("Category", selection: $categoryIndex, content: {
                    ForEach(0 ..< categories.count, content: { i in
                        Text("\(categories[i].name)")
                    })
                })
                .pickerStyle(.menu)
                TextField("Name", text: $expenseName)
                TextField("Price", text: $expensePrice)
                    .keyboardType(.decimalPad)
            }
            
            // submit button
            Button {
                
                func handleSubmit() -> Void {
                    if (expenseName == "" || expensePrice == "") {
                        // alert
                        notFilledAlert = true
                        return
                    }
                    if (Double(expensePrice)! <= 0.00) {
                        // alert
                        invalidValueAlert = true
                        return
                    }
                    if (expenseName != "" && expensePrice != "") {
                        // add expense
                        categories[categoryIndex].expenses.append(Expense(name: expenseName, price: Double(expensePrice)!))
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                handleSubmit()
            } label: {
                HStack {
                    Image(systemName: "plus")
                        .padding(5)
                        .cornerRadius(2.5)
                    Text("Add Expense")
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
