//
//  NCPriceTextField.swift
//  NCUtils
//
//  Created by Caleb Rudnicki on 6/29/21.
//

import UIKit

/// A text field that supports price entries. Text in this
/// text field must meet the requirements to be a valid price.
public final class NCPriceTextField: NCTextField {
    
    // MARK: Properties
    
    /// The `Double` representation of the vlaue displayed in the text field.
    /// Use this value to convert the value in the text field to a usable value type.
    ///
    /// Examples: `$1.22` -> `1.22`, `$19.95` -> `19.95`
    public var doubleValue: Double = 0.0
    
    // MARK: Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        keyboardType = .numberPad
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Functions
    
    /// Preset the value of a price text field.
    ///
    /// Use this function when you want to preset a value to be a price. If you were
    /// to just set the text like `textField.text = "3.0"`, the value of the text field
    /// will not look like the price value of `$3.00` that is intended. Instead, use
    /// this function will allow you to set the text with a `Double` value.
    /// - Parameter price: a `Double` value of the preset dollar amount to be set the text field with
    public func setText(with price: Double) {
        self.text = price.usdFormatted
        doubleValue = price
    }
    
    // MARK: Action Functions
    
    override internal func textFieldDidChange() {
        guard let text = text else { return }
        
        self.text = text.usdFormatted
        isFulfilled = text.usdFormatted != ""
        doubleValue = Double(text.usdFormatted.replacingOccurrences(of: "$", with: "")) ?? 0.0
    }

}

extension Double {
    
    /// A converted `Double` to be shown in US dollar format.
    ///
    /// Examples: `122` -> `$1.22`, `1995` -> `19.95`
    var usdFormatted: String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        guard let price = formatter.string(from: self as NSNumber) else { return "0.0" }
            
        return price
    }
    
}

extension String {
    
    /// A converted `String` to be shown in US dollar format.
    ///
    /// Examples: `122` -> `$1.22`, `1995` -> `19.95`
    var usdFormatted: String {
        // Create the number formatter
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currencyAccounting
        numberFormatter.currencySymbol = "$"
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        
        // Instantiating variables to be manipulated later
        var number: NSNumber
        var amountWithPrefix = self

        // Removing unused characters (i.e. "$", ".", ",")
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix,
                                                          options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                                          range: NSMakeRange(0, count),
                                                          withTemplate: "")

        
        // Grab the value of the string
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // Pass if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else { return "" }
        
        return numberFormatter.string(from: number)!
    }
    
}
