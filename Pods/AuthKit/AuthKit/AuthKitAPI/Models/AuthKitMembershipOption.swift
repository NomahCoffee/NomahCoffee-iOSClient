//
//  AuthKitMembershipOption.swift
//  AuthKit
//
//  Created by Caleb Rudnicki on 7/7/21.
//

import Foundation

/// A configuration value of membership views allowed by AuthKit.
public enum AuthKitMembershipOption {
    case loginOnly
    case signupOnly
    case loginAndSignup
}
