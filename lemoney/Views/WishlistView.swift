import SwiftUI

struct WishlistView: View {
    @State var categories: [Category]
    @State var addItemSheetShown = false
    
    @Binding var wishlist: [WishlistItem]
    
    var needsList: [WishlistItem] { wishlist.filter { $0.type == .need } }
    var wantsList: [WishlistItem] { wishlist.filter { $0.type == .want } }
    
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
                        }
                    } else {
                        Text("No Needs")
                    }
                } header: {
                    Text("Needs").foregroundColor(.black)
                        .font(.title2)
                        .textCase(.none)
                        .fontWeight(.bold)
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
                        }
                    } else {
                        Text("No Wants")
                    }
                } header: {
                    Text("Wants").foregroundColor(.black)
                        .font(.title2)
                        .textCase(.none)
                        .fontWeight(.bold)
                }
            }
            .toolbar {
                Button {
                    addItemSheetShown = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .navigationTitle("Wishlist")
        }
        .sheet(isPresented: $addItemSheetShown) {
            CreateWishlistSheet(categories: categories, wishlist: $wishlist)
        }
    }
}

