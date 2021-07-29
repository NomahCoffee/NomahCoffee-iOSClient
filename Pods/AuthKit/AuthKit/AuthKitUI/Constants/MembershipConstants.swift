//
//  MembershipConstants.swift
//  AuthKit
//
//  Created by Caleb Rudnicki on 7/7/21.
//

import Foundation

struct MembershipConstants {
    
    struct Login {
        static let headerTitle: String = "Welcome Back!"
        static let headerSubtitle: String = "Please sign into your account"
        static let emailTextFieldPlaceholder: String = "Email address"
        static let passwordTextFieldPlaceholder: String = "Password"
        static let toggleText: String = "Don't have an account?"
        static let toggleButtonTitle: String = "Go to sign up"
        static let submitButtonTitle: String = "Log in"
    }
    
    struct Signup {
        static let headerTitle: String = "Create New Account"
        static let headerSubtitle: String = "Please fill in the form to continue"
        static let emailTextFieldPlaceholder: String = "Email address"
        static let usernameTextFieldPlaceholder: String = "Username"
        static let firstNameTextFieldPlaceholder: String = "First name"
        static let lastNameTextFieldPlaceholder: String = "Last name"
        static let passwordTextFieldPlaceholder: String = "Password"
        static let repasswordTextFieldPlaceholder: String = "Password (again)"
        static let toggleText: String = "Already have an account?"
        static let toggleButtonTitle: String = "Go to log in"
        static let submitButtonTitle: String = "Sign up"
    }
    
    static let headlineTopInset: CGFloat = 64
    static let headlineTextVerticalSpacing: CGFloat = 8
    static let textFieldStackSpacing: CGFloat = 16
    static let textFieldStackHorizontalInset: CGFloat = 16
    static let takeActionBottomInset: CGFloat = 32
    static let submitButtonHorizontalInset: CGFloat = 16
    static let submitButtonHeight: CGFloat = 64
    static let submitButtonCornerRadius: CGFloat = 16
    static let goToStackSpacing: CGFloat = 4
    
}
