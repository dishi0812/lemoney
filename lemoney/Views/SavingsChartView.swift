import SwiftUI
import Charts

struct SavingsChartView: View {
    
    @State var overviews: [MonthOverview]
    @State var type = 0
    @State var monthDistribution = 0
    
    let savings: Double
    let savingsThisMonth: Double
    
    var keys: [String] { Array(overviews[monthDistribution].categories.keys) }
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .edgesIgnoringSafeArea(.all)
            
            if (overviews.count > 0) {
                VStack {
                    Picker("Type", selection: $type) {
                        ForEach(0..<2) { i in
                            if (i == 0) {
                                Text("Savings")
                                    .font(.subheadline)
                            } else {
                                Text("Distribution")
                                    .font(.subheadline)
                            }
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 300)
                    
                    if (type == 0) {
                        List {
                            Section {
                                Chart {
                                    ForEach(overviews) { overview in
                                        BarMark(
                                            x: .value("Month", overview.month),
                                            y: .value("Savings", overview.savings)
                                        )
                                        .annotation { Text("\(CurrencyFormatter().string(for: Double(overview.savings))!)").font(.caption) }
                                    }
                                }
                                .listRowBackground(colorScheme == .dark ? Color(.systemGray5) : Color(.white))
                                .frame(height: 300)
                                .padding(12)
                            }
                            
                            Section {
                                HStack {
                                    Text("Previous Months' Savings")
                                        .fontWeight(.bold)
                                    Spacer()
                                    Text("\(CurrencyFormatter().string(for: Double(savings))!)")                                        .fontWeight(.black)
                                }
                                .listRowBackground(colorScheme == .dark ? Color(.systemGray5) : Color(.white))
                            }
                            Section {
                                HStack {
                                    Text("Savings This Month")
                                        .fontWeight(.bold)
                                    Spacer()
                                    Text("$\(CurrencyFormatter().string(for: Double(savingsThisMonth))!)")
                                        .fontWeight(.black)
                                }
                                .listRowBackground(colorScheme == .dark ? Color(.systemGray5) : Color(.white))
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .background(Color(.systemGray6))
                    } else if (type == 1) {
                        List {
                            Section {
                                Picker("Month", selection: $monthDistribution) {
                                    ForEach(0..<overviews.count) { i in
                                        Text("\(overviews[i].month)")
                                    }
                                }
                                .listRowBackground(colorScheme == .dark ? Color(.systemGray5) : Color(.white))
                                
                                PieChart(overview: overviews[monthDistribution], keys: keys)
                                    .frame(width: 330, height: 330)
                                    .listRowBackground(colorScheme == .dark ? Color(.systemGray5) : Color(.white))
                            }
                            Section {
                                ForEach(Array(overviews[monthDistribution].categories.keys), id: \.self) { key in
                                    if (key != "Savings") {
                                        HStack {
                                            Text(key)
                                            Spacer()
                                            Text("$\(CurrencyFormatter().string(for: Double(overviews[monthDistribution].categories[key]!))!)") 
                                                .fontWeight(.bold)
                                        }
                                        .listRowBackground(colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray6))
                                    }
                                }
                            }
                            Section {
                                HStack {
                                    Text("Total Spendings")
                                        .fontWeight(.bold)
                                    Spacer()
                                    Text("\(CurrencyFormatter().string(for: Double(overviews[monthDistribution].spendings))!)")
                                        .fontWeight(.black)
                                }
                                .listRowBackground(colorScheme == .dark ? Color(.systemGray5) : Color(.white))
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .background(Color(.systemGray6))
                    }
                }
            } else {
                VStack {
                    Spacer()
                    VStack {
                        Text("No Data Available")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom, 8)
                        Text("Wait until next month to see the overview.")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    .padding(15)
                    .background(colorScheme == .dark ? Color(.systemGray5) : Color(.white))
                    .cornerRadius(12)
                    Spacer()
                }
            }
        }
        .navigationTitle("Savings")
        .onAppear {
            monthDistribution = overviews.count - 1
        }
    }
}
