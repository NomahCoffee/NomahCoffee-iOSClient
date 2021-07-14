//
//  NCTextField.swift
//  NCUtils
//
//  Created by Caleb Rudnicki on 6/25/21.
//

import UIKit

/// A generic `UITextField` subclass with some of sylings like
/// `borderWidth`, `textInsets`, and `cornerRadius` preset. This
/// class can be subclassed for more customizable text fields.
open class NCTextField: UITextField {
    
    // MARK: Properties
    
    /// Describes whether or not a text field has all of its specific
    /// requirements completely satisfied.
    ///
    /// For example, if a basic `NCTextField` were used, then this value
    /// would be `false` if there are 2 or fewer characters and `true`
    /// if there are 3 or more characters.
    ///
    /// You may also autoset this value if you need to like
    /// ```textField.isFulfilled = true```. The default value is `false`.
    open var isFulfilled: Bool = false {
        didSet {
            layer.borderColor = isFulfilled ?
                Constants.Color.fulfilled :
                Constants.Color.unfulfilled
        }
    }
    
    private var textInsets = UIEdgeInsets(top: Constants.Layout.textInset,
                                  left: Constants.Layout.textInset,
                                  bottom: Constants.Layout.textInset,
                                  right: Constants.Layout.textInset) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = Constants.Layout.inactiveBorderWidth
        layer.borderColor = Constants.Color.fulfilled
        layer.cornerRadius = Constants.Layout.cornerRadius
        
        addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
        addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Override Functions
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    open override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    // MARK: Action Functions
    
    /// This function is fired everytime any text within the text field changes
    /// (i.e. a character is added, a character is deleted).
    ///
    /// Override this function to change the functionality of events that occurs
    /// when a text field did change. In its basic form, this function fulfills
    /// a text field if the number of characters is greater than 2.
    @objc internal func textFieldDidChange() {
        guard let text = text else { return }
        
        isFulfilled = text.count > 2
    }
    
    /// This function is fired any time a user first taps into the text field.
    ///
    /// In its basic form, this function fulfills a text field if the number of
    /// characters is greater than 2 and it also increases the border width of
    /// the text field.
    @objc internal func textFieldDidBeginEditing() {
        guard let text = text else { return }
        
        isFulfilled = text.count > 2
        layer.borderWidth = Constants.Layout.activeBorderWidth
    }
    
    /// This function is fired any time a user taps out of a text field.
    ///
    /// In its basic form, this function decreases the border width
    /// of the text field.
    @objc internal func textFieldDidEndEditing() {
        layer.borderWidth = Constants.Layout.inactiveBorderWidth
    }
    
}
