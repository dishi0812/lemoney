import SwiftUI

struct WishlistView: View {
    @State var categories: [Category]
    @State var addItemSheetShown = false
    
    @Binding var wishlist: [WishlistItem]
    var needsList: [WishlistItem] { wishlist.filter { $0.type == .need } }
    var wantsList: [WishlistItem] { wishlist.filter { $0.type == .want } }
    
    @State var type = 1
    
    @State var deleteAlertShown = false
    @State var deleteId = UUID()
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    if (needsList.count > 0) {
                        ForEach(needsList, id: \.id) { need in
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
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button {
                                    deleteId = need.id
                                    deleteAlertShown = true
                                } label: {
                                    Image(systemName: "trash")
                                }
                                .tint(.red)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button {
                                    
                                } label: {
                                    Image(systemName: "checkmark")
                                }
                                .tint(.green)
                            }
                        }
                    } else {
                        Text("No Needs")
                    }
                } header: {
                    HStack {
                        Text("Needs").foregroundColor(.black)
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
                                        .frame(width: 60, height: 18)
                                        .cornerRadius(20)
                                }
                                .padding(.top, -7)
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button {
                                    deleteId = want.id
                                    deleteAlertShown = true
                                } label: {
                                    Image(systemName: "trash")
                                }
                                .tint(.red)
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button {
                                    
                                } label: {
                                    Image(systemName: "checkmark")
                                }
                                .tint(.green)
                            }
                        }
                    } else {
                        Text("No Wants")
                    }
                } header: {
                    HStack {
                        Text("Wants").foregroundColor(.black)
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

