//
//  BudgetView.swift
//  lemoney
//
//  Created by T Krobot on 22/10/22.
//

import SwiftUI

struct BudgetView: View {
    
    @Binding var categories: [Category]
    
    var body: some View {
        Text("Budget View")
    }
}

//struct BudgetView_Previews: PreviewProvider {
//    @State var categories = [
//        Category(name: "Transport", expenses: []),
//        Category(name: "Food", expenses: []),
//        Category(name: "Clothes", expenses: []),
//        Category(name: "Entertainment", expenses: []),
//        Category(name: "Stationery", expenses: [])
//    ]
//    static var previews: some View {
//        BudgetView(categories: categories)
//    }
//}
