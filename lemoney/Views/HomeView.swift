import SwiftUI

struct HomeView: View {
    @Binding var userSettings: UserSettings
    @Binding var overviews: [MonthOverview]
    @Binding var categories: [Category]
    @Binding var wishlist: [WishlistItem]
    
    var needsList: [WishlistItem] { wishlist.filter { $0.type == .need } }
    var wantsList: [WishlistItem] { wishlist.filter { $0.type == .want } }
    var totalSpendings: Double {
        categories.reduce(0) { $0 + $1.spendings }
    }
    var savings: Double {
        userSettings.income - totalSpendings
    }
    
    // for budget progress bar
    var totalBudget: Double {
        if (userSettings.budgetGoal <= 0.01) {
            return 325
        } else {
            let val = 325 - totalSpendings / userSettings.budgetGoal * 325
            if val < 0 {
                return 0
            } else if val > 325 {
                return 325
            } else {
                return val
            }
        }
    }
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            VStack {
                
                // budget progress bar
                VStack(alignment: .leading) {
                    Text("BUDGET")
                        .font(.footnote)
                        .fontWeight(.medium)
                        .opacity(0.45)
                        .padding(.leading, 6)
                        .padding(.bottom, -7)
                        .padding(.top, 8)
                    
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color(.systemGray5))
                            .frame(width: 325, height: 25)
                        Rectangle()
                            .fill(Color("AccentColor"))
                            .frame(width: totalBudget, height: 25)
                            .cornerRadius(25, corners: [.topRight, .bottomRight])
                    }
                    .cornerRadius(13)
                }
                .padding(.bottom, -10)
                .padding(.top, -5)
                
                // navigation links
                HStack {
                    Spacer()
                    
                    // Savings Link
                    NavigationLink {
                        SavingsChartView(overviews: overviews, savings: savings >= 0 ? (userSettings.balance - savings) : userSettings.balance, savingsThisMonth: savings)
                    } label: {
                        HStack {
                            Image(systemName: "dollarsign.arrow.circlepath")
                                .font(.title)
                                .padding(.trailing, -3)
                                .padding(.leading, -5)
                            
                            VStack {
                                Text("\(CurrencyFormatter().string(for: Double(savings))!)").fontWeight(.bold)
                                Text("Savings").fontWeight(.semibold)
                            }
                            
                            Image(systemName: "chevron.right")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(Color(.systemGray3))
                        }
                        .padding(10)
                    }
                    .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                    .background(Color(colorScheme == .dark ? .systemGray5 : .white))
                    .cornerRadius(15)
                    
                    Spacer()
                    
                    // All Expenses Link
                    NavigationLink {
                        TotalExpenseView(userSettings: $userSettings, categories: $categories, wishlist: $wishlist, viewOnly: false)
                    } label: {
                        HStack {
                            ZStack {
                                Image(systemName: "dollarsign.circle")
                                    .font(.title)
                                    .padding(.trailing, -3)
                                    .padding(.leading, -5)
                                
                                Image(systemName: "arrow.down")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .padding(.top, 20)
                                    .padding(.leading, 15)
                                    .padding(.trailing, -3)
                            }
                            
                            VStack {
                                Text("\(CurrencyFormatter().string(for: Double(totalSpendings))!)").fontWeight(.bold)
                                Text("Spent").fontWeight(.semibold)
                            }
                            
                            Image(systemName: "chevron.right")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(Color(.systemGray3))
                            
                        }
                        .padding(10)
                    }
                    .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                    .background(Color(colorScheme == .dark ? .systemGray5 : .white))
                    .cornerRadius(15)
                    
                    Spacer()
                }
                .padding(15)
                
                
                // wishlist
                WishlistItemsList(location: "home", userSettings: $userSettings, categories: $categories, wishlist: $wishlist)
                        .padding(.top, -15)
            }
            .background(Color(.systemGray6))
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Balance: \(CurrencyFormatter().string(for: Double(userSettings.balance))!)")
                        .font(.title3)
                        .padding(.top, 10)
                        .fontWeight(.bold)
                }
                ToolbarItem {
                    NavigationLink {
                        // edit profile
                        EditProfileView(userSettings: userSettings, categories: categories, BindingUserSettings: $userSettings, BindingCategories: $categories)
                    } label: {
                        Image(systemName: "person.crop.circle")
                            .font(.title3)
                            .padding(.top, 10)
                            .fontWeight(.bold)
                    }
                }
            }
        }
    }
}
