//
//  SignupView.swift
//  AuthKit
//
//  Created by Caleb Rudnicki on 7/7/21.
//

import UIKit
import SnapKit
import NCUtils

protocol SignupViewDelegate: MembershipViewDelegate {
    /// Tigger a signup action
    /// - Parameters:
    ///   - email: a `String` for the user's email
    ///   - username: a `String` for the user's username
    ///   - firstName: a `String` for the user's first name
    ///   - lastName: a `String` for the user's last name
    ///   - password: a `String` for the user's password
    ///   - repassword: a `String` for the user's re-entered password
    func signup(email: String, username: String, firstName: String,
                lastName: String, password: String, repassword: String)
}

class SignupView: UIView {
    
    var delegate: SignupViewDelegate?

    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = MembershipConstants.Signup.headerTitle
        return titleLabel
    }()
    
    private let emailTextField: NCEmailTextField = {
        let emailTextField = NCEmailTextField()
        emailTextField.placeholder = MembershipConstants.Signup.emailTextFieldPlaceholder
        return emailTextField
    }()
    
    private let usernameTextField: NCTextField = {
        let usernameTextField = NCTextField()
        usernameTextField.autocapitalizationType = .none
        usernameTextField.placeholder = MembershipConstants.Signup.usernameTextFieldPlaceholder
        return usernameTextField
    }()
    
    private let firstNameTextField: NCTextField = {
        let firstNameTextField = NCTextField()
        firstNameTextField.placeholder = MembershipConstants.Signup.firstNameTextFieldPlaceholder
        return firstNameTextField
    }()
    
    private let lastNameTextField: NCTextField = {
        let lastNameTextField = NCTextField()
        lastNameTextField.placeholder = MembershipConstants.Signup.lastNameTextFieldPlaceholder
        return lastNameTextField
    }()
    
    private let passwordTextField: NCPasswordTextField = {
        let passwordTextField = NCPasswordTextField()
        passwordTextField.placeholder = MembershipConstants.Signup.passwordTextFieldPlaceholder
        return passwordTextField
    }()
    
    private let repasswordTextField: NCPasswordTextField = {
        let repasswordTextField = NCPasswordTextField()
        repasswordTextField.placeholder = MembershipConstants.Signup.repasswordTextFieldPlaceholder
        return repasswordTextField
    }()
    
    private let goToLoginButton: UIButton = {
        let goToLoginButton = UIButton()
        goToLoginButton.setTitle(MembershipConstants.Signup.toggleButtonTitle, for: .normal)
        goToLoginButton.setTitleColor(.label, for: .normal)
        goToLoginButton.addTarget(self, action: #selector(goToLoginButtonTapped), for: .touchUpInside)
        return goToLoginButton
    }()
    
    private let signupButton: UIButton = {
        let signupButton = UIButton()
        signupButton.setTitle(MembershipConstants.Signup.submitButtonTitle, for: .normal)
        signupButton.setTitleColor(.label, for: .normal)
        signupButton.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        signupButton.backgroundColor = .systemGreen
        return signupButton
    }()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = MembershipConstants.stackSpacing
        return stack
    }()
    
    // MARK: Init
    
    init() {
        super.init(frame: .zero)
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(emailTextField)
        stack.addArrangedSubview(usernameTextField)
        stack.addArrangedSubview(firstNameTextField)
        stack.addArrangedSubview(lastNameTextField)
        stack.addArrangedSubview(passwordTextField)
        stack.addArrangedSubview(repasswordTextField)
        stack.addArrangedSubview(goToLoginButton)
        
        addSubview(stack)
        addSubview(signupButton)
        
        stack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(MembershipConstants.stackHorizontalInset)
        }
        
        signupButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(stack.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(MembershipConstants.submitButtonHeight)
        }
        
        goToLoginButton.isHidden = AuthKitManager.shared.membershipOption == .signupOnly ? true : false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    
    @objc private func signupButtonTapped() {
        if emailTextField.isFulfilled,
           usernameTextField.isFulfilled,
           firstNameTextField.isFulfilled,
           lastNameTextField.isFulfilled,
           passwordTextField.isFulfilled,
           repasswordTextField.isFulfilled,
           let email = emailTextField.text,
           let username = usernameTextField.text,
           let firstName = firstNameTextField.text,
           let lastName = lastNameTextField.text,
           let password = passwordTextField.text,
           let repassword = repasswordTextField.text {
            delegate?.signup(email: email,
                             username: username,
                             firstName: firstName,
                             lastName: lastName,
                             password: password,
                             repassword: repassword)
           }
    }
    
    @objc private func goToLoginButtonTapped() {
        delegate?.toggleMembershipView(toShowLogin: true)
    }

}
