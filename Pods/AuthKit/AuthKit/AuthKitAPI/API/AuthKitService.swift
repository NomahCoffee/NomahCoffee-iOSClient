//
//  AuthKitService.swift
//  AuthKit
//
//  Created by Caleb Rudnicki on 7/7/21.
//

import Foundation
import Alamofire

struct AuthKitService {
    
    /// Attempts a log in and send back an authentication token in the case of a success.
    /// - Parameters:
    ///   - email: a `String` representing the email
    ///   - password: a `String` representing the password
    ///   - completion: a completion block of type `(String?, AuthKitError?)` that send back an auth token and nil in
    ///   the success case or a nil and an error in the case of a failed log in
    static func login(with email: String, password: String, completion: @escaping (String?, AuthKitError?) -> Void) {
        let loginBlock: () -> Void = {
            AF.request(
                "http://127.0.0.1:8000/auth/token/login/",
                method: .post,
                parameters: ["email": email,
                             "password": password]
            ).responseJSON { response in
                switch response.result {
                case .success(_):
                    guard
                        let data = response.data,
                        let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                        let authToken = json["auth_token"] as? String
                    else {
                        completion(nil, .lostAuthToken)
                        return
                    }
                    
                    UserDefaults().set(authToken, forKey: "authToken")
                    
                    // Set current user
                    if let userClass = AuthKitManager.shared.userClass,
                       userClass.self.isSubclass(of: AuthKitUser.self) {
                        setCurrentUser(completion: { error in
                            // Successfully got auth token and set user
                            completion(authToken, error)
                        })
                    }
                case .failure(_):
                    completion(nil, .failedLogin)
                }
            }
        }
        
        if AuthKitManager.shared.onlySuperuser {
            AuthKitService().isSuperuser(from: email, completion: { isSuperuser in
                if isSuperuser {
                    loginBlock()
                } else {
                    completion(nil, .nonSuperuserRestricted)
                }
            })
        } else {
            loginBlock()
        }
    }
    
    /// Attempts a signup (and then a log in) and will send back an authentication token in the case of a success.
    /// - Parameters:
    ///   - email: a `String` representing the email
    ///   - username: a `String` representing the username
    ///   - firstName: a `String` representing the first name
    ///   - lastName: a `String` representing the last name
    ///   - password: a `String` representing the password
    ///   - repassword: a `String` representing the re-entered password
    ///   - completion: a completion block of type `(String?, AuthKitError?)` that send back an auth token and nil in
    ///   the success case or a nil and an error in the case of a failed log in
    static func signup(with email: String, username: String, firstName: String, lastName: String, password: String,
                       repassword: String, completion: @escaping (String?, AuthKitError?) -> Void) {
        
        AF.request(
            "http://127.0.0.1:8000/auth/users/",
            method: .post,
            parameters: ["email": email,
                         "username": username,
                         "first_name": firstName,
                         "last_name": lastName,
                         "password": password,
                         "re_password": repassword,
                         "is_superuser": false,
                         "is_staff": false]
        ).responseJSON { response in
            switch response.result {
            case .success(_):
                login(with: email, password: password, completion: { authToken, error in
                    completion(authToken, error)
                })
            case .failure(_):
                completion(nil, .failedSignup)
            }
        }
    }
    
    /// Attempts a logout of the current user.
    /// - Parameter completion: a completion block of type `AuthKitError?` that will send nil in the case of a success
    /// or an error in the case of a failed log out attempt
    static func logout(completion: @escaping (AuthKitError?) -> Void) {
        guard let authToken = UserDefaults().string(forKey: "authToken") else {
            completion(.lostAuthToken)
            return
        }
        
        AF.request(
            "http://127.0.0.1:8000/auth/token/logout/",
            method: .post,
            headers: getHeaders(with: authToken)
        ).responseJSON { response in
            switch response.result {
            case .success(_):
                completion(nil)
            case .failure(_):
                completion(.failedLogout)
            }
        }
    }
        
    /// Grabs and sets the current user.
    /// - Parameter completion: a completion block of type `AuthKitUser?` that will send the user
    /// in the success case and nil in the case of a failure
    static func setCurrentUser(completion: ((AuthKitError?) -> Void)? = nil) {
        guard let authToken = UserDefaults().string(forKey: "authToken") else {
            completion?(.lostAuthToken)
            return
        }
        
        AF.request(
            "http://127.0.0.1:8000/auth/users/me/",
            method: .get,
            headers: getHeaders(with: authToken)
        ).responseJSON { response in
            switch response.result {
            case .success(_):
                guard let data = response.data else { return }
                do {
                    let user = try JSONDecoder().decode(
                        AuthKitManager.shared.userClass.self as! AuthKitUser.Type,
                        from: data
                    )
                    AuthKitManager.shared.currentUser = user
                    completion?(nil)
                } catch _ {
                    completion?(.failedToSetCurrentUser)
                }
            case .failure(_):
                completion?(.failedToSetCurrentUser)
            }
        }
    }
        
    // MARK: Private Functions
    
    /// Arranges the headers to be used for networking.
    /// - Parameter authToken: a `String` of the authentication token of the current user
    /// - Returns: a `HTTPHeader` to be used in some networking requests
    private static func getHeaders(with authToken: String) -> HTTPHeaders {
        let headers = HTTPHeaders([
            HTTPHeader(name: "Authorization", value: "Token \(authToken)"),
            HTTPHeader(name: "Content-Type", value: "application/x-www-form-urlencoded")
        ])
        return headers
    }
    
    /// Determines whether or not a user is a superuser by their email.
    /// - Parameters:
    ///   - email: a `String` of the email in question
    ///   - completion: a completion block of type `Bool` that will be `true` if the user is a superuser and
    ///    `false` otherwise
    private func isSuperuser(from email: String, completion: @escaping (Bool) -> Void) {
        AF.request(
            "http://127.0.0.1:8000/auth/superusers/",
            method: .get
        ).responseJSON { response in
            guard let data = response.data else { return }
            
            do {
                let users = try JSONDecoder().decode(AuthKitUserList.self, from: data)
                for user in users.results {
                    if user.email == email {
                        // Found a match between a superuser email and the passed in email
                        // Send true through the completion block and leave the function
                        completion(true)
                        return
                    }
                }
                completion(false)
            } catch {
                completion(false)
            }
        }
    }
    
}
