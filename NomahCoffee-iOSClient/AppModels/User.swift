//
//  User.swift
//  NomahCoffee-iOSClient
//
//  Created by Caleb Rudnicki on 7/10/21.
//

import Foundation
import AuthKit

class User: AuthKitUser {
    
    var stripeID: String
    var cart: [CartItem]
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        stripeID = try values.decode(String.self, forKey: .stripeID)
        cart = try values.decode([CartItem].self, forKey: .cart)
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(stripeID, forKey: .stripeID)
        try container.encode(cart, forKey: .cart)
    }
    
    enum CodingKeys: String, CodingKey {
        case stripeID = "stripe_id"
        case cart
    }
    
}
