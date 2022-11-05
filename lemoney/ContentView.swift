import SwiftUI

struct ContentView: View {
    @State var income: Double = 2000.00
    @State var budgetGoal: Double = 1600.00
    @State var savingsGoal: Double = 400.00
    @State var balance: Double = 2000.00
    
    @State var categories = [
        Category(name: "Transport", expenses: [], budget: 150.00, isStartingCategory: true),
        Category(name: "Food", expenses: [], budget: 150.00, isStartingCategory: true),
        Category(name: "Clothes", expenses: [], budget: 150.00, isStartingCategory: true),
        Category(name: "Entertainment", expenses: [], budget: 150.00, isStartingCategory: true),
        Category(name: "Stationery", expenses: [], budget: 150.00, isStartingCategory: true)
    ]
    
    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    var body: some View {
        if (launchedBefore) {
            TabView {
                HomeView(income: $income, categories: $categories, budgetGoal: $budgetGoal, savingsGoal: $savingsGoal, balance: $balance)
                    .tabItem { Label("Home", systemImage: "house.fill") }
                
                BudgetView(categories: $categories, budgetGoal: $budgetGoal, savingsGoal: $savingsGoal, balance: $balance)
                    .tabItem { Label("Budget", systemImage: "dollarsign.circle.fill") }
                
                WishlistView(categories: categories)
                    .tabItem { Label("Wishlist", systemImage: "list.star") }
            }
        } else {
            setupView(categories: $categories)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
