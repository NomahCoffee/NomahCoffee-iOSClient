//
//  NCUtils+UIStackView.swift
//  NCUtils
//
//  Created by Caleb Rudnicki on 7/8/21.
//

import UIKit

extension UIStackView {
    
    /// Adds an array of views to the end of the arrangedSubviews array.
    /// - Parameter views: The views to be added to the array of views arranged by the stack
    ///
    /// This method piggybacks off of `UIStackView`'s `addArrangedSubview()` method.
    open func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            addArrangedSubview(view)
        }
    }
    
}
