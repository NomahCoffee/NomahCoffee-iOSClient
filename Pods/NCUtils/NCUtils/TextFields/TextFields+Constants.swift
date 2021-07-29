//
//  TextFields+Constants.swift
//  NCUtils
//
//  Created by Caleb Rudnicki on 6/25/21.
//

import UIKit

/// Holds all of constants associated with the TextFields group
internal struct Constants {
    
    /// Holds all of the color constants
    struct Color {
        /// The color used when a text field is completely satified
        static let fulfilled: CGColor = UIColor.label.cgColor
        
        /// The color used when a text field is not yet completely satisfied
        static let unfulfilled: CGColor = UIColor.red.cgColor
    }
    
    /// Holds any of the constants associated with laying out the views
    struct Layout {
        /// The width of an inactive text field's border
        static let inactiveBorderWidth: CGFloat = 0
        
        /// The width of an active text field's border
        static let activeBorderWidth: CGFloat = 2
        
        /// The radius of the text field's corner
        static let cornerRadius: CGFloat = 16
        
        /// The inset to be used for the text field's padding
        static let textInset: CGFloat = 4
        
        /// An additional padding added to the top of a text view
        static let additionalTextViewPadding: CGFloat = 12
    }
    
}
