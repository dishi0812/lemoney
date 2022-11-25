import Foundation

struct AppData: Codable {
    var categories: [Category]
    var wishlist: [WishlistItem]
    var userSettings: UserSettings
    var overviews: [MonthOverview]
}
