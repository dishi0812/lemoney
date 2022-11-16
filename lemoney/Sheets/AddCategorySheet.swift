////
////  AddCategorySheet.swift
////  lemoney
////
////  Created by TinkerTanker on 29/10/22.
////
//
//import SwiftUI
//
//struct AddCategorySheet: View {
//    @Binding var userSettings: [String:Double]
//    @Binding var categories: [Category]
//
//    @State var categoryName = ""
//    @State var categoryBudget = 150.00
//    @State var reducedSavings = ""
//
//    @State var invalidNameAlert = false
//    @State var invalidBudgetAlert = false
//    @State var insufficientFundsAlert = false
//    @State var isValidName = true
//
//    @Environment(\.dismiss) var dismiss
//
//    var body: some View {
//        NavigationView {
//            Form {
//                Section {
//                    TextField("Name", text: $categoryName)
//                    TextField("Budget ($\(String(format: "%.2f", userSettings["balance"]!-userSettings["savingsGoal"]!-userSettings["budgetGoal"]!)) Left)", value: $categoryBudget, formatter: CurrencyFormatter())
//                        .keyboardType(.decimalPad)
//                }
//            }
//            .navigationTitle("New Category")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button {
//                        isValidName = true
//                        for category in categories {
//                            if (category.name.lowercased() == categoryName.lowercased()) {
//                                isValidName = false
//                            }
//                        }
//                        if (!isValidName) {
//                            invalidNameAlert = true
//                        } else if (categoryBudget > userSettings["balance"]! - userSettings["budgetGoal"]!) {
//                            insufficientFundsAlert = true
//                        } else if (categoryBudget > userSettings["balance"]! - userSettings["savingsGoal"]! - userSettings["budgetGoal"]!) {
//                            invalidBudgetAlert = true
//                            reducedSavings = String(format: "%.2f", userSettings["balance"]! - userSettings["budgetGoal"]! - categoryBudget)
//                        } else {
//                            categories.append(Category(name: categoryName, budget: categoryBudget, isStartingCategory: false))
//                            userSettings["budgetGoal"]! += categoryBudget
//                            dismiss()
//                        }
//                    } label: {
//                        HStack {
//                            Image(systemName: "plus")
//                                .padding(.trailing, -5)
//                                .font(.subheadline)
//                            Text("Add")
//                        }
//                    }
//                }
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button {
//                        dismiss()
//                    } label: {
//                        Text("Cancel")
//                    }
//                }
//            }
//            .alert("Category Name Already In Use", isPresented: $invalidNameAlert) {
//                Button("OK", role: .cancel) {}
//            }
//            .alert("Unable to meet savings goal with this budget! Savings goal will have to be reduced to $\(reducedSavings) if you continue.", isPresented: $invalidBudgetAlert) {
//                Button("OK", role: .cancel) {}
//                Button("Continue Anyways") {
//                    categories.append(Category(name: categoryName, budget: categoryBudget, isStartingCategory: false))
//                    userSettings["budgetGoal"]! += categoryBudget
//                    if (userSettings["budgetGoal"]! + userSettings["savingsGoal"]! > userSettings["balance"]!) {
//                        userSettings["savingsGoal"]! = userSettings["balance"]! - userSettings["budgetGoal"]!
//                    }
//                    dismiss()
//                }
//            }
//            .alert("Not enough money for that amount of budget", isPresented: $insufficientFundsAlert) {
//                Button("OK", role: .cancel) {}
//            }
//        }
//    }
//}
//
