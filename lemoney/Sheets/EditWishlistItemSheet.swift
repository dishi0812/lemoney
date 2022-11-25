import SwiftUI

struct EditWishlistItemSheet: View {
    @Binding var categories: [Category]
    @Binding var wishlist: [WishlistItem]
    @State var wishlistItemId: UUID
    @State var type: Int
    @State var categoryId: UUID
    @State var categoryIndex = 0
    @State var name: String
    @State var price: Double
    @State var date: Date
    
    
    var formattedDate: String { dateFormatter().string(for: date)! }
    
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
                                categoryIndex = categories.firstIndex(where: { $0.id != categoryId })!
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
                    .navigationTitle("Edit Wishlist Item")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                if (name != "" && price >= 0.01) {
                                    let wishlistItem = wishlist.first(where: { $0.id == wishlistItemId })!
                                    let oldId = wishlistItem.id
                                    let oldDate = wishlistItem.date
                                    let oldAmtSetAside = wishlistItem.amtSetAside

                                    wishlist[wishlist.firstIndex(where: { $0.id == wishlistItemId })!] = WishlistItem(id: oldId, type: type == 0 ? .need : .want, name: name, price: price, date: getDateFromString(oldDate) != date ? getStringFromDate(date) : oldDate, categoryId: categories[categoryIndex].id, amtSetAside: oldAmtSetAside)
                                    
                                    wishlist = wishlist.sorted(by: {getDateFromString($0.date).timeIntervalSince1970 < getDateFromString($1.date).timeIntervalSince1970})
                                    
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
