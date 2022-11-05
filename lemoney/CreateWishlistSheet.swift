//
//  CreateWishlistSheet.swift
//  lemoney
//
//  Created by T Krobot on 29/10/22.
//

import SwiftUI

struct CreateWishlistSheet: View {
    @State var categories: [Category]
    
    @State var name = String()
    @State var price = Double()
    @State var categoryIndex = 3
    @State var type = 1
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Text("Type")
                        Spacer()
                        Picker("Type", selection: $type) {
                            ForEach(1 ..< 3) { i in
                                if (i == 1) {
                                    Text("Want")
                                        .font(.subheadline)
                                } else {
                                    Text("Need")
                                        .font(.subheadline)
                                }
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 120)
                    }
                    
                
                    Picker("Category", selection: $categoryIndex, content: {
                        ForEach(0 ..< categories.count, content: { i in
                            Text("\(categories[i].name)")
                        })
                    })
                    .pickerStyle(.menu)
                    .onAppear {
                        categoryIndex = categories.firstIndex(where: {$0.name == "Entertainment"})!
                    }
                    
                    TextField("Name", text: $name)
                    
                    HStack {
                        Text("$")
                            .padding(.trailing, -6)
                        TextField("Price", value: $price, formatter: NumberFormatter())
                    }
                }
            }
            .navigationTitle("New Item")
        }
    }
}
struct CreateWishlistSheet_Previews: PreviewProvider {
    static var previews: some View {
        CreateWishlistSheet(categories: [
            Category(name: "Transport", expenses: [], budget: 150.00, isStartingCategory: true),
            Category(name: "Food", expenses: [], budget: 150.00, isStartingCategory: true),
            Category(name: "Clothes", expenses: [], budget: 150.00, isStartingCategory: true),
            Category(name: "Entertainment", expenses: [], budget: 150.00, isStartingCategory: true),
            Category(name: "Stationery", expenses: [], budget: 150.00, isStartingCategory: true)
        ])
    }
}
