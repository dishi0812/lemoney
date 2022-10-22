//
//  Expense.swift
//  lemoney
//
//  Created by T Krobot on 22/10/22.
//

import Foundation

struct Expense: Identifiable {
    var id = UUID()
    
    var name: String
    var price: Double
    
    
}
