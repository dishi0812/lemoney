//
//  EditProfileView.swift
//  lemoney
//
//  Created by TinkerTanker on 24/11/22.
//

import SwiftUI

struct EditProfileView: View {
    @State var userSettings: UserSettings
    @State var categories: [Category]
    
    @Binding var BindingUserSettings: UserSettings
    @Binding var BindingCategories: [Category]
    
    @State var savedAlert = false
    @State var notSavedAlert = false
    @State var negativeValuesAlert = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        List {
            Section {
                HStack {
                    if (userSettings.income == BindingUserSettings.income) {
                        Text("Monthly Income")
                            .fontWeight(.medium)
                            .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                    } else {
                        Text("Monthly Income*")
                            .fontWeight(.medium)
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                    HStack {
                        TextField("", value: $userSettings.income, formatter: CurrencyFormatter())
                            .padding(.leading, 3)
                    }
                    .frame(width: 93, height: 30)
                    .background(Color(.systemGray6))
                    .fontWeight(.bold)
                    .cornerRadius(8)
                }
                
                HStack {
                    if (userSettings.balance == BindingUserSettings.balance) {
                        Text("Current Balance")
                            .fontWeight(.medium).foregroundColor(Color(colorScheme == .dark ? .white : .black))
                    } else {
                        Text("Current Balance*")
                            .fontWeight(.medium).foregroundColor(.red)
                    }
                    
                    Spacer()
                    HStack {
                        TextField("", value: $userSettings.balance, formatter: CurrencyFormatter())
                            .padding(.leading, 3)
                    }
                    .frame(width: 93, height: 30)
                    .background(Color(.systemGray6))
                    .fontWeight(.bold)
                    .cornerRadius(8)
                }
                
                HStack {
                    if (userSettings.savingsGoal == BindingUserSettings.savingsGoal) {
                        Text("Savings Goal")
                            .fontWeight(.medium).foregroundColor(Color(colorScheme == .dark ? .white : .black))
                    } else {
                        Text("Savings Goal*")
                            .fontWeight(.medium).foregroundColor(.red)
                    }
                    
                    Spacer()
                    HStack {
                        TextField("", value: $userSettings.savingsGoal, formatter: CurrencyFormatter())
                            .onChange(of: userSettings.savingsGoal) { val in
                                userSettings.budgetGoal = userSettings.income - userSettings.savingsGoal
                            }
                            .onChange(of: userSettings.income) { val in
                                userSettings.savingsGoal = val / Double(categories.count)
                                userSettings.budgetGoal = userSettings.income - userSettings.savingsGoal
                            }   
                            .padding(.leading, 3)
                    }
                    .frame(width: 93, height: 30)
                    .background(Color(.systemGray6))
                    .fontWeight(.bold)
                    .cornerRadius(8)
                }
            }
            .listRowBackground(colorScheme == .dark ? Color(.systemGray5) : .white)
            
            
            Section {
                HStack {
                    if (userSettings.budgetGoal == BindingUserSettings.budgetGoal) {
                        Text("Budget")
                            .fontWeight(.medium).foregroundColor(Color(colorScheme == .dark ? .white : .black))
                    } else {
                        Text("Budget*")
                            .fontWeight(.medium).foregroundColor(.red)
                    }
                    
                    Spacer()
                    Text("\(CurrencyFormatter().string(for: Double(userSettings.budgetGoal))!)")
                        .fontWeight(.black)
                }
                ForEach($categories) { $category in
                    HStack {
                        let categoryIndex = categories.firstIndex(where: { $0.id == category.id })!
                        
                        if (categories[categoryIndex].budget == BindingCategories[categoryIndex].budget) {
                            Text("\(category.name)")
                                .fontWeight(.medium).foregroundColor(Color(colorScheme == .dark ? .white : .black))
                        } else {
                            Text("\(category.name)*")
                                .fontWeight(.medium).foregroundColor(.red)
                        }
                        
                        Spacer()
                        HStack {
                            TextField("", value: $category.budget, formatter: CurrencyFormatter())
                                .onChange(of: userSettings.budgetGoal) { value in
                                    category.budget = Double(value)/5.0
                                }
                                .padding(.horizontal, 4)
                        }
                        .frame(width: 93, height: 30)
                        .background(Color(.systemGray6))
                        .fontWeight(.bold)
                        .cornerRadius(8)
                    }
                }
            }
            .listRowBackground(colorScheme == .dark ? Color(.systemGray5) : .white)
            .foregroundColor(Color(colorScheme == .dark ? .white : .black))
        
        }
        .scrollContentBackground(.hidden)
        .background(Color(.systemGray6))
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    func checkValues() {
                        if (userSettings.income < 0.0 && userSettings.balance < 0.0 && userSettings.savingsGoal < 0.0 && userSettings.budgetGoal < 0.0 && categories.reduce(0) { $0 + $1.budget } < 0.0) {
                            negativeValuesAlert = true
                            return
                        }
                        for category in categories {
                            if category.budget < 0.0 {
                                negativeValuesAlert = true
                                return
                            }
                        }
                        if (userSettings.budgetGoal == categories.reduce(0) { $0 + $1.budget }) {
                            savedAlert = true
                            BindingUserSettings = userSettings
                            BindingCategories = categories
                        } else {
                            notSavedAlert = true
                            return
                        }
                    }
                    checkValues()
                } label: {
                    Text("Save")
                }
            }
        }
        .alert("Invalid Values", isPresented: $notSavedAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Ensure budget allocated for the categories add up to the budget goal.")
        }
        .alert("Invalid Values", isPresented: $negativeValuesAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please ensure that none of the expenses are negative values.")
        }
        .alert("Saved successfully", isPresented: $savedAlert) {
            Button("OK", role: .cancel) {}
        }
    }
}
