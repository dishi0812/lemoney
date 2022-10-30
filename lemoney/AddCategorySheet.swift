//
//  AddCategorySheet.swift
//  lemoney
//
//  Created by TinkerTanker on 29/10/22.
//

import SwiftUI

struct AddCategorySheet: View {
    @Binding var categories: [Category]
    @Binding var budgetGoal: Double
    @Binding var savingsGoal: Double
    @Binding var balance: Double
    
    @State var categoryName = ""
    @State var categoryBudget = ""
    @State var reducedSavings = 0.00
    
    @State var invalidNameAlert = false
    @State var invalidBudgetAlert = false
    @State var insufficientFundsAlert = false
    @State var isValidName = true
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name", text: $categoryName)
                    TextField("Budget ($\(String(format: "%.2f", balance-savingsGoal-budgetGoal)) Left)", text: $categoryBudget)
                }
                Section {
                    Button {
                        isValidName = true
                        for category in categories {
                            if (category.name.lowercased() == categoryName.lowercased()) {
                                isValidName = false
                            }
                        }
                        if (!isValidName) {
                            invalidNameAlert = true
                        } else if (Double(categoryBudget)! > balance - budgetGoal) {
                            insufficientFundsAlert = true
                        } else if (Double(categoryBudget)! > balance - savingsGoal - budgetGoal) {
                            invalidBudgetAlert = true
                            reducedSavings = balance - budgetGoal - (Double(categoryBudget) ?? (1/5)*savingsGoal)
                        } else {
                            categories.append(Category(name: categoryName, budget: Double(categoryBudget) ?? (1/5)*savingsGoal, isStartingCategory: false))
                            budgetGoal += Double(categoryBudget)!
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
            .navigationTitle("New Category")
            .alert("Category Name Already In Use", isPresented: $invalidNameAlert) {
                Button("OK", role: .cancel) {}
            }
            .alert("Unable to meet savings goal with this budget! Savings goal will have to be reduced to $\(reducedSavings) if you continue.", isPresented: $invalidBudgetAlert) {
                Button("OK", role: .cancel) {}
                Button("Continue Anyways") {
                    categories.append(Category(name: categoryName, budget: Double(categoryBudget) ?? (1/5)*savingsGoal, isStartingCategory: false))
                    budgetGoal += Double(categoryBudget) ?? (1/5)*savingsGoal
                    if (budgetGoal + savingsGoal > balance) {
                        savingsGoal = balance - budgetGoal
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .alert("Not enough money for that amount of budget", isPresented: $insufficientFundsAlert) {
                Button("OK", role: .cancel) {}
            }
        }
    }
}

