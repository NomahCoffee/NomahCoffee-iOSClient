//
//  AuthKitUser.swift
//  AuthKit
//
//  Created by Caleb Rudnicki on 7/7/21.
//

import Foundation

struct AuthKitUserList: Codable {
    let results: [AuthKitUser]
}

/// The base type of user provided by `AuthKit`.
///
/// If you want to use a custom user class in your app, make sure that your user class is a
/// subclass this class. Here is an example of a custom user class called `ExampleUser`:
/// ```
/// import AuthKit
///
/// class ExampleUser: AuthKitUser {
///
///     var phoneNumber: String
///
///     public required init(from decoder: Decoder) throws {
///         let values = try decoder.container(keyedBy: CodingKeys.self)
///         stripeID = try values.decode(String.self, forKey: .stripeID)
///         try super.init(from: decoder)
///     }
///
///     override func encode(to encoder: Encoder) throws {
///         var container = encoder.container(keyedBy: CodingKeys.self)
///         try container.encode(stripeID, forKey: .stripeID)
///     }
///
/// }
/// ```
/// This custom subclass simply adds a phone number field on top of what is currently offered by
/// the base user class. `AuthKitUser` comes prebuilt with the following fields: `id`, `email`,
/// `username`, `firstName`, `lastName`, `isSuperuser`, `isStaff`. Any fields needed beyond that
/// will require a subclass.
///
/// Once you have successfully set up your custom user class, make sure to tell `AuthKit` about it like
/// ```
/// AuthKitManager.shared.userClass = ExampleUser.self
/// ```
open class AuthKitUser: Codable {
    
    /// A unique id of the user
    public var id: Int
    
    /// An email of the user
    public var email: String
    
    /// A username of the user
    public var username: String
    
    /// The first name of the user
    public var firstName: String
    
    /// The last name of the user
    public var lastName: String
    
    /// A `Bool` value indicating if the user is a superuser
    public var isSuperuser: Bool
    
    //// A `Bool` value indicating if the user is a staff user
    public var isStaff: Bool
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        email = try values.decode(String.self, forKey: .email)
        username = try values.decode(String.self, forKey: .username)
        firstName = try values.decode(String.self, forKey: .firstName)
        lastName = try values.decode(String.self, forKey: .lastName)
        isSuperuser = try values.decode(Bool.self, forKey: .isSuperuser)
        isStaff = try values.decode(Bool.self, forKey: .isStaff)
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(email, forKey: .email)
        try container.encode(username, forKey: .username)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(isSuperuser, forKey: .isSuperuser)
        try container.encode(isStaff, forKey: .isStaff)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case isSuperuser = "is_superuser"
        case isStaff = "is_staff"
    }
    
}
