import SwiftUI

struct HomeView: View {
    
    @State var needBoughtAlertShown = false
    @State var wishlistItemId = UUID()
    var item: WishlistItem? {
        needsList.first(where: {$0.id == wishlistItemId}) ?? nil
    }
    
    @State var type = Int()
    @State var addItemSheetShown = false

    @Binding var userSettings: [String:Double]
    @Binding var overviews: [MonthOverview]
    @Binding var categories: [Category]
    @Binding var wishlist: [WishlistItem]
    
    var needsList: [WishlistItem] { wishlist.filter { $0.type == .need } }
    var wantsList: [WishlistItem] { wishlist.filter { $0.type == .want } }
    
    var totalSpendings: Double {
        categories.reduce(0) { $0 + $1.spendings }
    }
    var savings: Double {
        userSettings["income"]! - totalSpendings
    }
    @Environment(\.colorScheme) var colorScheme
    
    func wantProgressWidth(itemValue: Double) -> Double {
        let width = savings >= 0 ? (userSettings["balance"]! - savings) / itemValue * 325 : userSettings["balance"]! / itemValue * 325
        if (width > 325) {
            return 325
        } else if (width < 0) {
            return 0
        } else {
            return width
        }
    }
    func needProgressWidth(item: WishlistItem) -> Double{
        let width = item.setAsideAmt >= 0 ? (userSettings["balance"]! - item.setAsideAmt) / item.price * 325 : userSettings["balance"]! / item.price * 325
        if (width > 325) {
            return 325
        } else if (width < 0) {
            return 0
        } else {
            return width
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGray6)
                    .edgesIgnoringSafeArea(.all)
                
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
                                .frame(width: 350, height: 25)
                                .cornerRadius(13)
                                .padding(.bottom, 10)
                            Rectangle()
                                .fill(Color("AccentColor"))
                                .frame(width: 350 - (totalSpendings/userSettings["budgetGoal"]!*350) < 0 ? 0 : 350 - (totalSpendings/userSettings["budgetGoal"]!*350), height: 25)
                                .cornerRadius(13)
                                .padding(.bottom, 10)
                        }
                    }
                    .padding(.bottom, -20)
                    .padding(.top, -12)
                    
                    // navigation links
                    HStack {
                        Spacer()
                        
                        NavigationLink {
                            SavingsChartView(overviews: overviews, savings: savings >= 0 ? (userSettings["balance"]! - savings) : userSettings["balance"]!, savingsThisMonth: savings)
                        } label: {
                            HStack {
                                Image(systemName: "dollarsign.arrow.circlepath")
                                    .font(.title)
                                    .padding(.trailing, -3)
                                    .padding(.leading, -5)
                                
                                VStack {
                                    Text("$\(String(format: "%.2f", savings))").fontWeight(.bold)
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
                        
                        NavigationLink {
                            TotalExpenseView(userSettings: $userSettings, categories: $categories, viewOnly: false)
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
                                    Text("$\(String(format: "%.2f", totalSpendings))").fontWeight(.bold)
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
                    List {
                        Section {
                            if (needsList.count > 0) {
                                ForEach(needsList) { wishlistItem in
                                    NavigationLink {
                                        NeedDetailsView(wishlist: $wishlist, item: wishlistItem, categories: $categories, userSettings: $userSettings)
                                    } label: {
                                        VStack(alignment: .leading) {
                                            HStack {
                                                Text(wishlistItem.name)
                                                Spacer()
                                                Text("$\(String(format: "%.2f", wishlistItem.price))")
                                            }
                                            .fontWeight(.semibold)
                                            HStack {
                                                Text(wishlistItem.date.formatted(.dateTime.day().month().year()))
                                                Spacer()
                                                Text(categories.first(where: { $0.id == wishlistItem.categoryId })!.name)
                                            }
                                            .fontWeight(.light)
                                            ZStack(alignment: .leading) {
                                                Rectangle()
                                                    .fill(Color(.systemGray5))
                                                    .frame(width: 325, height: 18)
                                                    .cornerRadius(20)
                                                Rectangle()
                                                    .fill(.green)
                                                    .frame(width: needProgressWidth(itemValue: wishlistItem.price), height: 18)
                                                    .cornerRadius(20)
                                            }
                                        }
                                    }
                                    .listRowBackground(colorScheme == .dark ? Color(.systemGray5) : .white)
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button {
                                            wishlistItemId = wishlistItem.id
                                            needBoughtAlertShown = true
                                        } label: {
                                            Image(systemName: "checkmark")
                                        }
                                        .tint(.green)
                                    }
                                }
                            } else {
                                HStack {
                                    Text("No Needs")
                                }
                                .listRowBackground(colorScheme == .dark ? Color(.systemGray5) : .white)
                                .swipeActions(edge: .trailing) {
                                    Button {
                                        type = 0
                                        addItemSheetShown = true
                                    } label: {
                                        Image(systemName: "plus")
                                    }
                                    .tint(Color("AccentColor"))
                                }
                            }
                        } header: {
                            Text("Remember to Buy")
                                .font(.title3)
                                .textCase(.none)
                                .fontWeight(.bold)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                        Section {
                            if (wantsList.count > 0) {
                                ForEach(wantsList) { wishlistItem in
                                    VStack {
                                        HStack {
                                            Text(wishlistItem.name)
                                            Spacer()
                                            Text("$\(String(format: "%.2f", wishlistItem.price))")
                                        }
                                        .fontWeight(.semibold)

                                        ZStack(alignment: .leading) {
                                            Rectangle()
                                                .fill(Color(.systemGray4))
                                                .frame(width: 325, height: 18)
                                                .cornerRadius(20)
                                            Rectangle()
                                                .fill(Color("AccentColor"))
                                                .frame(width: wantProgressWidth(itemValue: wishlistItem.price), height: 18)
                                                .cornerRadius(20)
                                        }
                                        .padding(.top, -7)
                                    }
                                    .listRowBackground(colorScheme == .dark ? Color(.systemGray5) : .white)
                                }
                            } else {
                                HStack {
                                    Text("No Wants")
                                }
                                .listRowBackground(colorScheme == .dark ? Color(.systemGray5) : .white)
                                .swipeActions(edge: .trailing) {
                                    Button {
                                        type = 1
                                        addItemSheetShown = true
                                    } label: {
                                        Image(systemName: "plus")
                                    }
                                    .tint(Color("AccentColor"))
                                }
                            }
                        } header: {
                            Text("Wants")
                                .font(.title3)
                                .textCase(.none)
                                .fontWeight(.bold)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .padding(.top, -15)
                }
                .navigationTitle("Home")
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Balance: $\(String(format: "%.2f", userSettings["balance"]!))")
                        .font(.title3)
                        .padding(.top, 10)
                        .fontWeight(.bold)
                }
                ToolbarItem {
                    NavigationLink {
                        SetupView(userSettings: $userSettings, categories: $categories, pageNum: 2, isFirstLaunch: false)
                    } label: {
                        Image(systemName: "person.crop.circle")
                            .font(.title3)
                            .padding(.top, 10)
                            .fontWeight(.bold)
                    }
                }
            }
        }
        .sheet(isPresented: $addItemSheetShown) {
            CreateWishlistSheet(categories: categories, wishlist: $wishlist, type: type)
        }
        .alert("Do you want to use your previous months' savings or your current budget to purchase this item?", isPresented: $needBoughtAlertShown) {
            Button("Previous Savings") {
                userSettings["balance"] = userSettings["balance"]! - needsList.first(where: {$0.id == wishlistItemId})!.price
                wishlist = wishlist.filter {$0.id != wishlistItemId}
            }
            Button("Current Budget") {
                let categoryIndex = categories.firstIndex(where: { item!.categoryId == $0.id })!
                categories[categoryIndex].expenses.append(Expense(name: "Wishlist: \(item!.name)", price: item!.price, date: Date(), categoryId: item!.categoryId))
                wishlist = wishlist.filter {$0.id != wishlistItemId}
            }
            Button("Cancel", role: .cancel) {
                
            }
        }
    }
}
