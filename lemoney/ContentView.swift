//
//  ContentView.swift
//  lemoney
//
//  Created by T Krobot on 22/10/22.
//

import SwiftUI

struct ContentView: View {
    @State var categories = [
        Category(name: "Transport", expenses: []),
        Category(name: "Food", expenses: []),
        Category(name: "Clothes", expenses: []),
        Category(name: "Entertainment", expenses: []),
        Category(name: "Stationery", expenses: [])
    ]
    
    var body: some View {
        VStack {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                
                BudgetView(categories: $categories)
                    .tabItem {
                        Label("Budget", systemImage: "dollarsign.circle.fill")
                    }
                
                WishlistView()
                    .tabItem {
                        Label("Wishlist", systemImage: "list.star")
                    }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
