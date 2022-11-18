import SwiftUI

struct NeedDetailsView: View {
    @State var needBoughtAlertShown = false
    
    
    @Binding var wishlist: [WishlistItem]
    var item: WishlistItem
    @Binding var categories: [Category]
    @Binding var userSettings: [String: Double]
    
    @Environment(\.colorScheme) var colorScheme
    
    var totalSpendings: Double {
        categories.reduce(0) { $0 + $1.spendings }
    }
    var savings: Double {
        userSettings["income"]! - totalSpendings
    }
    var previousMonthsSavings: Double {
        savings >= 0 ? (userSettings["balance"]! - savings) : userSettings["balance"]!
    }
    
    var daysLeft: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: item.date).day! + 1
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
                    Text("(\(categories.first(where: { item.categoryId == $0.id })!.name), $\(String(format: "%.2f", setAsideAmt)))")
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
                
                if item.price - item.amtSetAside > 0.00 {
                    Menu {
                        Button("$\(String(format: "%.2f", setAsideAmt))") {
                            let index = wishlist.firstIndex(where: {$0.id == item.id})!
                            wishlist[index].amtSetAside += setAsideAmt
                            
                            let categoryIndex = categories.firstIndex(where: { item.categoryId == $0.id })!
                            categories[categoryIndex].expenses.append(Expense(name: "Set Aside For: \(item.name)", price: setAsideAmt, date: Date(), categoryId: item.categoryId))
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
        .alert("Do you want to use your previous months' savings or your current budget to purchase this item?", isPresented: $needBoughtAlertShown) {
            if previousMonthsSavings > item.price {
                Button("Previous Savings") {
                    userSettings["balance"] = userSettings["balance"]! - wishlist.first(where: {$0.id == item.id})!.price
                    wishlist = wishlist.filter {$0.id != item.id}
                }
            }
            
            Button("Current Budget") {
                if (item.price - item.amtSetAside > 0.00) {
                    let categoryIndex = categories.firstIndex(where: { item.categoryId == $0.id })!
                    categories[categoryIndex].expenses.append(Expense(name: "Wishlist Item Bought: \(item.name)", price: (item.price - item.amtSetAside), date: Date(), categoryId: item.categoryId))
                }
                wishlist = wishlist.filter {$0.id != item.id}
            }
            Button("Cancel", role: .cancel) {
                
            }
        }
        .onAppear {
            setAsideInput = setAsideAmt
        }
        .sheet(isPresented: $showSheet) {
            TextField("Price", value: $setAsideInput, formatter: CurrencyFormatter())
                .keyboardType(.decimalPad)
            
            Button {
                if (setAsideInput > item.price) { setAsideInput = item.price }
                let categoryIndex = categories.firstIndex(where: { item.categoryId == $0.id })!
                categories[categoryIndex].expenses.append(Expense(name: "Set Aside For: \(item.name)", price: setAsideInput, date: Date(), categoryId: item.categoryId))
            } label: {
                Text("Add")
                    .padding(15)
                    .frame(width: 320)
                    .background(Color("AccentColor"))
                    .cornerRadius(12)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
    }
}
