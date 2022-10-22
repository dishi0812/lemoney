//
//  BudgetView.swift
//  lemoney
//
//  Created by T Krobot on 22/10/22.
//

import SwiftUI

struct BudgetView: View {
    
    @State var categories: [Category]
    
    var body: some View {
        NavigationView {
            List {
                ForEach($categories) { $category in
                    NavigationLink {
                        ExpensesView()
                    } label: {
                        HStack {
                            Text(category.name)
                            Spacer()
                            Text("$\(String(format: "%.2f", category.budget - category.spendings)) Left")
                        }
                    }
                }
            }
            .navigationTitle("Budget")
        }
    }
}

struct BudgetView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetView(categories: [
            Category(name: "Transport", expenses: [], spendings: 123.23, budget: 132.23),
            Category(name: "Food", expenses: [], spendings: 123.23, budget: 132.23),
            Category(name: "Clothes", expenses: [], spendings: 123.23, budget: 132.23),
            Category(name: "Entertainment", expenses: [], spendings: 123.23, budget: 132.23),
            Category(name: "Stationery", expenses: [], spendings: 123.23, budget: 132.23)
        ])
    }
}
