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
    @StateObject var dataManager = AppDataManager()
    
    
    @AppStorage("prevLaunchDate") var prevDate: Date = Date()

    @Environment(\.colorScheme) var colorScheme
    
    var totalSpendings: Double {
        dataManager.data.categories.reduce(0) { $0 + $1.spendings }
    }
    var savings: Double {
        dataManager.data.userSettings.income - totalSpendings
    }
    
    @Environment(\.scenePhase) var scenePhase
    
    @State var showSetupSheet = false
    @State var monthOverviewPresented = false
    
    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    
    var body: some View {
        TabView {
            HomeView(userSettings: $dataManager.data.userSettings, overviews: $dataManager.data.overviews, categories: $dataManager.data.categories, wishlist: $dataManager.data.wishlist)
                .tabItem { Label("Home", systemImage: "house.fill") }
            
            BudgetView(userSettings: $dataManager.data.userSettings, categories: $dataManager.data.categories)
                .tabItem { Label("Budget", systemImage: "dollarsign.circle.fill") }
            
            WishlistView(categories: $dataManager.data.categories, wishlist: $dataManager.data.wishlist, userSettings: $dataManager.data.userSettings)
                .tabItem { Label("Wishlist", systemImage: "list.star") }
        }
        .sheet(isPresented: $showSetupSheet) {
            if (launchedBefore) {
                SetupView(userSettings: $dataManager.data.userSettings, categories: $dataManager.data.categories, pageNum: 1, isFirstLaunch: true)
            }
        }
        .sheet(isPresented: $monthOverviewPresented) {
            MonthOverviewView(month: prevDate, overviews: $dataManager.data.overviews, categories: $dataManager.data.categories, userSettings: $dataManager.data.userSettings)
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
                    // prevDate.formatted(.dateTime.month()) != Date().formatted(.dateTime.month()) || prevDate.formatted(.dateTime.year()) != Date().formatted(.dateTime.year())
                    prevDate = Date()
                    var categoriesDict: [String:Double] = [:]
                    for category in dataManager.data.categories {
                        categoriesDict[category.name] = category.spendings
                    }
                    if (savings > 0.00) {
                        categoriesDict["Savings"] = savings
                    }
                    let overview = MonthOverview(categories: categoriesDict, savings: savings, month: prevDate.formatted(.dateTime.month()))
                    dataManager.data.overviews.append(overview)
                    if (dataManager.data.overviews.count > 6) {
                        dataManager.data.overviews.remove(at: 0)
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
