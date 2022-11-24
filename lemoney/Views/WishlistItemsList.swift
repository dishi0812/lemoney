import SwiftUI

struct WishlistItemsList: View {

    // TODO: refund set aside amt on delete
    
    let location: String
    
    @State var itemBoughtAlertShown = false
    
    @State var wishlistItemId = UUID()
    
    var item: WishlistItem? {
        wishlist.first(where: {$0.id == wishlistItemId}) ?? nil
    }
    
    @State var type = Int()
    @State var addItemSheetShown = false
    @State var setAsideAlert = false
    @State var setAsideAndBuyAlert = false

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
    
    @State var deleteId = UUID()
    @State var deleteAlertShown = false
    
    func wantProgressWidth(itemValue: Double) -> Double {
        let width = savings >= 0 ? (userSettings.balance - savings) / itemValue * 325 : userSettings.balance / itemValue * 325
        if (width > 325) {
            return 325
        } else if (width < 0) {
            return 0
        } else {
            return width
        }
    }
    func needProgressWidth(item: WishlistItem) -> Double{
        let width = item.amtSetAside / item.price * 300
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
                    ForEach(needsList) { need in
                        // need
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
                                    Text(getDateFromString(need.date).formatted(.dateTime.day().month().year()))
                                    Spacer()
                                    Text(categories.first(where: { $0.id == need.categoryId })!.name)
                                }
                                .fontWeight(.light)
                                ZStack(alignment: .leading) {
                                    Rectangle()
                                        .fill(Color(.systemGray4))
                                        .frame(width: 300, height: 18)
                                        .cornerRadius(20)
                                    Rectangle()
                                        .fill(.green)
                                        .frame(width: needProgressWidth(item: need), height: 18)
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .listRowBackground(colorScheme == .dark ? Color(.systemGray5) : .white)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                wishlistItemId = need.id
                                let item = item!
                                if (item.price - item.amtSetAside == (item.price - item.amtSetAside) / Double(item.daysLeft)) {
                                    setAsideAndBuyAlert = true
                                } else {
                                    setAsideAlert = true
                                }
                            } label: {
                                Image(systemName: "arrow.down.app")
                            }
                            .tint(Color("\(categories.first(where: { $0.id == need.categoryId })!.name)"))
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                wishlistItemId = need.id
                                itemBoughtAlertShown = true
                            } label: {
                                Image(systemName: "cart")
                            }
                            .tint(.green)
                        }
                        .swipeActions(edge: .trailing) {
                            if (location == "wishlist") {
                                Button {
                                    deleteId = need.id
                                    deleteAlertShown = true
                                } label: {
                                    Image(systemName: "trash")
                                }
                                .tint(.red)
                            }
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
                HStack {
                    Text("Remember to Buy")
                        .font(.title3)
                        .textCase(.none)
                        .fontWeight(.bold)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    
                    if (location == "wishlist") {
                        Spacer()
                        Button {
                            type = 0
                            addItemSheetShown = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.title3)
                        }
                    }
                }
            }
            Section {
                if (wantsList.count > 0) {
                    ForEach(wantsList) { want in
                        // want
                        VStack {
                            HStack {
                                Text(want.name)
                                Spacer()
                                Text("$\(String(format: "%.2f", want.price))")
                            }
                            .fontWeight(.semibold)

                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color(.systemGray4))
                                    .frame(width: 325, height: 18)
                                    .cornerRadius(20)
                                Rectangle()
                                    .fill(Color("AccentColor"))
                                    .frame(width: wantProgressWidth(itemValue: want.price), height: 18)
                                    .cornerRadius(20)
                            }
                            .padding(.top, -7)
                        }
                        .listRowBackground(colorScheme == .dark ? Color(.systemGray5) : .white)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                wishlistItemId = want.id
                                itemBoughtAlertShown = true
                            } label: {
                                Image(systemName: "cart")
                            }
                            .tint(.green)
                        }
                        .swipeActions(edge: .trailing) {
                            if (location == "wishlist") {
                                Button {
                                    deleteId = want.id
                                    deleteAlertShown = true
                                } label: {
                                    Image(systemName: "trash")
                                }
                                .tint(.red)
                            }
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
                HStack {
                    Text("Wants")
                        .font(.title3)
                        .textCase(.none)
                        .fontWeight(.bold)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    
                    if (location == "wishlist") {
                        Spacer()
                        Button {
                            type = 0
                            addItemSheetShown = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.title3)
                        }
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .alert("Delete this Wishlist Item?", isPresented: $deleteAlertShown) {
            Button("Delete", role: .destructive) {
                if (wishlist.first(where: { $0.id == deleteId })!.type == .need) {
                    // TODO: REFUND SET ASIDE AMT
                    // IDEA: have an array of expenseUUID in wishlistItem & filter expenses?
                }
                wishlist = wishlist.filter { $0.id != deleteId }
            }
            Button("OK", role: .cancel) {}
        }
        .alert("Purchase this item?", isPresented: $itemBoughtAlertShown) {
            if (item != nil) {
                let item = item!
                if item.type == .want {
                    Button("Purchase With Previous Savings") {
                        userSettings.balance = userSettings.balance - item.price
                        wishlist = wishlist.filter {$0.id != wishlistItemId}
                    }
                } else if item.type == .need {
                    Button("Purchase With Current Budget") {
                        let categoryIndex = categories.firstIndex(where: { item.categoryId == $0.id })!
                        userSettings.balance = userSettings.balance - (item.price - item.amtSetAside)
                        categories[categoryIndex].expenses.append(Expense(name: "\(item.type == .need ? "Need Bought" : "Want Bought"): \(item.name)", price: item.price - item.amtSetAside, date: Date(), categoryId: item.categoryId))
                        wishlist = wishlist.filter {$0.id != wishlistItemId}
                    }
                }
                Button("Cancel", role: .cancel) {
                    
                }
            }
        } message: {
            if (item != nil) {
                let item = item!
                Text("\(item.name) ($\(String(format: "%.2f", item.price - item.amtSetAside)))")
            }
        }
        .alert("Set Aside Money With Current Budget?", isPresented: $setAsideAlert) {
            if (item != nil) {
                let item = item!
                let setAsideAmt = (item.price - item.amtSetAside) / Double(item.daysLeft)
                
                Button("Set Aside") {
                    let index = wishlist.firstIndex(where: {$0.id == item.id})!
                    wishlist[index].amtSetAside += setAsideAmt
                    
                    let categoryIndex = categories.firstIndex(where: { item.categoryId == $0.id })!
                    categories[categoryIndex].expenses.append(Expense(name: "Set Aside: \(item.name)", price: setAsideAmt, date: Date(), categoryId: item.categoryId))
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            if (item != nil) {
                Text("\(item!.name) ($\(String(format: "%.2f", (item!.price - item!.amtSetAside) / Double(item!.daysLeft))))")
            }
        }
        .alert("Set Aside Money and Buy Now?", isPresented: $setAsideAndBuyAlert) {
            if (item != nil) {
                let item = item!
                let setAsideAmt = (item.price - item.amtSetAside) / Double(item.daysLeft)
                
                Button("Set Aside") {
                    let index = wishlist.firstIndex(where: {$0.id == item.id})!
                    wishlist[index].amtSetAside += setAsideAmt
                    
                    let categoryIndex = categories.firstIndex(where: { item.categoryId == $0.id })!
                    categories[categoryIndex].expenses.append(Expense(name: "Need Bought: \(item.name)", price: setAsideAmt, date: Date(), categoryId: item.categoryId))
                    
                    wishlist = wishlist.filter {$0.id != item.id}
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            if (item != nil) {
                Text("\(item!.name) ($\(String(format: "%.2f", (item!.price - item!.amtSetAside) / Double(item!.daysLeft))))")
            }
        }
        .sheet(isPresented: $addItemSheetShown) {
            CreateWishlistSheet(categories: categories, wishlist: $wishlist, type: type)
        }
    }
}
