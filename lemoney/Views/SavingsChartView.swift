//
//  SavingsChartView.swift
//  lemoney
//
//  Created by TinkerTanker on 13/11/22.
//

import SwiftUI
import Charts

struct SavingsChartView: View {
    
    @State var savings: [MonthOverview]
    @State var type = 0
    @State var monthDistribution = 0
    
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
                
                List {
                    if (type == 0) {
                        Chart {
                            ForEach(savings) { overview in
                                BarMark(
                                    x: .value("Month", overview.month),
                                    y: .value("Savings", overview.savings)
                                )
                                .annotation { Text("$\(String(format: "%.2f", overview.savings))").font(.caption) }
                            }
                        }
                        .frame(height: 300)
                        .padding(12)
                    } else if (type == 1) {
                        Picker("Month", selection: $monthDistribution) {
                            ForEach(0..<savings.count) { i in
                                Text("\(savings[i].month)")
                            }
                        }
                        
                        PieChart(overview: savings[monthDistribution])
                        
                        .frame(height: 300)
                        .padding(12)
                    }
                }
                .navigationTitle("Savings")
            }
        }
        .onAppear {
            monthDistribution = savings.count - 1
        }
    }
}

