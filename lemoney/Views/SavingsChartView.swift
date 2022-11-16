//
//  SavingsChartView.swift
//  lemoney
//
//  Created by TinkerTanker on 13/11/22.
//

import SwiftUI
import Charts

struct SavingsChartView: View {
    
    @State var overviews: [MonthOverview]
    @State var type = 0
    @State var monthDistribution = 0
    
    var keys: [String] { Array(overviews[monthDistribution].categories.keys) }
    
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .edgesIgnoringSafeArea(.all)
            
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
                        Chart {
                            ForEach(overviews) { overview in
                                BarMark(
                                    x: .value("Month", overview.month),
                                    y: .value("Savings", overview.savings)
                                )
                                .annotation { Text("$\(String(format: "%.2f", overview.savings))").font(.caption) }
                            }
                        }
                        .frame(height: 300)
                        .padding(12)
                    }
                } else if (type == 1) {
                    List {
                        Section {
                            Picker("Month", selection: $monthDistribution) {
                                ForEach(0..<overviews.count) { i in
                                    Text("\(overviews[i].month)")
                                }
                            }
                            
                            PieChart(overview: overviews[monthDistribution], keys: keys)
                                .frame(width: 330, height: 330)
                        }
                        Section {
                            ForEach(Array(overviews[monthDistribution].categories.keys), id: \.self) { key in
                                HStack {
                                    Text(key)
                                    Spacer()
                                    Text("$\(String(format: "%.2f", overviews[monthDistribution].categories[key]!))")
                                        .fontWeight(.bold)
                                }
                            }
                        }
                        Section {
                            HStack {
                                Text("Total Spendings")
                                    .fontWeight(.bold)
                                Spacer()
                                Text("$\(String(format: "%.2f", overviews[monthDistribution].spendings))")
                                    .fontWeight(.black)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Savings")
        .onAppear {
            monthDistribution = overviews.count - 1
        }
    }
}

