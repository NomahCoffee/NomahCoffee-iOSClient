//
//  NCEmailTextField.swift
//  NCUtils
//
//  Created by Caleb Rudnicki on 6/25/21.
//

import UIKit

/// A text field that supports email entries. Text in this text
/// field must meet all of the requirements of being a valid email.
public final class NCEmailTextField: NCTextField {
    
    // MARK: Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        keyboardType = .emailAddress
        autocapitalizationType = .none
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override internal func textFieldDidChange() {
        guard let text = text else { return }
        
        isFulfilled = isValidEmail(text)
    }
    
    // MARK: Private Functions
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}
