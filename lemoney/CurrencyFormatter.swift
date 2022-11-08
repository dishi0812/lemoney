//
//  CurrencyFormatter.swift
//  lemoney
//
//  Created by TinkerTanker on 8/11/22.
//

import Foundation

func CurrencyFormatter() -> Formatter {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .currency
    numberFormatter.locale = Locale.current
    
    return numberFormatter
}
