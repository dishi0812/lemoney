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
    
    var isFirstLaunch: Bool
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    func checkBudgetGoals() {
        
    }
    
    var body: some View {
        if (pageNum == 2) {
            ZStack {
                Color(.systemGray6)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    if (isFirstLaunch) {
                        Text("Setup")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                            .padding(5)
                            .padding(.top, 40)
                    }
                    
                    VStack {
                        HStack {
                            Text("Monthly Income")
                                .fontWeight(.medium).foregroundColor(Color(colorScheme == .dark ? .white : .black))
                            
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
                    .padding(12)
                    .background(Color(colorScheme == .dark ? .systemGray5 : .white))
                    .cornerRadius(12)
                    
                    VStack {
                        VStack {
                            HStack {
                                Text("Budget").fontWeight(.bold)
                                Spacer()
                                Text("$\(String(format: "%.2f", userSettings.budgetGoal))")
                                    .fontWeight(.black)
                            }
                            .padding(.bottom, 8)
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
                        .padding(12)
                        .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                        .background(Color(colorScheme == .dark ? .systemGray5 : .white))
                        .cornerRadius(12)
                    }
                    .padding(.top, 40)
                    
                    Spacer()
                    if (isFirstLaunch) {
                        HStack {
                            Spacer()
                            Button {
                                if (userSettings.income > 0.0 && userSettings.balance > 0.0 && userSettings.savingsGoal > 0.0 && userSettings.budgetGoal > 0.0) {
                                    dismiss()
                                }
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
                            .padding(.bottom, 15)
                            Spacer()
                        }
                    }
                }
                .navigationTitle(isFirstLaunch ? "" : "Profile")
                .padding(15)
            }
            .interactiveDismissDisabled()
            .transition(.backslide)
        }
        
        
        if (pageNum == 1) {
            VStack {
                Text("Welcome to Lemoney")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 70)
                    .padding(.bottom, 50)
                
//                Image("Logo").resizable().clipShape(Circle()).padding().frame(width: 150, height: 150)
//                    .padding(.vertical, -15)
                HStack {
//                    VStack(alignment: .leading) {
//                    }
                    VStack(alignment: .leading, spacing: 25) {
                        HStack(alignment: .top) {
                            Image(systemName: "dollarsign.circle")
                                .foregroundColor(Color("AccentColor"))
                                .font(.system(size: 45))

                            VStack(alignment: .leading) {
                                Text("Budget Management")
                                    .fontWeight(.bold)
                                Text("Set budget goals to meet your savings targets.")
                                    .fontWeight(.medium)
                                    .opacity(0.4)
                            }
                        }
                        HStack(alignment: .top) {
                            Image(systemName: "list.star")
                                .foregroundColor(Color("AccentColor"))
                                .font(.system(size: 45))
//                                .padding(.top, 60)

                            VStack(alignment: .leading) {
                                Text("Wishlist")
                                    .fontWeight(.bold)
//                                    .padding(.top, 25)
                                Text("Save up for items in your needs and wants list.")
                                    .fontWeight(.medium)
                                    .opacity(0.4)
                            }
                        }
                        HStack(alignment: .top) {
                            Image(systemName: "chart.pie")
                                .foregroundColor(Color("AccentColor"))
                                .font(.system(size: 45))
//                                .padding(.top, 60)

                            VStack(alignment: .leading) {
                                Text("Statistics")
                                    .fontWeight(.bold)
//                                    .padding(.top, 25)
                                Text("Track your spendings with charts and graphs.")
                                    .fontWeight(.medium)
                                    .opacity(0.4)
                            }
                        }
                    }
                }

                
                Spacer()
                
                Button {
                    withAnimation(.easeOut(duration: 0.4)) {
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
            .interactiveDismissDisabled()
            .transition(.backslide)
        }
    }
}
