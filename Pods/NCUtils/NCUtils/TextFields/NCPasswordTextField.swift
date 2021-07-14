//
//  NCPasswordTextField.swift
//  NCUtils
//
//  Created by Caleb Rudnicki on 6/25/21.
//

import UIKit

/// A text field that supports password entries. Text in this
/// text field are hidden and must have more than 7 characters.
public final class NCPasswordTextField: NCTextField {
    
    // MARK; Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        autocapitalizationType = .none
        isSecureTextEntry = true        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Action Functions
    
    override internal func textFieldDidChange() {
        guard let text = text else { return }
        
        isFulfilled = isValidPassword(text)
    }
    
    // MARK: Private Functions
    
    private func isValidPassword(_ password: String) -> Bool {
        return password.count > 7
    }

}
