import SwiftUI

struct ContentView: View {
    
    @State var userSettings = [
        "income": 2000.00,
        "budgetGoal": 1600.00,
        "savingsGoal": 400.00,
        "balance": 2000.00
    ]
    @StateObject var categoryManager = CategoryManager()
    @State var wishlist: [WishlistItem] = []
    
    @State var showSetupSheet = false
    
    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    
    var body: some View {
        TabView {
            HomeView(userSettings: $userSettings, categories: $categoryManager.categories, wishlist: $wishlist)
                .tabItem { Label("Home", systemImage: "house.fill") }
            
            BudgetView(userSettings: $userSettings, categories: $categoryManager.categories)
                .tabItem { Label("Budget", systemImage: "dollarsign.circle.fill") }
            
            WishlistView(categories: categoryManager.categories, wishlist: $wishlist, userSettings: $userSettings)
                .tabItem { Label("Wishlist", systemImage: "list.star") }
        }
        .sheet(isPresented: $showSetupSheet) {
            if (!launchedBefore) {
                SetupView(userSettings: $userSettings, categories: $categoryManager.categories, pageNum: 1, isFirstLaunch: true)
            }
        }
        .onAppear {
            if (!launchedBefore) {
                UserDefaults.standard.set(true, forKey: "launchedBefore")
                showSetupSheet = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
