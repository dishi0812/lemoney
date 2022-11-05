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
    @State var categoryBudget = 150.00
    @State var reducedSavings = ""
    
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
                    HStack {
                        Text("$")
                            .padding(.trailing, -6)
                        TextField("Budget ($\(String(format: "%.2f", balance-savingsGoal-budgetGoal)) Left)", value: $categoryBudget, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                    }
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
                        } else if (categoryBudget > balance - budgetGoal) {
                            insufficientFundsAlert = true
                        } else if (categoryBudget > balance - savingsGoal - budgetGoal) {
                            invalidBudgetAlert = true
                            reducedSavings = String(format: "%.2f", balance - budgetGoal - categoryBudget)
                        } else {
                            categories.append(Category(name: categoryName, budget: categoryBudget, isStartingCategory: false))
                            budgetGoal += categoryBudget
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
                    categories.append(Category(name: categoryName, budget: categoryBudget, isStartingCategory: false))
                    budgetGoal += categoryBudget
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

