//
//  NCUtils+UIView.swift
//  NCUtils
//
//  Created by Caleb Rudnicki on 7/8/21.
//

import UIKit

extension UIView {
    
    /// Adds an array of views to the end of the receiver’s list of subviews.
    /// - Parameter views: The views to be added. After being added, this view appears on top of any other subviews.
    ///
    /// This method piggybacks off of `UIView`'s `addSubview()` method.
    open func addSubviews(_ views: [UIView]) {
        for view in views {
            addSubview(view)
        }
    }
    
}
