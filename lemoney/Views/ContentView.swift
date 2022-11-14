import SwiftUI
import Foundation

extension Date: RawRepresentable {
    private static let formatter = ISO8601DateFormatter()
    
    public var rawValue: String {
        Date.formatter.string(from: self)
    }
    
    public init?(rawValue: String) {
        self = Date.formatter.date(from: rawValue) ?? Date()
    }
}

struct ContentView: View {
    
    @State var userSettings = [
        "income": 2000.00,
        "budgetGoal": 1600.00,
        "savingsGoal": 400.00,
        "balance": 2000.00
    ]
    @State var overviews = [
        MonthOverview(categories: ["Transport": 50.00, "Food": 50.00, "Savings": 100.00], spendings: 100.00, savings: 100.00, month: "Jan"),
        MonthOverview(categories: ["Transport": 25.00, "Food": 75.00, "Savings": 160.00], spendings: 100.00, savings: 160.00, month: "Feb"),
        MonthOverview(categories: ["Transport": 100.00, "Food": 0.00, "Savings": 120.00], spendings: 100.00, savings: 120.00, month: "Mar"),
        MonthOverview(categories: ["Transport": 90.00, "Food": 10.00, "Savings": 200.00], spendings: 100.00, savings: 200.00, month: "Apr"),
        MonthOverview(categories: ["Transport": 30.00, "Food": 70.00, "Savings": 180.00], spendings: 100.00, savings: 180.00, month: "May"),
        MonthOverview(categories: ["Transport": 30.00, "Food": 70.00, "Savings": 80.00], spendings: 100.00, savings: 80.00, month: "Jun")
    ]
    @StateObject var categoryManager = CategoryManager()
    @State var wishlist: [WishlistItem] = []
    
    @AppStorage("prevLaunchDate") var prevDate: Date = Date()
    
    
    var totalSpendings: Double {
        categoryManager.categories.reduce(0) { $0 + $1.spendings }
    }
    var savings: Double {
        userSettings["income"]! - totalSpendings
    }
    
    
    @Environment(\.scenePhase) var scenePhase
    
    @State var showSetupSheet = false
    @State var monthOverviewPresented = false
    
    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    
    var body: some View {
        TabView {
            HomeView(userSettings: $userSettings, overviews: $overviews, categories: $categoryManager.categories, wishlist: $wishlist)
            HomeView(userSettings: $userSettings, overviews: $overviews, categories: $categoryManager.categories, wishlist: $wishlist)
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
        .sheet(isPresented: $monthOverviewPresented) {
            MonthOverviewView(month: prevDate, overviews: $overviews, categories: $categoryManager.categories, userSettings: $userSettings)
        }
        .onAppear {
            if (!launchedBefore) {
                UserDefaults.standard.set(true, forKey: "launchedBefore")
                prevDate = Date()
                showSetupSheet = true
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if (newPhase == .active) {
                if (prevDate.formatted(.dateTime.second()) != Date().formatted(.dateTime.second())) {
                    prevDate = Date()
                    var categoriesDict: [String:Double] = [:]
                    for category in categoryManager.categories {
                        categoriesDict[category.name] = category.spendings
                    }
                    if (savings > 0.00) {
                        categoriesDict["Savings"] = savings
                    }
                    let overview = MonthOverview(categories: categoriesDict, spendings: totalSpendings, savings: savings, month: prevDate.formatted(.dateTime.month()))
                    overviews.append(overview)
                    if (overviews.count > 6) {
                        overviews.remove(at: 0)
                    }
                    monthOverviewPresented = true
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
