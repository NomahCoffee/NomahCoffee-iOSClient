//
//  MembershipViewController.swift
//  AuthKit
//
//  Created by Caleb Rudnicki on 7/7/21.
//

import UIKit
import SnapKit
import NCUtils

class MembershipViewController: UIViewController, LoginViewDelegate, SignupViewDelegate {
    
    // MARK: Properties
    
    private var showLogin: Bool
    
    lazy private var loginView: LoginView = {
        let loginView = LoginView()
        loginView.delegate = self
        return loginView
    }()
    
    lazy private var signupView: SignupView = {
        let signupView = SignupView()
        signupView.delegate = self
        return signupView
    }()
    
    // MARK: Init

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.shadow
        view.addSubviews([loginView, signupView])
        
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        signupView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        updateHiddenViews()
    }
    
    init(showLogin: Bool) {
        self.showLogin = showLogin
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private Functions
    
    /// Updates the `isHidden` value of both the login and signup views based on the value of `showLogin`
    private func updateHiddenViews() {
        loginView.isHidden = !showLogin
        signupView.isHidden = showLogin
    }
    
    // MARK: LoginViewDelegate
    
    func login(email: String, password: String) {
        AuthKitService.login(with: email, password: password, completion: { authToken, error in
            if error != nil {
                let alert = UIAlertController(title: error?.title, message: error?.message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            // Dismiss the viewController to unveil the viewController underneath, typically the
            // viewController assigned to homeViewController of AuthKitManager
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    // MARK: SignupViewDelegate
    
    func signup(email: String, username: String, firstName: String, lastName: String, password: String, repassword: String) {
        AuthKitService.signup(with: email, username: username, firstName: firstName, lastName: lastName,
                              password: password, repassword: repassword, completion: { authToken, error in
            if error != nil {
                let alert = UIAlertController(title: error?.title, message: error?.message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            UserDefaults().set(authToken, forKey: "authToken")
            // Dismiss the viewController to unveil the viewController underneath, typically the
            // viewController assigned to homeViewController of AuthKitManager
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    // MARK: MembershipViewDelegate
    
    func toggleMembershipView(toShowLogin: Bool) {
        showLogin = toShowLogin
        updateHiddenViews()
    }
    
    func errorFound(_ error: MembershipError) {
        let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
