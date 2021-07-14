//
//  LoginView.swift
//  AuthKit
//
//  Created by Caleb Rudnicki on 7/7/21.
//

import UIKit
import SnapKit
import NCUtils

protocol LoginViewDelegate: MembershipViewDelegate {
    /// Trigger a login action
    /// - Parameters:
    ///   - email: a `String` for the user's email
    ///   - password: a `String` for the user's password
    func login(email: String, password: String)
}

class LoginView: UIView {
    
    // MARK: Properties
    
    var delegate: LoginViewDelegate?
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = MembershipConstants.Login.headerTitle
        return titleLabel
    }()
    
    private let emailTextField: NCEmailTextField = {
        let emailTextField = NCEmailTextField()
        emailTextField.placeholder = MembershipConstants.Login.emailTextFieldPlaceholder
        return emailTextField
    }()
    
    private let passwordTextField: NCPasswordTextField = {
        let passwordTextField = NCPasswordTextField()
        passwordTextField.placeholder = MembershipConstants.Login.passwordTextFieldPlaceholder
        return passwordTextField
    }()
    
    private let goToSignupButton: UIButton = {
        let goToSignupButton = UIButton()
        goToSignupButton.setTitle(MembershipConstants.Login.toggleButtonTitle, for: .normal)
        goToSignupButton.setTitleColor(.label, for: .normal)
        goToSignupButton.addTarget(self, action: #selector(goToSignupButtonTapped), for: .touchUpInside)
        return goToSignupButton
    }()
    
    private let loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.setTitle(MembershipConstants.Login.submitButtonTitle, for: .normal)
        loginButton.setTitleColor(.label, for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginButton.backgroundColor = .systemGreen
        return loginButton
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
        stack.addArrangedSubview(passwordTextField)
        stack.addArrangedSubview(goToSignupButton)

        addSubview(stack)
        addSubview(loginButton)
        
        stack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(MembershipConstants.stackHorizontalInset)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(stack.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(MembershipConstants.submitButtonHeight)
        }
        
        goToSignupButton.isHidden = AuthKitManager.shared.membershipOption == .loginOnly ? true : false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    
    @objc private func loginButtonTapped() {
        if emailTextField.isFulfilled,
           passwordTextField.isFulfilled,
           let email = emailTextField.text,
           let password = passwordTextField.text {
            delegate?.login(email: email, password: password)
        } else {
            delegate?.errorFound(.generic)
        }
    }
    
    @objc private func goToSignupButtonTapped() {
        delegate?.toggleMembershipView(toShowLogin: false)
    }
    
}

