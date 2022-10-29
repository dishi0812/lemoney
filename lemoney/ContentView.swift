import SwiftUI

struct ContentView: View {
    @State var categories = [
        Category(name: "Transport", expenses: [], budget: 200.00),
        Category(name: "Food", expenses: [], budget: 200.00),
        Category(name: "Clothes", expenses: [], budget: 200.00),
        Category(name: "Entertainment", expenses: [], budget: 200.00),
        Category(name: "Stationery", expenses: [], budget: 200.00)
    ]
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }
            
            BudgetView(categories: categories, selectedCategory: 0)
                .tabItem { Label("Budget", systemImage: "dollarsign.circle.fill") }
            
            WishlistView()
                .tabItem { Label("Wishlist", systemImage: "list.star") }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
