//
//  CreateWishlistSheet.swift
//  lemoney
//
//  Created by T Krobot on 29/10/22.
//

import SwiftUI

struct CreateWishlistSheet: View {
    @State var categories: [Category]
    @Binding var wishlist: [WishlistItem]
    
    @State var type: Int
    @State var categoryIndex = 3
    @State var name = String()
    @State var price = Double()
    @State var date = Date()
    
    @State var notFilledAlert = false
    
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGray6)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Form {
                        Section {
                            HStack {
                                Text("Type")
                                Spacer()
                                Picker("Type", selection: $type) {
                                    ForEach(0..<2) { i in
                                        if (i == 0) {
                                            Text("Need")
                                                .font(.subheadline)
                                        } else {
                                            Text("Want")
                                                .font(.subheadline)
                                        }
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .frame(width: 120)
                            }
                        }
                         
                        Section {
                            Picker("Category", selection: $categoryIndex) {
                                ForEach(0 ..< categories.count) { i in
                                    Text("\(categories[i].name)")
                                }
                            }
                            .pickerStyle(.menu)
                            .onAppear {
                                categoryIndex = categories.firstIndex(where: {$0.name == "Entertainment"})!
                            }
                            
                            TextField("Name", text: $name)
                            
                            HStack {
                                TextField("Price", value: $price, formatter: CurrencyFormatter())
                            }
                            
                            if (type == 0) {
                                DatePicker("Date Needed", selection: $date, displayedComponents: [.date])
                            }
                        }
                    }
                    .navigationTitle("New Item")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                if (name != "" && price > 0.00) {
                                    wishlist.append(WishlistItem(type: type == 0 ? .need : .want, name: name, price: price, date: type == 0 ? date : Date(), categoryId: categories[categoryIndex].id))
                                    
                                    wishlist = wishlist.sorted(by: {$0.date.timeIntervalSince1970 < $1.date.timeIntervalSince1970})
                                    
                                    dismiss()
                                } else {
                                    notFilledAlert = true
                                }
                            } label: {
                                Text("Done")
                            }
                        }
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                dismiss()
                            } label: {
                                Text("Cancel")
                            }
                        }
                    }
                    .alert("Please fill in all the blanks", isPresented: $notFilledAlert) {
                        Button("OK", role: .cancel) {}
                    }
                }
            }
        }
    }
}
