//
//  NCTextView.swift
//  NCUtils
//
//  Created by Caleb Rudnicki on 6/29/21.
//

import UIKit

/// A generic `UITextView` subclass with some of sylings like
/// `borderWidth` and `cornerRadius` preset. This class
/// can be subclassed for more customizable text views.
open class NCTextView: UITextView, UITextViewDelegate {
    
    // MARK: Properties
    
    /// Describes whether or not a text view has all of its specific
    /// requirements completely satisfied.
    ///
    /// For example, if a basic `NCTextView` were used, then this value
    /// would be `false` if there are 2 or fewer characters and `true`
    /// if there are 3 or more characters.
    ///
    /// You may also autoset this value if you need to like
    /// ```textView.isFulfilled = true```. The default value is `false`.
    open var isFulfilled: Bool = false {
        didSet {
            layer.borderColor = isFulfilled ?
                Constants.Color.fulfilled :
                Constants.Color.unfulfilled
        }
    }
    
    /// The placeholder text that will populate the text view in the abscence
    /// user inputted text.
    open var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    open override var text: String? {
        didSet {
            // Setting the placeholder to be hidden if a user presets the text value
            placeholderLabel.isHidden = true
        }
    }
    
    private var isEmpty: Bool = true {
        didSet {
            placeholderLabel.isHidden = !isEmpty
        }
    }
    
    private var placeholderLabel: UILabel = {
        var placeholderLabel = UILabel()
        placeholderLabel.numberOfLines = 0
        placeholderLabel.textColor = .tertiaryLabel
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        return placeholderLabel
    }()
    
    // MARK: Init
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        addSubview(placeholderLabel)
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: textContainerInset.top),
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.textInset),
            placeholderLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.Layout.textInset),
            placeholderLabel.widthAnchor.constraint(equalTo: widthAnchor)
        ])
        
        textColor = .label
        
        isSelectable = true
        isEditable = true
        
        layer.borderWidth = Constants.Layout.inactiveBorderWidth
        layer.borderColor = Constants.Color.fulfilled
        layer.cornerRadius = Constants.Layout.cornerRadius
        
        font = placeholderLabel.font
        
        delegate = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
        
    // MARK: Action Functions
    
    /// This function is fired everytime any text within the text view changes
    /// (i.e. a character is added, a character is deleted).
    ///
    /// Override this function to change the functionality of events that occurs
    /// when a text view did change. In its basic form, this function fulfills
    /// a text view if the number of characters is greater than 2.
    public func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        
        isEmpty = text.count == 0
        isFulfilled = text.count > 2
    }
    
    /// This function is fired any time a user first taps into the text view.
    ///
    /// In its basic form, this function fulfills a text view if the number of
    /// characters is greater than 2 and it also increases the border width of
    /// the text view.
    public func textViewDidBeginEditing(_ textView: UITextView) {
        guard let text = textView.text else { return }
        
        isFulfilled = text.count > 2
        layer.borderWidth = Constants.Layout.activeBorderWidth
    }
    
    /// This function is fired any time a user taps out of a text view.
    ///
    /// In its basic form, this function decreases the border width
    /// of the text view.
    public func textViewDidEndEditing(_ textView: UITextView) {
        layer.borderWidth = Constants.Layout.inactiveBorderWidth
    }

}
