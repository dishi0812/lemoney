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
    
    @State var type = 1
    @State var categoryIndex = 3
    @State var name = String()
    @State var price = Double()
    @State var date = Date()
    
    @State var notFilledAlert = false
    
    
    @Environment(\.presentationMode) var presentationMode
    
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
                                Text("$")
                                    .padding(.trailing, -6)
                                TextField("Price", value: $price, formatter: NumberFormatter())
                            }
                            
                            if (type == 1) {
                                DatePicker("Date Needed", selection: $date, displayedComponents: [.date])
                            } else {
                                DatePicker("Date Wanted", selection: $date, displayedComponents: [.date])
                            }
                        }
                    }
                    .navigationTitle("New Item")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                if (name != "" && price > 0.00) {
                                    wishlist.append(WishlistItem(type: type == 1 ? .need : .want, name: name, price: price, date: date, categoryId: categories[categoryIndex].id))
                                    
                                    presentationMode.wrappedValue.dismiss()
                                } else {
                                    notFilledAlert = true
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "plus")
                                        .padding(.trailing, -5)
                                        .font(.subheadline)
                                    Text("Add")
                                }
                            }
                        }
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                presentationMode.wrappedValue.dismiss()
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
