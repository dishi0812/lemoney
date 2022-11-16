import SwiftUI

struct MonthOverviewView: View {
    
    let month: Date
    @Binding var overviews: [MonthOverview]
    @Binding var categories: [Category]
    @Binding var userSettings: [String:Double]
    
    
    var keys: [String] { Array(overviews[overviews.count - 1].categories.keys) }
    
    var totalSpendings: Double {
        categories.reduce(0) { $0 + $1.spendings }
    }
    var savings: Double {
        userSettings["income"]! - totalSpendings
    }
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color(.systemGray6)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Spacer()
                        
                        NavigationLink {
                            SavingsChartView(overviews: overviews)
                        } label: {
                            HStack {
                                Image(systemName: "dollarsign.arrow.circlepath")
                                    .font(.title)
                                    .padding(.trailing, -3)
                                    .padding(.leading, -5)
                                
                                VStack {
                                    Text("$\(String(format: "%.2f", savings))").fontWeight(.bold)
                                    Text("Savings").fontWeight(.semibold)
                                }
                                
                                Image(systemName: "chevron.right")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundColor(Color(colorScheme == .dark ? .white : .systemGray3))
                            }
                            .padding(10)
                        }
                        .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                        .background(Color(colorScheme == .dark ? .systemGray6 : .white))
                        .cornerRadius(15)
                        
                        Spacer()
                        
                        NavigationLink {
                            TotalExpenseView(userSettings: $userSettings, categories: $categories, viewOnly: true)
                        } label: {
                            HStack {
                                ZStack {
                                    Image(systemName: "dollarsign.circle")
                                        .font(.title)
                                        .padding(.trailing, -3)
                                        .padding(.leading, -5)
                                    
                                    Image(systemName: "arrow.down")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .padding(.top, 20)
                                        .padding(.leading, 15)
                                        .padding(.trailing, -3)
                                }
                                
                                VStack {
                                    Text("$\(String(format: "%.2f", totalSpendings))").fontWeight(.bold)
                                    Text("Spent").fontWeight(.semibold)
                                }
                                
                                Image(systemName: "chevron.right")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundColor(Color(colorScheme == .dark ? .white : .systemGray3))
                            }
                            .padding(10)
                        }
                        .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                        .background(Color(colorScheme == .dark ? .systemGray6 : .white))
                        .cornerRadius(15)
                        
                        Spacer()
                    }
                    .padding(15)
                    .padding(.bottom, -10)
                    
                    
                    VStack {
                        List {
                            Section {
                                VStack {
                                    PieChart(overview: overviews[overviews.count - 1], keys: keys)
                                        .frame(width: 340, height: 340)
                                    
                                    VStack {
                                        Text("Swipe Up for Details")
                                            .font(.caption)
                                            .padding(.bottom, 5)
                                        Image(systemName: "chevron.down")
                                            .font(.subheadline)
                                    }
                                    .opacity(0.5)
                                }
                            }
                            Section {
                                ForEach(categories, id: \.id) { category in
                                    let isOverBudget = category.spendings > category.budget
                                    HStack {
                                        Text(category.name)
                                        Spacer()
                                        Text("$\(String(format: "%.2f", category.spendings))")
                                            .fontWeight(.bold)
                                            .padding(5)
                                            .background(isOverBudget ? .red : Color("AccentColor"))
                                            .cornerRadius(14)
                                            .foregroundColor(.white)
                                            .fontWeight(.semibold)
                                    }
                                }
                            }
                            Section {
                                HStack {
                                    Text("Total Spendings")
                                        .fontWeight(.bold)
                                    Spacer()
                                    Text("$\(String(format: "%.2f", overviews[overviews.count-1].spendings))")
                                        .fontWeight(.black)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        if (overviews[overviews.count - 1].spendings > userSettings["savingsGoal"]!) {
                            Text("You have overspent this month!")
                                .foregroundColor(.red)
                                .font(.footnote)
                                .padding(.top, 10)
                                .padding(.bottom, -3)
                        }
                        NavigationLink {
                            SetupView(userSettings: $userSettings, categories: $categories, pageNum: 2, isFirstLaunch: false)
                        } label: {
                            Text("Update Goals")
                                .padding(12)
                                .background(Color("AccentColor"))
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .font(.headline)
                                .cornerRadius(25)
                        }
                    }
                    
                    Button {
                        userSettings["balance"]! += userSettings["income"]!
                        for i in 0..<categories.count {
                            categories[i].expenses = []
                        }
                        dismiss()
                    } label: {
                        Text("Continue")
                            .frame(width: 320)
                            .padding(12)
                            .background(Color("AccentColor"))
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.headline)
                            .cornerRadius(10)
                    }
                    .padding(.top, 5)
                    .navigationTitle("Month Overview")
                }
                .interactiveDismissDisabled()
            }
        }
    }
}
