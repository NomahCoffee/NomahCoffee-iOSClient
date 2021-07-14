//
//  AuthKitError.swift
//  AuthKit
//
//  Created by Caleb Rudnicki on 7/7/21.
//

import Foundation

enum AuthKitError {
    
    case lostAuthToken
    case failedLogin
    case failedSignup
    case failedLogout
    case nonSuperuserRestricted
    case failedToSetCurrentUser
    case generic
    
    /// Title of the error to be shown in a modal
    var title: String {
        switch self {
        case .lostAuthToken:
            return "Unable to find your auth token"
        case .failedLogin:
            return "Unable to log in with the provided creditials"
        case .failedSignup:
            return "Unable to sign up with the provided credentials"
        case .failedLogout:
            return "Unable to logout for the current user"
        case .nonSuperuserRestricted:
            return "This user is not a superuser"
        case .failedToSetCurrentUser:
            return "Could not set the current user"
        case .generic:
            return "Something went wrong with the network request"
        }
    }
    
    /// Message of the error to be shown in a modal
    var message: String? {
        switch self {
        case .lostAuthToken, .failedLogout, .failedToSetCurrentUser, .generic:
            return nil
        case .failedLogin, .failedSignup:
            return "Make sure to enter all of your credentials properly and that spelling is correct."
        case .nonSuperuserRestricted:
            return "This membership screen only allows superusers. Make sure that your credentials correspond to a superuser."
        }
    }
    
}
