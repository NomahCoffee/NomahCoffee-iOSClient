//
//  AuthKitManager.swift
//  AuthKit
//
//  Created by Caleb Rudnicki on 7/7/21.
//

import Foundation
import UIKit

public class AuthKitManager {
    
    // MARK: Static Properties
    
    /// Singleton instance
    public static let shared = AuthKitManager()
    
    // MARK: Public Properties
    
    /// A view controller passed by the client app that signifies the home screen of the client app.
    ///
    /// For example, if you were to have an app which the home screen lives within a `UIViewController` called
    /// `HomeScreenViewController`, then you will need to set this value to be equal to `HomeScreenViewController()`.
    /// This value is optional by default, but AuthKit cannot operate properly without a value, therefore, this
    /// is a value that you MUST set when setting up and using AuthKit. This value is the finish line for any work
    /// done within AuthKit.
    ///
    /// If your home screen lives within a `UINavigationController`, you may also set this value like so
    /// ```
    /// AuthKitManager.shared.homeViewController = UINavigationController(rootViewController: HomeScreenViewController())
    /// ```
    public var homeViewController: UIViewController?
    
    /// A configuration value to tell AuthKit what type of membership screen that the client app wants to be accessible.
    ///
    /// Set this value to customize the use of AuthKit. If you want to just have a sign up screen, then set this value to
    /// to `.signupOnly`. On the other hand, if you simply want a log in screen, then set the value to `.loginOnly`. By
    /// default, this value is set to `.loginAndSignup` which will allow a user of the client app to toggle between a log in
    /// and sign up view.
    public var membershipOption: AuthKitMembershipOption = .loginAndSignup {
        didSet {
            defaultViewController = MembershipViewController(showLogin: membershipOption == .signupOnly ? false : true)
        }
    }
    
    /// A configuration value as to whether AuthKit limits memberships to just superusers.
    ///
    /// If you want to allow login for superusers (i.e. if this were to be implemented in an admin app), then
    /// set this value to `true` by calling `AuthKitManager.shared.onlySuperuser = true`. If you want to allow
    /// all types of users, then you can leave this value alone. Default value is `false`.
    public var onlySuperuser: Bool = false
    
    /// A class type to allow client app to set the custom user class.
    ///
    /// AuthKit allows you to pass in your own custom user class. To follow the requirements and make things
    /// smoothly, your custom user class must be a subclass of `AuthKitUser` Here is an example:
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
    /// This custom subclass of `AuthKitUser` called `ExampleUser` adds a phone number field on top of the
    /// base user class provided by `AuthKit`.
    ///
    /// Once your custom user class is setup, you can tell `AuthKit` to use this custom class by the following:
    /// ```
    /// AuthKitManager.shared.userClass = ExampleUser.self
    /// ```
    /// Make sure that you set this value before doing any sort of action functions (i.e. `startSession`, etc)
    /// if you want `AuthKit` to use your custom user class.
    public var userClass: AnyClass?
    
    /// A reference to the current user.
    ///
    /// If you ever need any reference to the current user who is logged into your application, just call
    /// `AuthKitManager.shared.currentUser`. This value is optional so you must unwrap it as either a
    /// `AuthKitUser` or your custom user class (that you assigned to the `AuthKitManager.shared.userClass`.
    /// This value is optional so if there is no value for current user, then something has gone wrong.
    ///
    /// For example, if you have a custom user class named `ExampleUser`.
    /// Your code should look like the following:
    /// ```
    /// AuthKitManager.shared.userClass = ExampleUser.self
    ///
    /// // Grab current user
    /// if let currentUser = AuthKitManager.shared.currentUser as? ExampleUser {
    ///     // Now you can use currentUser as you wish
    ///     print(currentUser.firstName)
    /// }
    /// ```
    public var currentUser: AuthKitUser?
    
    // MARK: Private Properties
    
    /// A view controller for the preset screen to be shown.
    ///
    /// This value is tightly coupled with `membershipOption`. In the case that `membershipOption = .signupOnly`, the sign up
    /// view will be the default screen show. On the other hand, if the default value of `membershipOption` is either
    /// `.loginOnly` or `.loginAndSignup`, the log in view will be the default screen show to the client app.
    ///
    /// A client app can not set this value. To change the default view controller, the `membershipOption` value needs to be
    /// edited.
    private var defaultViewController = MembershipViewController(showLogin: true)
    
    // This function should be called everytime a user opens an app. This function should then decide what state the user/app is currently in
    // 1. There is no auth token -> Present the login view
    // 2. There is an auth token -> Push thru and allow app to continue thru this checkpoint
    // Bool is used to say if the client app needs to call to present LoginViewController or not
    // we needed to do this thru a completion and with the cient app, because the scenedelegate is
    // the window is set and made visible
    
    // MARK: Public Functions
    
    /// Starts a session for a client app and determines whether or not a membership screen should be shown.
    /// - Parameters:
    ///   - window: a `UIWindow` corresponding the backdrop for all of the UI work done in the client app
    ///   - completion: a completion of type `Bool` that dictates whether or not to show any membership screen.
    ///   Becauase this work needs to called from the client app, AuthKit sends back `true` in the case that a
    ///   membership screen needs to be shown and `false` in the case that a client app an move to the app's home
    ///   screen.
    ///
    /// Here is an example of how to call and use this function properly:
    /// ```
    /// AuthKitManager.shared.startSession(from: window, completion: { showMembershipScreen in
    ///     window.makeKeyAndVisible()
    ///     self.window = window
    ///
    ///     if let rootViewController = window.rootViewController, showMembershipScreen {
    ///         AuthKitManager.shared.presentDefaultViewController(from: rootViewController, animated: false)
    ///     }
    /// })
    /// ```
    /// First, the client app must start a session by calling the function. Passing in the `window` and will allow
    /// AuthKit to assign the `homeViewController` (which is a requirement of this function) to be assigned as the
    /// `rootViewController`.
    ///
    /// Once AuthKit assigns the root view, it will decide and return a value to tell the client app if a membership
    /// view needs to be shown. By catching the `Bool` value in the completion, a client app can then simply check
    /// to make sure the `window.rootViewController` is not nil, and if `showMembershipScreen = true`, can call another
    /// AuthKitManager function called `presentDefaultViewController()` to complete the app setup.
    ///
    /// NOTE: the `homeViewController` MUST be set before calling this value. You will hit a failure case without it.
    /// You can set the value as follows:
    /// ```
    /// AuthKitManager.shared.homeViewController = HomeScreenViewController()
    /// ```
    public func startSession(from window: UIWindow, completion: @escaping (Bool) -> Void) {
        guard let homeViewController = homeViewController else {
            preconditionFailure(
                """
                🚫 Client app did not set a UIViewController for homeViewController. To properly start a session, make sure to set the homeViewController like AuthKitManager.shared.homeViewController = MyHomeScreenViewController() for example. 🚫
                """
            )
        }
        
        window.rootViewController = homeViewController
        if let authToken = UserDefaults().string(forKey: "authToken"), !authToken.isEmpty {
            // There exists an auth token that is not empty, so keep it as is and complete this function
            // once you set the current user
            AuthKitService.setCurrentUser(completion: { error in
                if error == nil {
                    completion(false)
                }
            })
        } else {
            completion(true)
        }
    }
    
    /// Presents the default view controller onto the stack.
    /// - Parameters:
    ///   - viewController: a `UIViewController` reference to the existing view in which the default view controller
    ///   will be presented over
    ///   - animated: a `Bool` value determining if the presentation of the view controller is animated or not. Default
    ///   value is `true`.
    public func presentDefaultViewController(from viewController: UIViewController, animated: Bool = true) {
        defaultViewController.modalPresentationStyle = .fullScreen
        viewController.present(defaultViewController, animated: animated, completion: nil)
    }
    
    /// Presents the log in view onto the stack.
    /// - Parameters:
    ///   - viewController: a `UIViewController` reference to the existing view in which the log in view will be
    ///   presented over
    ///   - animated: a `Bool` value determining if the presentation of the view controller is animated or not. Default
    ///   value is `true`.
    public func presentLoginViewController(from viewController: UIViewController, animated: Bool = true) {
        if membershipOption == .signupOnly {
            preconditionFailure(
                """
                🚫 Client app is attempting to present the login screen with the AuthKitManager variety of .signupOnly. To show the login screen, you must set AuthKitManager.shared.membershipOption to .loginOnly or .loginAndSignup. 🚫
                """
            )
        }
        
        let loginViewController = MembershipViewController(showLogin: true)
        loginViewController.modalPresentationStyle = .fullScreen
        viewController.present(loginViewController, animated: animated, completion: nil)
    }
    
    /// Presents the sign up view onto the stack.
    /// - Parameters:
    ///   - viewController: a `UIViewController` reference to the existing view in which the sign up view will be
    ///   presented over
    ///   - animated: a `Bool` value determining if the presentation of the view controller is animated or not. Default
    ///   value is `true`.
    public func presentSignupViewController(from viewController: UIViewController, animated: Bool = true) {
        if membershipOption == .loginOnly {
            preconditionFailure(
                """
                🚫 Client app is attempting to present the signup screen with the AuthKitManager variety of .loginOnly. To show the signup screen, you must set AuthKitManager.shared.membershipOption to .signupOnly or .loginAndSignup. 🚫
                """
            )
        }
        
        let signupViewController = MembershipViewController(showLogin: false)
        signupViewController.modalPresentationStyle = .fullScreen
        viewController.present(signupViewController, animated: animated, completion: nil)
    }
    
    /// Logs out the current user and presents the default view controller within AuthKit.
    /// - Parameter viewController: a `UIViewController` reference to the existing view in which the logging out is
    /// occuring from
    public func logout(from viewController: UIViewController) {
        AuthKitService.logout(completion: { error in
            if error == nil {
                UserDefaults().removeObject(forKey: "authToken")
            }
            
            self.presentDefaultViewController(from: viewController)
        })
    }
    
    /// Manually updates the current user value.
    ///
    /// This is used best whenever a anything within the user object changes. For instance, call this function
    /// if a user changes their name, email, update their shopping cart, etc.
    public func updateCurrentUser() {
        AuthKitService.setCurrentUser(completion: nil)
    }
    
}
