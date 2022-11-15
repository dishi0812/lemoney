//
//  PieChart.swift
//  lemoney
//
//  Created by TinkerTanker on 13/11/22.
//

import SwiftUI

struct PiePiece: Shape {
    let startDegree: Double
    let endDegree: Double
    
    func path(in rect: CGRect) -> Path {
        Path { p in
            let center = CGPoint(x: rect.midX, y: rect.midY)
            p.move(to: center)
            p.addArc(center: center, radius: rect.width/2, startAngle: Angle(degrees: startDegree), endAngle: Angle(degrees: endDegree), clockwise: false)
            p.closeSubpath()
        }
    }
}

struct PieChart: View {
    let overview: MonthOverview
    let keys: [String]
    
    var degrees: [Double] {
        var degreesList: [Double] = [0]
        for (_, val) in overview.categories {
            degreesList.append((val / (overview.spendings + overview.savings) * 360) + degreesList[degreesList.count - 1])
        }
        return degreesList
    }
    
    var body: some View {
        ZStack {
            ForEach(1..<keys.count+1) { i in
                let currentKey = keys[i-1]
                let currentValue = overview.categories[currentKey]!
                
                let currentDegree = degrees[i]
                let prevDegree = degrees[i-1]
                
                if (overview.categories.count == 6) {
                    PiePiece(startDegree: prevDegree, endDegree: currentDegree)
                        .fill(Color("\(currentKey)"))
                        .zIndex(-100)
                } else {
                    PiePiece(startDegree: prevDegree, endDegree: currentDegree)
                        .fill(Color(uiColor: UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1)))
                        .zIndex(-100)
                }
                
                if (currentValue != 0) {
                    GeometryReader { geometry in
                        
                        let percentage = String(format: "%.1f", currentValue/(overview.spendings + overview.savings)*100)
                        VStack {
                            Text("\(currentKey)")
                            Text("\(percentage)%")
                        }
                        .foregroundColor(.white)
                        .position(getLabelCoordinate(in: geometry.size, for: currentDegree - (currentDegree-prevDegree)/2, mode: "Text"))
                    }
                    .zIndex(100)
                    .font(.caption)
                    .fontWeight(.bold)
                }
            }
        }
    }
    
    private func getLabelCoordinate(in geoSize: CGSize, for degree: Double, mode: String) -> CGPoint {
        let center = CGPoint(x: geoSize.width / 2, y: geoSize.height / 2)
        
        let radius = mode == "Text" ? geoSize.width / 3 : geoSize.width / 1.7
        
        let yCoordinate = radius * sin(CGFloat(degree) * (CGFloat.pi / 180))
        let xCoordinate = radius * cos(CGFloat(degree) * (CGFloat.pi / 180))
        
        return CGPoint(x: center.x + xCoordinate, y: center.y + yCoordinate)
    }
}
