import SwiftUI

struct BudgetView: View {
    
    @State var categories: [Category]
    @State var addExpenseSheetShown = false
    @State var addCategorySheetShown = false
    @State var selectedCategory: Int
    @State var deleteAlertShown = false
    @State var categoryId = UUID()
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach($categories) { $category in
                        NavigationLink {
                            ExpensesView(category: categories.firstIndex(where: {$0.name == category.name})!, categories: $categories)
                        } label: {
                            HStack {
                                Text(category.name)
                                Spacer()
                                Text("$\(String(format: "%.2f", category.budget - category.spendings)) Left")
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                selectedCategory = categories.firstIndex(where: {$0.id == category.id})!
                                addExpenseSheetShown = true
                            } label: {
                                Image(systemName: "plus")
                            }
                            .tint(.green)
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button {
                                categoryId = category.id
                                deleteAlertShown = true
                            } label: {
                                Image(systemName: "trash")
                            }
                            .tint(.red)
                        }
                    }
                    .onMove { indices, newOffset in
                        categories.move(fromOffsets: indices, toOffset: newOffset)
                    }
                    HStack {
                        Text("Total")
                            .fontWeight(.bold)
                        Spacer()
                        Text("$\(String(format: "%.2f", categories.reduce(0) { Double($0) + ($1.budget - $1.spendings) })) Left")
                            .fontWeight(.bold)
                    }
                } footer: {
                    Text("Swipe right to add an expense, click to view spendings")
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            selectedCategory = 0
                            addExpenseSheetShown = true
                        } label: {
                            Text("Expense")
                        }
                        Button {
                            addCategorySheetShown = true
                        } label: {
                            Text("Category")
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .navigationTitle("Budget")
        }
        .sheet(isPresented: $addExpenseSheetShown) {
            AddExpenseSheet(categoryIndex: selectedCategory, categories: $categories)
        }
        .sheet(isPresented: $addCategorySheetShown) {
            AddCategorySheet(categories: $categories, budgetGoal: 1200, savingsGoal: 800, balance: 1000)
        }
        .alert("Are you sure you want to delete this category?", isPresented: $deleteAlertShown) {
            Button("Delete", role: .destructive) {
                categories = categories.filter {$0.id != categoryId}
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}

