import SwiftUI

struct MonthOverviewView: View {
    
    let month: Date
    @Binding var overviews: [MonthOverview]
    @Binding var categories: [Category]
    @Binding var userSettings: [String:Double]
    
    var totalSpendings: Double {
        categories.reduce(0) { $0 + $1.spendings }
    }
    var savings: Double {
        userSettings["income"]! - totalSpendings
    }
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color(.systemGray6)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Spacer()
                        
                        NavigationLink {
                            SavingsChartView(savings: overviews)
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
                                    .foregroundColor(Color(.systemGray3))
                            }
                            .padding(10)
                        }
                        .background(.white)
                        .foregroundColor(.black)
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
                                    .foregroundColor(Color(.systemGray3))
                            }
                            .padding(10)
                        }
                        .foregroundColor(.black)
                        .background(.white)
                        .cornerRadius(15)
                        
                        Spacer()
                    }
                    .padding(15)
                    .padding(.bottom, -20)
                    
                    
                    VStack {
                        List {
                            PieChart(overview: overviews[overviews.count - 1])
                                .frame(height: 340)
                        }
                        
                        if (overviews[overviews.count - 1].spendings > userSettings["savingsGoal"]!) {
                            Text("You have overspent this month!")
                                .foregroundColor(.red)
                                .font(.footnote)
                        }
                        NavigationLink {
                            SetupView(userSettings: $userSettings, categories: $categories, pageNum: 2, isFirstLaunch: false)
                        } label: {
                            Text("Update Goals")
                                .padding(12)
                                .background(.green)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .font(.headline)
                                .cornerRadius(25)
                        }
                    }
                    
                    Spacer()
                    
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
                            .background(.green)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.headline)
                            .cornerRadius(10)
                    }
                    .padding(.top, 35)
                    .navigationTitle("Month Overview (\(month.formatted(.dateTime.month())))")
                }
                .interactiveDismissDisabled()
            }
        }
    }
}
