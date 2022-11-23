import Foundation

func CurrencyFormatter() -> Formatter {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .currency
    numberFormatter.locale = Locale.current
    
    return numberFormatter
}

func dateFormatter() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
    
    return dateFormatter
}

func getStringFromDate(_ date: Date) -> String {
    return dateFormatter().string(for: date)!
}

func getDateFromString(_ string: String) -> Date {
    return dateFormatter().date(from: string)!
}
