//
//  NetworkingError.swift
//  NomahCoffee-iOSClient
//
//  Created by Caleb Rudnicki on 7/14/21.
//

import Foundation

enum NetworkingError {
    
    case lostAuthToken
    case noCurrentUser
    case failedToDecodeCoffee
    case failedToRetrieveCoffee
    case failedToAddToCart
    case failedToEditCart
    case failedToDeleteCartItem
    case failedToClearCart
    case failedToSetupPayment
    case generic
    
    /// Title of the error to be shown in a modal
    var title: String {
        switch self {
        case .lostAuthToken:
            return "Unable to find your auth token"
        case .noCurrentUser:
            return "Unable to get current user data"
        case .failedToDecodeCoffee:
            return "Unable to parse the coffee info"
        case .failedToRetrieveCoffee:
            return "Unable to get all of the coffee"
        case .failedToAddToCart:
            return "Unable to add item to cart"
        case .failedToEditCart:
            return "Unable to edit this cart item"
        case .failedToDeleteCartItem:
            return "Unable to delete this cart item"
        case .failedToClearCart:
            return "Unable to clear this cart"
        case .failedToSetupPayment:
            return "Unable to set up payment drawer"
        case .generic:
            return "Something went wrong with the network request"
        }
    }
    
    /// Message of the error to be shown in a modal
    var message: String? {
        switch self {
        case .lostAuthToken, .failedToDecodeCoffee, .failedToRetrieveCoffee, .failedToAddToCart,
             .failedToEditCart, .failedToDeleteCartItem, .failedToClearCart, .generic:
            return nil
        case .noCurrentUser:
            return "Make sure you are properly logged in."
        case .failedToSetupPayment:
            return "Make sure all setting are properly set up with Stripe."
        }
    }
    
}
