//
//  BudgetView.swift
//  lemoney
//
//  Created by T Krobot on 22/10/22.
//

import SwiftUI

struct BudgetView: View {
    
    @State var categories: [Category]
    @State var addExpenseSheetShown = false
    
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
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button {
                            addExpenseSheetShown = true
                        } label: {
                            Image(systemName: "plus")
                        }
                        .tint(.green)
                    }
                }
                HStack {
                    Text("Total")
                        .fontWeight(.bold)
                    Spacer()
                    Text("$\(String(format: "%.2f", categories.reduce(0) { Double($0) + ($1.budget - $1.spendings) })) Left")
                        .fontWeight(.bold)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        addExpenseSheetShown = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationTitle("Budget")
        }
        .sheet(isPresented: $addExpenseSheetShown) {
            AddExpenseSheet(categories: categories)
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
