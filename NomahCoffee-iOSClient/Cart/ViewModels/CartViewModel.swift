//
//  CartViewModel.swift
//  NomahCoffee-iOSClient
//
//  Created by Caleb Rudnicki on 7/11/21.
//

import Foundation

class CartViewModel {
    
    // MARK: Properties
    
    let cartItems: [CartItem]
    
    // MARK: Init
    
    init(cartItems: [CartItem]) {
        self.cartItems = cartItems
    }
    
}
