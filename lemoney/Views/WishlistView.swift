import SwiftUI

struct WishlistView: View {
    @State var categories: [Category]
    @State var addItemSheetShown = false
    
    @Binding var wishlist: [WishlistItem]
    @Binding var userSettings: [String:Double]
    
    var needsList: [WishlistItem] { wishlist.filter { $0.type == .need } }
    var wantsList: [WishlistItem] { wishlist.filter { $0.type == .want } }
    
    var totalSpendings: Double {
        categories.reduce(0) { $0 + $1.spendings }
    }
    var savings: Double {
        userSettings["income"]! - totalSpendings
    }
    
    @State var type = 1
    @State var deleteAlertShown = false
    @State var deleteId = UUID()
    
    func progressWidth(itemValue: Double) -> Double {
        let width = savings >= 0 ? (userSettings["balance"]! - savings) / itemValue * 325 : userSettings["balance"]! / itemValue * 325
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
            List {
                Section {
                    if (needsList.count > 0) {
                        ForEach(needsList, id: \.id) { need in
                            NavigationLink {
                                NeedDetailsView()
                            } label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("\(need.name)")
                                            Spacer()
                                            Text("$\(String(format: "%.2f", need.price))")
                                        }
                                        .fontWeight(.semibold)
                                        
                                        HStack {
                                            Text("\(need.date.formatted(.dateTime.day().month().year()))")
                                            Spacer()
                                            Text("\(categories.first(where: {$0.id == need.categoryId})!.name)")
                                        }
                                        .fontWeight(.light)
                                    }
                                }
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button {
                                    
                                } label: {
                                    Image(systemName: "checkmark")
                                }
                                .tint(.green)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button {
                                    deleteId = need.id
                                    deleteAlertShown = true
                                } label: {
                                    Image(systemName: "trash")
                                }
                                .tint(.red)
                            }
                        }
                    } else {
                        Text("No Needs")
                    }
                } header: {
                    HStack {
                        Text("Needs")
                            .font(.title2)
                            .textCase(.none)
                            .fontWeight(.bold)
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
                
                
                Section {
                    if (wantsList.count > 0) {
                        ForEach(wantsList, id: \.id) { want in
                            VStack {
                                HStack {
                                    Text("\(want.name)")
                                    Spacer()
                                    Text("\(String(format: "%.2f", want.price))")
                                }
                                .fontWeight(.semibold)
                                ZStack(alignment: .leading) {
                                    Rectangle()
                                        .fill(Color(.systemGray5))
                                        .frame(width: 325, height: 18)
                                        .cornerRadius(20)
                                    Rectangle()
                                        .fill(.green)
                                        .frame(width: progressWidth(itemValue: want.price), height: 18)
                                        .cornerRadius(20)
                                }
                                .padding(.top, -7)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button {
                                    
                                } label: {
                                    Image(systemName: "checkmark")
                                }
                                .tint(.green)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button {
                                    deleteId = want.id
                                    deleteAlertShown = true
                                } label: {
                                    Image(systemName: "trash")
                                }
                                .tint(.red)
                            }
                        }
                    } else {
                        Text("No Wants")
                    }
                } header: {
                    HStack {
                        Text("Wants")
                            .font(.title2)
                            .textCase(.none)
                            .fontWeight(.bold)
                        Spacer()
                        Button {
                            type = 1
                            addItemSheetShown = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.title3)
                        }
                    }
                }
            }
            .navigationTitle("Wishlist")
        }
        .sheet(isPresented: $addItemSheetShown) {
            CreateWishlistSheet(categories: categories, wishlist: $wishlist, type: type)
        }
        .alert("Are you sure you want to delete this item?", isPresented: $deleteAlertShown) {
            Button("Delete", role: .destructive) {
                wishlist = wishlist.filter {$0.id != deleteId}
            }
            Button("Cancel", role: .cancel) {}
        }
        .onAppear {
            wishlist = wishlist.sorted(by: {$0.date.timeIntervalSince1970 < $1.date.timeIntervalSince1970})
        }
    }
}
