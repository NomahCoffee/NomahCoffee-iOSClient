//
//  MembershipConstants.swift
//  AuthKit
//
//  Created by Caleb Rudnicki on 7/7/21.
//

import Foundation

struct MembershipConstants {
    
    struct Login {
        static let headerTitle: String = "Log in to Nomah Coffee Admin"
        static let emailTextFieldPlaceholder: String = "Email address"
        static let passwordTextFieldPlaceholder: String = "Password"
        static let toggleButtonTitle: String = "Go to sign up"
        static let submitButtonTitle: String = "Log in"
    }
    
    struct Signup {
        static let headerTitle: String = "Sign up for Nomah Coffee Admin"
        static let emailTextFieldPlaceholder: String = "Email address"
        static let usernameTextFieldPlaceholder: String = "Username"
        static let firstNameTextFieldPlaceholder: String = "First name"
        static let lastNameTextFieldPlaceholder: String = "Last name"
        static let passwordTextFieldPlaceholder: String = "Password"
        static let repasswordTextFieldPlaceholder: String = "Password (again)"
        static let toggleButtonTitle: String = "Go to log in"
        static let submitButtonTitle: String = "Sign up"
    }
    
    static let stackSpacing: CGFloat = 8
    static let stackHorizontalInset: CGFloat = 8
    static let submitButtonHeight: CGFloat = 64
    
}
