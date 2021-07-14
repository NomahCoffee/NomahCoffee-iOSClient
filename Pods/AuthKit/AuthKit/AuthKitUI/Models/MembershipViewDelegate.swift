//
//  MembershipViewDelegate.swift
//  AuthKit
//
//  Created by Caleb Rudnicki on 7/7/21.
//

import Foundation

protocol MembershipViewDelegate {
    /// Trigger the view to toggle between login and signup views
    /// - Parameter toShowLogin: a `Bool` indicating whether the login view is shown or not
    func toggleMembershipView(toShowLogin: Bool)
    
    /// Trigger an error message
    /// - Parameter error: a `LoginError` object representing the specific error to trigger
    func errorFound(_ error: MembershipError)
}
