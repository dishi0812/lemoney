import SwiftUI

struct ContentView: View {
    @State var income: Double = 1000.00
    @State var budgetGoal: Double = 750.00
    @State var savingsGoal: Double = 250.00
    @State var balance: Double = 1400.00
    
    @State var categories = [
        Category(name: "Transport", expenses: [], budget: 150.00, isStartingCategory: true),
        Category(name: "Food", expenses: [], budget: 150.00, isStartingCategory: true),
        Category(name: "Clothes", expenses: [], budget: 150.00, isStartingCategory: true),
        Category(name: "Entertainment", expenses: [], budget: 150.00, isStartingCategory: true),
        Category(name: "Stationery", expenses: [], budget: 150.00, isStartingCategory: true)
    ]
    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    var body: some View {
        if (!launchedBefore) {
            TabView {
                HomeView(categories: $categories, budgetGoal: $budgetGoal, savingsGoal: $savingsGoal, balance: $balance)
                    .tabItem { Label("Home", systemImage: "house.fill") }
                
                BudgetView(categories: $categories, selectedCategory: 0, budgetGoal: $budgetGoal, savingsGoal: $savingsGoal, balance: $balance)
                    .tabItem { Label("Budget", systemImage: "dollarsign.circle.fill") }
                
                WishlistView()
                    .tabItem { Label("Wishlist", systemImage: "list.star") }
            }
        } else {
            setupView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
