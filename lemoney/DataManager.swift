import Foundation
import SwiftUI

class AppDataManager: ObservableObject {
    @Published var data: AppData = AppData(
        categories: [
            Category(name: "Transport", expenses: [], budget: 120.00, isStartingCategory: true),
            Category(name: "Food", expenses: [], budget: 120.00, isStartingCategory: true),
            Category(name: "Clothes", expenses: [], budget: 120.00, isStartingCategory: true),
            Category(name: "Entertainment", expenses: [], budget: 120.00, isStartingCategory: true),
            Category(name: "Stationery", expenses: [], budget: 120.00, isStartingCategory: true)
        ],
        wishlist: [],
        userSettings: UserSettings(
            income: 800.00,
            budgetGoal: 600.00,
            savingsGoal: 200.00,
            balance: 1000.00
        ),
        overviews: [
            MonthOverview(categories: ["Transport": 50.00, "Food": 50.00, "Savings": 100.00, "Clothes": 60.00, "Stationery": 80.00, "Entertainment": 90.00], savings: 100.00, month: "Jan"),
            MonthOverview(categories: ["Transport": 25.00, "Food": 75.00, "Savings": 160.00, "Clothes": 90.00, "Stationery": 40.00, "Entertainment": 120.00], savings: 160.00, month: "Feb"),
            MonthOverview(categories: ["Transport": 100.00, "Food": 0.00, "Savings": 120.00, "Clothes": 25.00, "Stationery": 50.00, "Entertainment": 60.00], savings: 120.00, month: "Mar"),
            MonthOverview(categories: ["Transport": 90.00, "Food": 10.00, "Savings": 200.00, "Clothes": 53.00, "Stationery": 10.00, "Entertainment": 130.00], savings: 200.00, month: "Apr"),
            MonthOverview(categories: ["Transport": 30.00, "Food": 70.00, "Savings": 180.00, "Clothes": 30.00, "Stationery": 135.00, "Entertainment": 38.00], savings: 180.00, month: "May"),
            MonthOverview(categories: ["Transport": 30.00, "Food": 70.00, "Savings": 80.00, "Clothes": 45.00, "Stationery": 23.00, "Entertainment": 8.00], savings: 80.00, month: "Jun")
        ]
    ) {
        didSet {
            save()
        }
    }
    
    let sampleData: AppData = AppData(
        categories: [
            Category(name: "Transport", expenses: [], budget: 120.00, isStartingCategory: true),
            Category(name: "Food", expenses: [], budget: 120.00, isStartingCategory: true),
            Category(name: "Clothes", expenses: [], budget: 120.00, isStartingCategory: true),
            Category(name: "Entertainment", expenses: [], budget: 120.00, isStartingCategory: true),
            Category(name: "Stationery", expenses: [], budget: 120.00, isStartingCategory: true)
        ],
        wishlist: [],
        userSettings: UserSettings(
            income: 800.00,
            budgetGoal: 600.00,
            savingsGoal: 200.00,
            balance: 1000.00
        ),
        overviews: [
            MonthOverview(categories: ["Transport": 50.00, "Food": 50.00, "Savings": 100.00, "Clothes": 60.00, "Stationery": 80.00, "Entertainment": 90.00], savings: 100.00, month: "Jan"),
            MonthOverview(categories: ["Transport": 25.00, "Food": 75.00, "Savings": 160.00, "Clothes": 90.00, "Stationery": 40.00, "Entertainment": 120.00], savings: 160.00, month: "Feb"),
            MonthOverview(categories: ["Transport": 100.00, "Food": 0.00, "Savings": 120.00, "Clothes": 25.00, "Stationery": 50.00, "Entertainment": 60.00], savings: 120.00, month: "Mar"),
            MonthOverview(categories: ["Transport": 90.00, "Food": 10.00, "Savings": 200.00, "Clothes": 53.00, "Stationery": 10.00, "Entertainment": 130.00], savings: 200.00, month: "Apr"),
            MonthOverview(categories: ["Transport": 30.00, "Food": 70.00, "Savings": 180.00, "Clothes": 30.00, "Stationery": 135.00, "Entertainment": 38.00], savings: 180.00, month: "May"),
            MonthOverview(categories: ["Transport": 30.00, "Food": 70.00, "Savings": 80.00, "Clothes": 45.00, "Stationery": 23.00, "Entertainment": 8.00], savings: 80.00, month: "Jun")
        ]
    )
    
    
    init() {
        load()
    }
    
    func getArchiveURL() -> URL {
        let plistName = "data.plist"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        return documentsDirectory.appendingPathComponent(plistName)
    }
    
    func save() {
        let archiveURL = getArchiveURL()
        let propertyListEncoder = PropertyListEncoder()
        let encodedData = try? propertyListEncoder.encode(data)
        try? encodedData?.write(to: archiveURL, options: .noFileProtection)
    }
    
    func load() {
        let archiveURL = getArchiveURL()
        let propertyListDecoder = PropertyListDecoder()
        
        var finalData: AppData!
        
        if let retrievedData = try? Data(contentsOf: archiveURL),
            let decodedData = try? propertyListDecoder.decode(AppData.self, from: retrievedData) {
            finalData = decodedData
        } else {
            finalData = sampleData
        }
        
        data = finalData
    }
}
