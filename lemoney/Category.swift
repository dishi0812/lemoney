//
//  Category.swift
//  lemoney
//
//  Created by T Krobot on 22/10/22.
//

import Foundation

struct Category: Identifiable {
    var id = UUID()
    
    var name: String;
    var expenses: [Expense] = []
    var spendings: Double
    var budget: Double
}
