import SwiftUI

struct WishlistView: View {
    @State var categories: [Category]
    @State var addItemSheetShown = false
    
    var body: some View {
            NavigationView {
                List {
                    Section {
                        Text("")
                    } header: {
                        Text("Need").foregroundColor(.black)
                            .font(.title2)
                            .textCase(.none)
                            .fontWeight(.bold)
                    }
                    Section {
                        Text("")
                    } header: {
                        Text("Want").foregroundColor(.black)
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
                CreateWishlistSheet(categories: categories)
            }
        }
    }

struct WishlistView_Previews: PreviewProvider {
    static var previews: some View {
        WishlistView(categories: [
            Category(name: "Transport", expenses: [], budget: 150.00, isStartingCategory: true),
            Category(name: "Food", expenses: [], budget: 150.00, isStartingCategory: true),
            Category(name: "Clothes", expenses: [], budget: 150.00, isStartingCategory: true),
            Category(name: "Entertainment", expenses: [], budget: 150.00, isStartingCategory: true),
            Category(name: "Stationery", expenses: [], budget: 150.00, isStartingCategory: true)
        ])
    }
}
