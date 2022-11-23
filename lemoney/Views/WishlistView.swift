import SwiftUI

struct WishlistView: View {
    @Binding var categories: [Category]
    @Binding var wishlist: [WishlistItem]
    @Binding var userSettings: UserSettings
    
    var totalSpendings: Double {
        categories.reduce(0) { $0 + $1.spendings }
    }
    var savings: Double {
        userSettings.income - totalSpendings
    }
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            WishlistItemsList(location: "wishlist", userSettings: $userSettings, categories: $categories, wishlist: $wishlist)
                .navigationTitle("Wishlist")
                .scrollContentBackground(.hidden)
                .background(Color(.systemGray6))
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Balance: $\(String(format: "%.2f", userSettings.balance))")
                            .font(.title3)
                            .padding(.top, 10)
                            .fontWeight(.bold)
                    }
                }
        }
    }
}
