//
//  AddCategorySheet.swift
//  lemoney
//
//  Created by TinkerTanker on 29/10/22.
//

import SwiftUI

struct AddCategorySheet: View {
    @Binding var categories: [Category]
    var budgetGoal: Double
    var savingsGoal: Double
    var balance: Double
    
    @State var categoryName = ""
    @State var categoryBudget = ""
    
    @State var invalidNameAlert = false
    @State var invalidBudgetAlert = false
    @State var insufficientFundsAlert = false
    @State var isValidName = true
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $categoryName)
                TextField("Budget ($\(String(format: "%.2f", savingsGoal)) Left)", text: $categoryBudget)
            }
            Section {
                Button {
                    for category in categories {
                        if (category.name == categoryName) {
                            isValidName = false
                        }
                    }
                    if (!isValidName) {
                        invalidNameAlert = true
                    } else if ((Double(categoryBudget) ?? (1/5)*savingsGoal) > balance) {
                        insufficientFundsAlert = true
                    } else if ((Double(categoryBudget) ?? (1/5)*savingsGoal) > savingsGoal) {
                        invalidBudgetAlert = true
                    } else {
                        categories.append(Category(name: categoryName, budget: Double(categoryBudget) ?? (1/5)*savingsGoal))
                        presentationMode.wrappedValue.dismiss()
                    }
                } label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Category")
                    }
                }
            }
        }
        .alert("Category Name Already In Use", isPresented: $invalidNameAlert) {
            Button("OK", role: .cancel) {}
        }
        .alert("Unable to meet savings goal with this budget!", isPresented: $invalidBudgetAlert) {
            Button("OK", role: .cancel) {}
            Button("Continue Anyways") {
                categories.append(Category(name: categoryName, budget: Double(categoryBudget) ?? (1/5)*savingsGoal))
                presentationMode.wrappedValue.dismiss()
            }
        }
        .alert("Not enough money for that amount of budget", isPresented: $insufficientFundsAlert) {
            Button("OK", role: .cancel) {}
        }
    }
}

