//
//  CartItem.swift
//  NomahCoffee-iOSClient
//
//  Created by Caleb Rudnicki on 7/10/21.
//

import Foundation

struct CartItem: Codable {
    
    var id: Int
    var quantity: Int
    var coffee: Coffee
    
}
