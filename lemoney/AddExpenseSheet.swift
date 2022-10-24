import SwiftUI

struct AddExpenseSheet: View {
    @State var expenseCategoryIndex: Int
    @State var expenseName = ""
    @State var price = ""
    @Binding var categories: [Category]
    @State var alertShown = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            Section {
                Picker("Category", selection: $expenseCategoryIndex, content: {
                    ForEach(0 ..< categories.count, content: { i in
                        Text("\(categories[i].name)")
                    })
                })
                .pickerStyle(.menu)
                TextField("Expense", text: $expenseName)
                
                // crashes when string entered so fix that somehow
                TextField("Price", text: $price)
                    .keyboardType(.decimalPad)
            }
            
            Section {
                Button {
                    if (expenseName != "" && price != "") {
                        categories[expenseCategoryIndex].expenses.append(Expense(name: expenseName, price: Double(price)!))
                        print("Hello world")
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        alertShown = true
                    }
                } label: {
                    HStack {
                        Image(systemName: "plus")
                            .padding(5)
                            .cornerRadius(2.5)
                        Text("Add")
                    }
                }
            }
        }
        .alert("Please fill in all the blanks", isPresented: $alertShown) {
            Button("OK", role: .cancel) {}
        }
    }
}
