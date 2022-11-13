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
    var keys: [String] { Array(overview.categories.keys) }
    
    var degrees: [Double] {
        var degreesList: [Double] = [0]
        for (_, val) in overview.categories {
            degreesList.append((val / overview.spendings * 360) + degreesList[degreesList.count - 1])
        }
        return degreesList
    }
    
    
    var body: some View {
        ZStack {
            ForEach(1..<overview.categories.count+1) { i in
                
                let currentKey = keys[i-1]
                let currentValue = overview.categories[currentKey]!
                
                let currentDegree = degrees[i]
                let prevDegree = degrees[i-1]
                
                PiePiece(startDegree: prevDegree, endDegree: currentDegree)
                    .fill(Color(uiColor: UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1)))
                
                if (currentValue != 0) {
                    GeometryReader { geometry in
                        VStack {
                            Text("\(currentKey)")
                            Text("\(String(format: "%.1f", currentValue/overview.spendings*100))%")
                            Text("$\(String(format: "%.2f", currentValue))")
                        }
                        .font(.subheadline)
                        .position(getLabelCoordinate(in: geometry.size, for: currentDegree - (currentDegree-prevDegree)/2))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                    }
                }
            }
        }
    }
    
    private func getLabelCoordinate(in geoSize: CGSize, for degree: Double) -> CGPoint {
        let center = CGPoint(x: geoSize.width / 2, y: geoSize.height / 2)
        let radius = geoSize.width / 3.5
        
        let yCoordinate = radius * sin(CGFloat(degree) * (CGFloat.pi / 180))
        let xCoordinate = radius * cos(CGFloat(degree) * (CGFloat.pi / 180))
        
        return CGPoint(x: center.x + xCoordinate, y: center.y + yCoordinate)
    }
}

struct PieChart_Previews: PreviewProvider {
    static var previews: some View {
        PieChart(overview: MonthOverview(categories: ["Transport": 50.00, "Food": 50.00, "Clothes": 50.00], spendings: 150.00, savings: 100.00, month: "Jan"))
    }
}
