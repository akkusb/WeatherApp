//
//  Extensions.swift
//  
//
//  Created by Burhan on 11/01/2018.
//  Copyright © 2018 Burhan. All rights reserved.
//

import UIKit

class Extensions: NSObject {

}

extension String
{
    subscript (i: Int) -> Character {
        return self[self.characters.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        //let range = startIndex..<endIndex
        //let substring = string.substring(with: range)
        let start = characters.index(startIndex, offsetBy: r.lowerBound)
        let end = characters.index(start, offsetBy: r.upperBound - r.lowerBound)
        return String(self[Range(start ..< end)])
    }
    
    func maskPhoneNumberForService() -> String
    {
        let result = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        if result.count == 10
        {
            let aa = result[0..<3]
            let bb = result[3..<6]
            let cc = result[6..<8]
            let dd = result[8..<10]
            
            return "0(" + aa + ") " + bb + " " + cc + " " + dd
            
        } else
        {
            return ""
        }
    }
    
    func getPhoneNumberFromService() -> String
    {
        let result = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        if result.count == 11{
            return result[1..<11]
        }
        else if result.count == 10
        {
            return result
            
        } else
        {
            return ""
        }
    }
}

extension Optional where Wrapped == Double{
    func stringValue() -> String {
        var string : String = ""
        if self != nil {
            if self == floor(self!) {
                let intValue : Int = Int(self!)
                string = String(describing: intValue)
            }
            else{
                string = String(describing: self!)
            }
        }
        return string
    }
    
    
    func priceValue() -> String {
        var string : String = ""
        if let double = self{
            let nf = NumberFormatter()
            nf.numberStyle = .decimal
            nf.locale = Locale.init(identifier: "tr")
            nf.minimumFractionDigits = 2
            nf.maximumFractionDigits = 2
            
            if let formattedString = nf.string(from: NSNumber.init(floatLiteral: double)){
                string = String(describing: formattedString)
            }
            
        }
        return string
    }
    
    func discountValue() -> String {
        var string : String = ""
        if let double = self{
            let nf = NumberFormatter()
            nf.numberStyle = .decimal
            nf.locale = Locale.init(identifier: "tr")
            nf.minimumFractionDigits = 2
            nf.maximumFractionDigits = 2
            
            var discount = fabs(double)
            discount = discount * -1
            
            if let formattedString = nf.string(from: NSNumber.init(floatLiteral: discount)){
                string = String(describing: formattedString)
            }
            
        }
        return string
    }
}

extension Double{
    func stringValue() -> String {
        var string : String = ""
        if self == floor(self) {
            let intValue : Int = Int(self)
            string = String(describing: intValue)
        }
        else{
            string = String(describing: self)
        }
        return string
    }
    
    func priceValue() -> String {
        var string : String = ""
        
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.locale = Locale.init(identifier: "tr")
        nf.minimumFractionDigits = 2
        nf.maximumFractionDigits = 2
        
        if let formattedString = nf.string(from: NSNumber.init(floatLiteral: self)){
            string = String(describing: formattedString)
        }

        return string
    }
}

extension Optional where Wrapped == Int{
    func stringValue() -> String {
        var string : String = ""
        if self != nil {
            string = String(describing: self!)
        }
        return string
    }
}

extension Int{
    func stringValue() -> String {
        var string : String = ""
        string = String(describing: self)
        return string
    }
}

extension Optional where Wrapped == String{
    
    func stringValue() -> String {
        var string : String = ""
        if self != nil {
            string = String(describing: self!)
        }
        return string
    }
    
    var lowercasedWithFirstUppercased : String{
        guard let string = self else { return "" }
        return string.lowercased(with: Locale.init(identifier: "tr")).firstUppercased
    }
}

extension Optional where Wrapped == Date{
    
    func stringValue() -> String {
        var string : String = ""
        if let date = self {
            let formatter : DateFormatter = DateFormatter()
            formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss"
            string = formatter.string(from: date)
        }
        return string
    }
}

extension NSAttributedString {
    
    convenience init(htmlString html: String) throws {
        try self.init(data: Data(html.utf8), options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
            ], documentAttributes: nil)
    }
    
}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        let sub = self[fromIndex...]
        return String(sub)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        let sub = self[..<toIndex]
        return String(sub)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        let sub = self[startIndex..<endIndex]
        return String(sub)
    }
    
//    func addFontTag(font: UIFont) -> NSString
//    {
//        return ("<style>body{font-family:'" + font.fontName + "';</style>" + (self as String)) as NSString
//    }
    
    
    func addFontTag(font: UIFont) -> String
    {
        return ("<style>body{font-family:'" + font.fontName + "';</style>" + self) as String
    }
    
    func isEmailValid() -> Bool
    {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        return emailTest.evaluate(with: self)
    }
    
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: characters.count)) != nil
        
    }
    
    func numeric() -> String
    {
        return self.components(separatedBy: CharacterSet(charactersIn: "01234567890.").inverted).joined(separator: "")
    }
    
    // Short sale code count is 6
    func shortOrderSaleCode() -> String
    {
        if self.count > 6 {
            return self.substring(from: self.count - 6)
        }
        else if self.count > 0{
            return self
        }
        else{
            return ""
        }
    }
    
//    var firstUppercased: String {
//        guard let first = first else { return "" }
//        return String(first).uppercased(with: Locale(identifier: "tr")) + dropFirst()
//    }
    
    var lowercasedWithFirstUppercased : String{
        guard first != nil else { return "" }
        return lowercased(with: Locale.init(identifier: "tr")).firstUppercased
    }
}

extension StringProtocol {
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased(with: Locale(identifier: "tr")) + dropFirst()
    }
    
    var lowercasedWithFirstUppercased : String{
        guard first != nil else { return "" }
        return lowercased().firstUppercased
    }
}

extension Date
{
    func stringValue() -> String
    {
        var string : String = ""
        let formatter : DateFormatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss"
        string = formatter.string(from: self)
        return string
    }
    
    static func fromString(_ dateString:String?) -> Date?
    {
        if var dateString = dateString
        {
            if let fixedDateString = dateString.components(separatedBy: ".").first
            {
                dateString = fixedDateString
            }
            
            let formatter : DateFormatter = DateFormatter()
            formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss"
            return formatter.date(from: dateString)
        }
        
        return nil
    }
    
    func toReadableString() -> String
    {
        var string : String = ""
        let formatter : DateFormatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        string = formatter.string(from: self)
        return string
    }
    
//    func isBetween(startDate:Date, endDate:Date)->Bool
//    {
//        return (startDate.compare(self) == .orderedAscending) && (endDate.compare(self) == .orderedDescending)
//    }
    
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
}
