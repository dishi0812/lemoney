import SwiftUI

struct BudgetView: View {
    
    @Binding var categories: [Category]
    @State var selectedCategory = Int()
    
    @State var addExpenseSheetShown = false
    @State var addCategorySheetShown = false
    @State var categoryId = UUID()
    @State var deleteAlertShown = false
    @State var unableToDeleteAlert = false
    
    @Binding var budgetGoal: Double
    @Binding var savingsGoal: Double
    @Binding var balance: Double
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach($categories) { $category in
                        NavigationLink {
                            ExpensesView(category: categories.firstIndex(where: {$0.name == category.name})!, categories: $categories, budgetGoal: $budgetGoal, savingsGoal: $savingsGoal, balance: $balance)
                        } label: {
                            HStack {
                                Text(category.name)
                                Spacer()
                                
                                if (category.budget - category.spendings <= 0.00) {
                                    Text("$\(String(format: "%.2f", category.spendings - category.budget))")
                                        .padding(5)
                                        .background(.red)
                                        .cornerRadius(14)
                                        .foregroundColor(.white)
                                        .fontWeight(.semibold)
                                } else {
                                    Text("$\(String(format: "%.2f", category.budget - category.spendings))")
                                        .padding(5)
                                        .background(.green)
                                        .cornerRadius(14)
                                        .foregroundColor(.white)
                                        .fontWeight(.semibold)
                                }
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
                                if (!category.isStartingCategory) {
                                    categoryId = category.id
                                    deleteAlertShown = true
                                } else {
                                    unableToDeleteAlert = true
                                }
                            } label: {
                                Image(systemName: "trash")
                            }
                            .tint(.red)
                        }
                    }
                    .onMove { indices, newOffset in
                        categories.move(fromOffsets: indices, toOffset: newOffset)
                    }
                }
                Section {
                    HStack {
                        Text("Total")
                            .fontWeight(.bold)
                        Spacer()
                        
                        if (categories.reduce(0) { Double($0) + ($1.budget - $1.spendings) } <= 0.00) {
                            Text("$\(String(format: "%.2f", abs(categories.reduce(0) { Double($0) + ($1.budget - $1.spendings) })))")
                                .fontWeight(.bold)
                                .padding(5)
                                .background(.red)
                                .cornerRadius(14)
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                        } else {
                            Text("$\(String(format: "%.2f", abs(categories.reduce(0) { Double($0) + ($1.budget - $1.spendings) })))")
                                .fontWeight(.bold)
                                .padding(5)
                                .background(.green)
                                .cornerRadius(14)
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                        }
                    }
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
            AddExpenseSheet(categoryIndex: selectedCategory, categories: $categories, budgetGoal: $budgetGoal, savingsGoal: $savingsGoal, balance: $balance)
        }
        .sheet(isPresented: $addCategorySheetShown) {
            AddCategorySheet(categories: $categories, budgetGoal: $budgetGoal, savingsGoal: $savingsGoal, balance: $balance)
        }
        .alert("Are you sure you want to delete this category?", isPresented: $deleteAlertShown) {
            Button("Delete", role: .destructive) {
                categories = categories.filter {$0.id != categoryId}
            }
            Button("Cancel", role: .cancel) {}
        }
        .alert("Unable to delete category", isPresented: $unableToDeleteAlert) {
            Button("OK", role: .cancel) {}
        }
    }
}
