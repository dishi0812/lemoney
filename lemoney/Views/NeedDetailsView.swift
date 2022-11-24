import SwiftUI

struct NeedDetailsView: View {
    
    // TODO: set aside custom amount sheet (maybe change it to another type of view)
    
    @State var needBoughtAlertShown = false
    
    
    @Binding var wishlist: [WishlistItem]
    var item: WishlistItem
    @Binding var categories: [Category]
    @Binding var userSettings: UserSettings
    
    @Environment(\.colorScheme) var colorScheme
    
    var totalSpendings: Double {
        categories.reduce(0) { $0 + $1.spendings }
    }
    var savings: Double {
        userSettings.income - totalSpendings
    }
    var previousMonthsSavings: Double {
        savings >= 0 ? (userSettings.balance - savings) : userSettings.balance
    }
    
    var daysLeft: Int {
        if Date().formatted(.dateTime.day().month()) == getDateFromString(item.date).formatted(.dateTime.day().month()) {
            return 1
        } else {
            return Calendar.current.dateComponents([.day], from: Date(), to: getDateFromString(item.date)).day! + 2
        }
    }
    var setAsideAmt: Double {
        (item.price - item.amtSetAside) / (Double(daysLeft))
    }
    @State var setAsideInput = Double()
    @State var showSheet = false
    
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Text("(\(categories.first(where: { item.categoryId == $0.id })!.name), $\(String(format: "%.2f", item.price)))")
                        .padding(.horizontal, 16)
                        .multilineTextAlignment(.leading)
                        .font(.title2)
                    
                    Spacer()
                }
                
                HStack {
                    ZStack {
                        VStack {
                            Text("Time:")
                                .font(.title)
                                .fontWeight(.medium)
                            VStack {
                                Text("\(abs(daysLeft))")
                                    .font(.system(size: 45))
                                    .fontWeight(.bold)
                                Text(daysLeft < 0 ? "days late" : "days left")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                
                            }
                        }
                        .padding(.horizontal, 20)
                        .frame(height: 160)
                        .background(colorScheme == .dark ? Color(.systemGray5) : .white)
                        .cornerRadius(12)
                    }
                    .padding(7)
                    
                    if (daysLeft >= 0) {
                        ZStack {
                            VStack {
                                Text("Save: ")
                                    .font(.title)
                                    .fontWeight(.medium)
                                VStack {
                                    Text("$\(String(format: "%.2f", item.price - item.amtSetAside > 0.00 ? setAsideAmt : 0.00))")
                                        .font(.system(size: 45))
                                        .fontWeight(.bold)
                                    Text("per day")
                                        .font(.headline)
                                        .fontWeight(.medium)
                                }
                            }
                            .padding(.horizontal, 20)
                            .frame(height: 160)
                            .background(colorScheme == .dark ? Color(.systemGray5) : .white)
                            .cornerRadius(12)
                        }
                        .padding(7)
                    }
                }
                ZStack {
                    VStack {
                        Text("You need:")
                            .font(.title)
                            .fontWeight(.medium)
                        VStack {
                            Text("$\(String(format: "%.2f", item.price - item.amtSetAside))")
                                .font(.system(size: 45))
                                .fontWeight(.bold)
                            Text("more")
                                .font(.headline)
                                .fontWeight(.medium)
                        }
                    }
                    .padding(.horizontal, 20)
                    .frame(height: 160)
                    .background(colorScheme == .dark ? Color(.systemGray5) : .white)
                    .cornerRadius(12)
                }
                .padding(7)
                
                Spacer()
                
                if item.price - item.amtSetAside > 0.00 && daysLeft >= 0 {
                    Menu {
                        Button("Set aside $\(String(format: "%.2f", setAsideAmt)) \(item.price - item.amtSetAside == setAsideAmt ? "and buy" : "")") {
                            if (item.price - item.amtSetAside == setAsideAmt) {
                                let index = wishlist.firstIndex(where: {$0.id == item.id})!
                                wishlist[index].amtSetAside += setAsideAmt
                                
                                let categoryIndex = categories.firstIndex(where: { item.categoryId == $0.id })!
                                
                                let id = UUID()
                                categories[categoryIndex].expenses.append(Expense(id: id, name: "Need Bought: \(item.name)", price: setAsideAmt, date: Date(), categoryId: item.categoryId, isFromSetAside: true, wishlistId: wishlist[index].id))
                                
                                wishlist[index].setAsideExpenses.append(id)
                                
                                userSettings.balance -= setAsideAmt
                                wishlist = wishlist.filter {$0.id != item.id}
                            } else {
                                let index = wishlist.firstIndex(where: {$0.id == item.id})!
                                wishlist[index].amtSetAside += setAsideAmt
                                
                                userSettings.balance -= setAsideAmt
                                let categoryIndex = categories.firstIndex(where: { item.categoryId == $0.id })!
                                
                                let id = UUID()
                                categories[categoryIndex].expenses.append(Expense(id: id, name: "Set Aside: \(item.name)", price: setAsideAmt, date: Date(), categoryId: item.categoryId, isFromSetAside: true, wishlistId: wishlist[index].id))
                                wishlist[index].setAsideExpenses.append(id)
                            }
                        }
                        Button {
                            showSheet = true
                        } label: {
                            Text("Custom Amount")
                        }
                    } label: {
                        Text("Set Aside Money")
                            .padding(15)
                            .frame(width: 320)
                            .background(Color("AccentColor"))
                            .cornerRadius(12)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 5)
                }
            
                Button {
                    if item.price - item.amtSetAside > 0.00 {
                        needBoughtAlertShown = true
                    } else {
                        wishlist = wishlist.filter {$0.id != item.id}
                    }
                } label: {
                    Text("Buy Now")
                        .padding(15)
                        .frame(width: 320)
                        .background(Color("AccentColor"))
                        .cornerRadius(12)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                Spacer()
                    
            }
            .navigationTitle("\(item.name)")
        }
        .alert("Purchase this item?", isPresented: $needBoughtAlertShown) {
            Button("Purchase with Current Budget") {
                if (item.price - item.amtSetAside > 0.00) {
                    let categoryIndex = categories.firstIndex(where: { item.categoryId == $0.id })!
                    userSettings.balance -= (wishlist.first(where: {$0.id == item.id})!.price - wishlist.first(where: {$0.id == item.id})!.amtSetAside)
                    categories[categoryIndex].expenses.append(Expense(name: "Wishlist: \(item.name)", price: (item.price - item.amtSetAside), date: Date(), categoryId: item.categoryId, isFromSetAside: true, wishlistId: item.id))
                }
                wishlist = wishlist.filter {$0.id != item.id}
            }
            Button("Cancel", role: .cancel) {
                
            }
        }
        .onAppear {
            setAsideInput = setAsideAmt
        }
        .alert("Custom Amount", isPresented: $showSheet) {
            TextField("Price", value: $setAsideInput, formatter: CurrencyFormatter())
                .keyboardType(.decimalPad)
            
            Button {
                if (setAsideInput > item.price) { setAsideInput = item.price }
                let categoryIndex = categories.firstIndex(where: { item.categoryId == $0.id })!
                let id = UUID()
                categories[categoryIndex].expenses.append(Expense(name: "Set Aside: \(item.name)", price: setAsideInput, date: Date(), categoryId: item.categoryId, isFromSetAside: true, wishlistId: item.id))
                wishlist[wishlist.firstIndex(where: {$0.id == item.id})!].setAsideExpenses.append(id)
                userSettings.balance -= setAsideInput
            } label: {
                Text("Add")
                    .padding(15)
                    .frame(width: 320)
                    .background(Color("AccentColor"))
                    .cornerRadius(12)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .disabled(setAsideInput > item.price - item.amtSetAside)
        }
    }
}
