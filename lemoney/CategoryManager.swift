import Foundation
import SwiftUI

class CategoryManager: ObservableObject {
    @Published var categories: [Category] = [] {
        didSet {
            save()
        }
    }
    
    let sampleCategories: [Category] = [
        Category(name: "Transport", expenses: [], budget: 150.00, isStartingCategory: true),
        Category(name: "Food", expenses: [], budget: 150.00, isStartingCategory: true),
        Category(name: "Clothes", expenses: [], budget: 150.00, isStartingCategory: true),
        Category(name: "Entertainment", expenses: [], budget: 150.00, isStartingCategory: true),
        Category(name: "Stationery", expenses: [], budget: 150.00, isStartingCategory: true)
    ]
    
    init() {
        load()
    }
    
    func getArchiveURL() -> URL {
        let plistName = "categories.plist"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        return documentsDirectory.appendingPathComponent(plistName)
    }
    
    func save() {
        let archiveURL = getArchiveURL()
        let propertyListEncoder = PropertyListEncoder()
        let encodedCategories = try? propertyListEncoder.encode(categories)
        try? encodedCategories?.write(to: archiveURL, options: .noFileProtection)
    }
    
    func load() {
        let archiveURL = getArchiveURL()
        let propertyListDecoder = PropertyListDecoder()
        
        var finalCategories: [Category]!
        
        if let retrievedCategoryData = try? Data(contentsOf: archiveURL),
            let decodedCategories = try? propertyListDecoder.decode([Category].self, from: retrievedCategoryData) {
            finalCategories = decodedCategories
        } else {
            finalCategories = sampleCategories
        }
        
        categories = finalCategories
    }
}
