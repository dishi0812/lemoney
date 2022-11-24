import SwiftUI

extension AnyTransition {
    static var backslide: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading))}
}

struct SetupView: View {
    
    @Binding var userSettings: UserSettings
    @Binding var categories: [Category]
    
    @State var pageNum: Int
    @State var notSavedAlert = false
    @State var negativeValuesAlert = false
    
    var isFirstLaunch: Bool
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    func checkBudgetGoals() {
        // TODO: check if individual category goals add up to budgetGoal
    }
    
    var body: some View {
        if (pageNum == 2) {
            VStack {
                if (isFirstLaunch) {
                    NavigationView {
                        SetupList(userSettings: $userSettings, categories: $categories, isFirstLaunch: isFirstLaunch)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
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
                                    dismiss()
                                } else {
                                    notSavedAlert = true
                                    return
                                }
                            }
                            checkValues()
                        } label: {
                            Text("Start saving money!")
                                .frame(width: 320)
                                .padding(12)
                                .background(.green)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .font(.headline)
                                .cornerRadius(10)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.bottom, 30)
                        Spacer()
                    }
                } else {
                    SetupList(userSettings: $userSettings, categories: $categories, isFirstLaunch: isFirstLaunch)
                }
            }
            .background(Color(.systemGray6))
            .interactiveDismissDisabled()
            .transition(.backslide)
            .alert("Invalid Values", isPresented: $notSavedAlert) {
                Text("OK")
            } message: {
                Text("Ensure that the budget allocated for the categories corresponds to the budget goal.")
            }
            .alert("Invalid Values", isPresented: $negativeValuesAlert) {
                Text("OK")
            } message: {
                Text("Please ensure that none of the expenses are negative values.")
            }
        }
        
        
        if (pageNum == 1) {
            VStack {
                Text("Welcome to Lemoney")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 70)
                    .padding(.bottom, 50)
                
                HStack {
                    VStack(alignment: .leading, spacing: 40) {
                        HStack {
                            Image(systemName: "dollarsign.circle")
                                .foregroundColor(Color("AccentColor"))
                                .font(.system(size: 40))

                            VStack(alignment: .leading) {
                                Text("Budget Management")
                                    .fontWeight(.bold)
                                Text("Set budget goals to meet your savings targets.")
                                    .fontWeight(.medium)
                                    .opacity(0.4)
                            }
                        }
                        HStack {
                            Image(systemName: "list.star")
                                .foregroundColor(Color("AccentColor"))
                                .font(.system(size: 40))

                            VStack(alignment: .leading) {
                                Text("Wishlist")
                                    .fontWeight(.bold)
                                Text("Save up for items in your needs and wants list.")
                                    .fontWeight(.medium)
                                    .opacity(0.4)
                            }
                        }
                        HStack {
                            Image(systemName: "chart.pie")
                                .foregroundColor(Color("AccentColor"))
                                .font(.system(size: 40))

                            VStack(alignment: .leading) {
                                Text("Statistics")
                                    .fontWeight(.bold)
                                Text("Track your spendings with charts and graphs.")
                                    .fontWeight(.medium)
                                    .opacity(0.4)
                            }
                        }
                    }
                }
                Spacer()
                
                Button {
                    withAnimation(.easeOut(duration: 0.25)) {
                        pageNum = 2
                    }
                } label: {
                    Text("Setup")
                        .frame(width: 320)
                        .padding(12)
                        .background(.green)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.headline)
                        .cornerRadius(10)
                }
                .padding(.bottom, 30)
            }
            .background(Color(.systemGray6))
            .interactiveDismissDisabled()
            .transition(.backslide)
        }
    }
}
 
struct SetupList: View {
    @Binding var userSettings: UserSettings
    @Binding var categories: [Category]
    
    var isFirstLaunch: Bool
    @State var notSavedAlert = false
    @State var savedAlert = false
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        List {
            Section {
                HStack {
                    Text("Monthly Income")
                        .fontWeight(.medium)
                        .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                    
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
                    Text("Current Balance")
                        .fontWeight(.medium).foregroundColor(Color(colorScheme == .dark ? .white : .black))
                    
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
                    Text("Savings Goal")
                        .fontWeight(.medium).foregroundColor(Color(colorScheme == .dark ? .white : .black))
                    
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
                    Text("Budget").fontWeight(.bold)
                    Spacer()
                    Text("$\(String(format: "%.2f", userSettings.budgetGoal))")
                        .fontWeight(.black)
                }
                ForEach($categories) { $category in
                    HStack {
                        Text("\(category.name)")
                            .fontWeight(.medium)
                        
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
        .navigationTitle("Setup")
    }
}
