//
//  AddExpenseSheet.swift
//  lemoney
//
//  Created by T Krobot on 22/10/22.
//

import SwiftUI

struct AddExpenseSheet: View {
    @State var expenseCategoryIndex: Int
    @State var expenseName = ""
    @State var price = ""
    @State var categories: [Category]
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
                TextField("Price", text: $price)
                    .keyboardType(.decimalPad)
            }
            
            Section {
                Button {
                    if (expenseName != "" && price != "") {
                        categories[expenseCategoryIndex].expenses.append(Expense(name: expenseName, price: Double(price) ?? 5.00))
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
