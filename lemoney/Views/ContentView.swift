import SwiftUI

struct ContentView: View {
    @State var income: Double = 2000.00
    @State var budgetGoal: Double = 1600.00
    @State var savingsGoal: Double = 400.00
    @State var balance: Double = 2000.00
    
    @StateObject var categoryManager = CategoryManager()
    @State var wishlist: [WishlistItem] = []
    
    @State var showSetupSheet = false
    
    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    
    var body: some View {
        TabView {
            HomeView(income: $income, categories: $categoryManager.categories, budgetGoal: $budgetGoal, savingsGoal: $savingsGoal, balance: $balance)
                .tabItem { Label("Home", systemImage: "house.fill") }
            
            BudgetView(categories: $categoryManager.categories, budgetGoal: $budgetGoal, savingsGoal: $savingsGoal, balance: $balance)
                .tabItem { Label("Budget", systemImage: "dollarsign.circle.fill") }
            
            WishlistView(categories: categoryManager.categories, wishlist: $wishlist)
                .tabItem { Label("Wishlist", systemImage: "list.star") }
        }
        .sheet(isPresented: $showSetupSheet) {
            SetupView(categories: $categoryManager.categories, income: $income, balance: $balance, budget: $budgetGoal, savings: $savingsGoal, pageNum: 1, isFirstLaunch: true)
        }
        .onAppear {
            if (!launchedBefore) { showSetupSheet = true }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
