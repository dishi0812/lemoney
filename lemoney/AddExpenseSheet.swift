//
//  AddExpenseSheet.swift
//  lemoney
//
//  Created by T Krobot on 22/10/22.
//

import SwiftUI

struct AddExpenseSheet: View {
    @State var expenseCategoryIndex = 0
    @State var expenseName = ""
    @State var price = 0
    @State var categories: [Category]
    
    var body: some View {
        Form {
            Picker("Category", selection: $expenseCategoryIndex, content: {
                ForEach(0 ..< categories.count, content: { i in
                    Text("\(categories[i].name)")
                })
            })
            TextField("Expense", text: $expenseName)
            TextField("Price", text: $expenseName)
                .keyboardType(.decimalPad)
            
        }
    }
}
