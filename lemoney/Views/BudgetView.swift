import SwiftUI

struct BudgetView: View {
    
    @Binding var userSettings: UserSettings
    @Binding var categories: [Category]
    @Binding var wishlist: [WishlistItem]
    @State var selectedCategory = Int()
    
    @State var addExpenseSheetShown = false
//    @State var addCategorySheetShown = false
    @State var categoryId = UUID()
    @State var deleteAlertShown = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach($categories) { $category in
                        NavigationLink {
                            ExpensesView(category: categories.firstIndex(where: {$0.name == category.name})!, userSettings: $userSettings, categories: $categories, wishlist: $wishlist)
                        } label: {
                            HStack {
                                Text(category.name)
                                Spacer()
                                
                                if (category.spendings > category.budget) {
                                    Text("-\(CurrencyFormatter().string(for: Double(category.spendings - category.budget))!)")
                                        .padding(5)
                                        .background(.red)
                                        .cornerRadius(14)
                                        .foregroundColor(.white)
                                        .fontWeight(.semibold)
                                } else {
                                    Text("\(CurrencyFormatter().string(for: Double(category.budget - category.spendings))!)")
                                        .padding(5)
                                        .background(Color("AccentColor"))
                                        .cornerRadius(14)
                                        .foregroundColor(.white)
                                        .fontWeight(.semibold)
                                }
                            }
                        }
                        .listRowBackground(colorScheme == .dark ? Color(.systemGray5) : .white)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                selectedCategory = categories.firstIndex(where: {$0.id == category.id})!
                                addExpenseSheetShown = true
                            } label: {
                                Image(systemName: "plus")
                            }
                            .tint(.green)
                        }
                    }
                    .onMove { indices, newOffset in
                        categories.move(fromOffsets: indices, toOffset: newOffset)
                    }
                }
                Section {
                    NavigationLink {
                        TotalExpenseView(userSettings: $userSettings, categories: $categories, wishlist: $wishlist, viewOnly: false)
                    } label: {
                        HStack {
                            Text("Total")
                                .fontWeight(.bold)
                            Spacer()
                            
                            if (categories.reduce(0) { Double($0) + ($1.budget - $1.spendings) } < 0) {
                                Text("-\(CurrencyFormatter().string(for: Double(abs(categories.reduce(0) { Double($0) + ($1.budget - $1.spendings) })))!)")
                                    .fontWeight(.bold)
                                    .padding(5)
                                    .background(.red)
                                    .cornerRadius(14)
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                            } else {
                                Text("\(CurrencyFormatter().string(for: Double(abs(categories.reduce(0) { Double($0) + ($1.budget - $1.spendings) })))!)")
                                    .fontWeight(.bold)
                                    .padding(5)
                                    .background(Color("AccentColor"))
                                    .cornerRadius(14)
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                    .listRowBackground(colorScheme == .dark ? Color(.systemGray5) : .white)
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Balance: \(CurrencyFormatter().string(for: Double(userSettings.balance))!)")
                        .font(.title3)
                        .padding(.top, 10)
                        .fontWeight(.bold)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        ForEach(categories) { category in
                            Button {
                                selectedCategory = categories.firstIndex(where: {$0.id == category.id})!
                                addExpenseSheetShown = true
                            } label: {
                                Text("\(category.name)")
                            }
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $addExpenseSheetShown) {
                AddExpenseSheet(categoryIndex: selectedCategory, userSettings: $userSettings, categories: $categories)
            }
            //        .sheet(isPresented: $addCategorySheetShown) {
            //            AddCategorySheet(userSettings: $userSettings, categories: $categories)
            //        }
            .alert("Are you sure you want to delete this category?", isPresented: $deleteAlertShown) {
                Button("Delete", role: .destructive) {
                    categories = categories.filter {$0.id != categoryId}
                }
                Button("Cancel", role: .cancel) {}
            }
            .scrollContentBackground(.hidden)
            .background(Color(.systemGray6))
            .navigationTitle("Budget")
        }
    }
}

