//
//  NetworkingManager.swift
//  NomahCoffee-iOSClient
//
//  Created by Caleb Rudnicki on 7/10/21.
//

import Foundation
import Alamofire
import AuthKit

public class NetworkingManager {
    
    // MARK: Private Properties
    
    private static var domain: String {
        #if DEBUG
            return "http://127.0.0.1:8000"
        #endif
    }
    
    // MARK: Private Functions
    
    private static func getHeaders(with authToken: String) -> HTTPHeaders {
        let headers = HTTPHeaders([
            HTTPHeader(name: "Authorization", value: "Token \(authToken)"),
            HTTPHeader(name: "Content-Type", value: "application/x-www-form-urlencoded")
        ])
        return headers
    }
    
    // MARK: Static Functions
    
    /// Gets all of the coffee objects
    /// - Parameter completion: a completion of type `[Coffee]?, NetworkingError?` which will return the array
    /// of coffee objects and nil in the success case or nil and a error in the case of a failure
    static func getCoffee(completion: @escaping ([Coffee]?, NetworkingError?) -> Void) {
        AF.request(
            "\(domain)/api/coffee/",
            method: .get
        ).responseJSON { response in
            switch response.result {
            case .success(_):
                guard let data = response.data else { return }
                
                do {
                    let allCoffee = try JSONDecoder().decode(CoffeeList.self, from: data)
                    completion(allCoffee.results, nil)
                } catch _ {
                    completion(nil, .failedToDecodeCoffee)
                }
            case .failure(_):
                completion(nil, .failedToRetrieveCoffee)
            }
        }
    }
    
    /// Adds a coffee to the current user's cart
    /// - Parameters:
    ///   - coffee: a `Coffee` object of the type of item that is to be added to cart
    ///   - quantity: an `Int` for the number of coffee items to be added to cart
    ///   - completion: a callback of type `User?, NetworkingError?` that will return the updated user and nil in
    ///   the case of a success or nil and an error in the case of a fail
    static func addToCart(coffee: Coffee, with quantity: Int, completion: @escaping (User?, NetworkingError?) -> Void) {
        guard let authToken = UserDefaults().string(forKey: "authToken") else {
            completion(nil, .lostAuthToken)
            return
        }
        
        guard let user = AuthKitManager.shared.currentUser as? User else {
            completion(nil, .noCurrentUser)
            return
        }
        
        AF.request(
            "\(domain)/auth/update_cart/",
            method: .post,
            parameters: ["coffeeId": coffee.id,
                         "userId": user.id,
                         "quantity": quantity],
            headers: getHeaders(with: authToken)
        ).responseJSON { response in
            switch response.result {
            case .success(_):
                guard let data = response.data else { return }
                
                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    completion(user, nil)
                    AuthKitManager.shared.updateCurrentUser()
                } catch _ {
                    completion(nil, .failedToAddToCart)
                }
            case .failure(_):
                completion(nil, .failedToAddToCart)
            }
        }
    }
    
    /// Edits a single cart item
    /// - Parameters:
    ///   - cartItem: the `CartItem` that is to be edited
    ///   - quantity: an `Int` value for the new quantity of the cart item
    ///   - completion: a callback of type `User?, NetworkingError?` that will return the updated user and nil in
    ///   the case of a success or nil and an error in the case of a fail
    static func editCart(cartItem: CartItem, quantity: Int, completion: @escaping (User?, NetworkingError?) -> Void) {
        guard let authToken = UserDefaults().string(forKey: "authToken") else {
            completion(nil, .lostAuthToken)
            return
        }
        
        AF.request(
            "\(domain)/auth/update_cart/",
            method: .put,
            parameters: ["cartId": cartItem.id,
                         "quantity": quantity],
            headers: getHeaders(with: authToken)
        ).responseJSON { response in
            
            switch response.result {
            case .success(_):
                guard let data = response.data else { return }
                
                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    completion(user, nil)
                    AuthKitManager.shared.updateCurrentUser()
                } catch _ {
                    completion(nil, .failedToEditCart)
                }
            case .failure(_):
                completion(nil, .failedToEditCart)
            }
        }
    }
    
    /// Deletes a cart item from the current user's cart
    /// - Parameters:
    ///   - cartItem: the `CartItem` that is to be removed from the current user's cart
    ///   - completion: a callback of type `User?, NetworkingError?` that will return the updated user and nil in
    ///   the case of a success or nil and an error in the case of a fail
    static func deleteFromCart(cartItem: CartItem, completion: @escaping (User?, NetworkingError?) -> Void) {
        guard let authToken = UserDefaults().string(forKey: "authToken") else {
            completion(nil, .lostAuthToken)
            return
        }
        
        AF.request(
            "\(domain)/auth/update_cart/",
            method: .delete,
            parameters: ["cartId": cartItem.id],
            encoding: URLEncoding(destination: .httpBody),
            headers: getHeaders(with: authToken)
        ).responseJSON { response in

            switch response.result {
            case .success(_):
                guard let data = response.data else { return }

                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    completion(user, nil)
                    AuthKitManager.shared.updateCurrentUser()
                } catch _ {
                    completion(nil, .failedToDeleteCartItem)
                }
            case .failure(_):
                completion(nil, .failedToDeleteCartItem)
            }
        }
    }
    
    /// Delete the current user's entire cart
    /// - Parameter completion: a callback of type `User?, NetworkingError?` that will return the updated user and nil in
    ///   the case of a success or nil and an error in the case of a fail
    static func clearCart(completion: @escaping (User?, NetworkingError?) -> Void) {
        guard let authToken = UserDefaults().string(forKey: "authToken") else {
            completion(nil, .lostAuthToken)
            return
        }
        
        guard let user = AuthKitManager.shared.currentUser as? User else {
            completion(nil, .noCurrentUser)
            return
        }
        
        AF.request(
            "\(domain)/auth/clear_cart/",
            method: .delete,
            parameters: ["userId": user.id],
            encoding: URLEncoding(destination: .httpBody),
            headers: getHeaders(with: authToken)
        ).responseJSON { response in
            
            switch response.result {
            case .success(_):
                guard let data = response.data else { return }
                
                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    completion(user, nil)
                    AuthKitManager.shared.updateCurrentUser()
                } catch _ {
                    completion(nil, .failedToClearCart)
                }
            case .failure(_):
                completion(nil, .failedToClearCart)
            }
        }
    }
    
    /// Sets up the payment drawer for checkout
    /// - Parameter completion: a callback of type `String?, String?, String?, NetworkingError?` that will
    /// return the Stripe customer ID, ephermeral key, payment intent, and nil in the case of a success or
    /// nil, nil, nil and an error in the case of a failure
    static func setupPayment(completion: @escaping (String?, String?, String?, NetworkingError?) -> Void) {
        guard let authToken = UserDefaults().string(forKey: "authToken") else {
            completion(nil, nil, nil, .lostAuthToken)
            return
        }
        
        guard let user = AuthKitManager.shared.currentUser as? User else {
            completion(nil, nil, nil, .noCurrentUser)
            return
        }
        
        AF.request(
            "\(domain)/auth/payment_sheet/",
            method: .post,
            parameters: ["userId": user.id],
            headers: getHeaders(with: authToken)
        ).responseJSON { response in
            switch response.result {
            case .success(_):
                guard
                    let data = response.data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                    let customerId = json["customer"] as? String,
                    let customerEphemeralKeySecret = json["ephemeralKey"] as? String,
                    let paymentIntentClientSecret = json["paymentIntent"] as? String
                else {
                    completion(nil, nil, nil, .failedToSetupPayment)
                    return
                }
                
                completion(customerId, customerEphemeralKeySecret, paymentIntentClientSecret, nil)
            case .failure(_):
                completion(nil, nil, nil, .failedToSetupPayment)
            }
        }
    }
    
}
