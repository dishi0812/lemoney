//
//  ContentView.swift
//  lemoney
//
//  Created by T Krobot on 22/10/22.
//

import SwiftUI

struct ContentView: View {
    @State var categories = [
        Category(name: "Transport", expenses: [], spendings: 123.23, budget: 132.23),
        Category(name: "Food", expenses: [], spendings: 123.23, budget: 132.23),
        Category(name: "Clothes", expenses: [], spendings: 123.23, budget: 132.23),
        Category(name: "Entertainment", expenses: [], spendings: 112.23, budget: 123432.343),
        Category(name: "Stationery", expenses: [], spendings: 123.23, budget: 132.23)
    ]
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }
            
            BudgetView(categories: categories)
                .tabItem { Label("Budget", systemImage: "dollarsign.circle.fill") }
            
            WishlistView()
                .tabItem { Label("Wishlist", systemImage: "list.star") }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
