//
//  WishlistListView.swift
//  lemoney
//
//  Created by TinkerTanker on 19/11/22.
//

import SwiftUI

struct WishlistListView: View {
    
    let location: String
    
    @State var needBoughtAlertShown = false
    @State var wishlistItemId = UUID()
    var item: WishlistItem? {
        needsList.first(where: {$0.id == wishlistItemId}) ?? nil
    }
    
    @State var type = Int()
    @State var addItemSheetShown = false

    @Binding var userSettings: UserSettings
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
    
    func progressWidth(itemValue: Double) -> Double {
        let width = savings >= 0 ? (userSettings.balance - savings) / itemValue * 325 : userSettings.balance / itemValue * 325
        if (width > 325) {
            return 325
        } else if (width < 0) {
            return 0
        } else {
            return width
        }
    }
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        List {
            Section {
                if (needsList.count > 0) {
                    // needs
                    ForEach(needsList) { need in
                        NavigationLink {
                            NeedDetailsView(wishlist: $wishlist, item: need, categories: $categories, userSettings: $userSettings)
                        } label: {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(need.name)
                                    Spacer()
                                    Text("$\(String(format: "%.2f", need.price))")
                                }
                                .fontWeight(.semibold)
                                HStack {
                                    Text(need.date.formatted(.dateTime.day().month().year()))
                                    Spacer()
                                    Text(categories.first(where: { $0.id == need.categoryId })!.name)
                                }
                                .fontWeight(.light)
                            }
                        }
                        .listRowBackground(colorScheme == .dark ? Color(.systemGray5) : .white)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                // TODO: set aside money with swipe action + alert
                            } label: {
                                Image(systemName: "arrow.down.app")
                            }
                            .tint(Color("\(categories.first(where: { $0.id == need.categoryId })!.name)"))
                        }
                        .swipeActions(edge: .trailing) {
                            Button {
                                wishlistItemId = need.id
                                needBoughtAlertShown = true
                            } label: {
                                Image(systemName: "cart")
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
                    // wants
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
                                    .frame(width: progressWidth(itemValue: wishlistItem.price), height: 18)
                                    .cornerRadius(20)
                            }
                            .padding(.top, -7)
                        }
                        .listRowBackground(colorScheme == .dark ? Color(.systemGray5) : .white)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                            // TODO: alert + deduct from balance
                            } label: {
                                Image(systemName: "cart")
                            }
                            .tint(.green)
                        }
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
        
        .alert("Do you want to use your previous months' savings or your current budget to purchase this item?", isPresented: $needBoughtAlertShown) {
            Button("Previous Savings") {
                userSettings.balance = userSettings.balance - needsList.first(where: {$0.id == wishlistItemId})!.price
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
        .sheet(isPresented: $addItemSheetShown) {
            CreateWishlistSheet(categories: categories, wishlist: $wishlist, type: type)
        }
    }
}
