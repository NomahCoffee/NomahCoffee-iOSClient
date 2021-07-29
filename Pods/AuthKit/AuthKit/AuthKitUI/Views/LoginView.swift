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

class LoginView: UIView, TakeActionViewDelegate {
    
    // MARK: Properties
    
    var delegate: LoginViewDelegate?
    
    private let headlineView: HeadlineView = {
        let headlineView = HeadlineView()
        headlineView.viewModel = MembershipViewModel(type: .login)
        return headlineView
    }()
    
    private let emailTextField: NCEmailTextField = {
        let emailTextField = NCEmailTextField()
        emailTextField.textColor = .black
        emailTextField.font = Fonts.Oxygen.title6
        emailTextField.backgroundColor = Colors.sorrellBrown
        emailTextField.activeBorderColor = UIColor.white.cgColor
        emailTextField.placeholder = MembershipConstants.Login.emailTextFieldPlaceholder
        return emailTextField
    }()
    
    private let passwordTextField: NCPasswordTextField = {
        let passwordTextField = NCPasswordTextField()
        passwordTextField.textColor = .black
        passwordTextField.font = Fonts.Oxygen.title6
        passwordTextField.backgroundColor = Colors.sorrellBrown
        passwordTextField.activeBorderColor = UIColor.white.cgColor
        passwordTextField.placeholder = MembershipConstants.Login.passwordTextFieldPlaceholder
        return passwordTextField
    }()
    
    private let stackContainer = UIView()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = MembershipConstants.textFieldStackSpacing
        return stack
    }()
    
    private let takeActionView: TakeActionView = {
        let takeActionView = TakeActionView()
        takeActionView.viewModel = MembershipViewModel(type: .login)
        return takeActionView
    }()
    
    // MARK: Init
    
    init() {
        super.init(frame: .zero)
        
        takeActionView.delegate = self
        
        stack.addArrangedSubviews([emailTextField, passwordTextField])
        stackContainer.addSubview(stack)
        addSubviews([headlineView, stackContainer, takeActionView])
        
        headlineView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.topMargin).offset(MembershipConstants.headlineTopInset)
            make.leading.trailing.equalToSuperview()
        }
        
        stackContainer.snp.makeConstraints { make in
            make.top.equalTo(headlineView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(takeActionView.snp.top)
        }
        
        stack.snp.makeConstraints { make in
            make.centerY.greaterThanOrEqualToSuperview()
            make.leading.trailing.equalToSuperview().inset(MembershipConstants.textFieldStackHorizontalInset)
        }
        
        takeActionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottomMargin).inset(MembershipConstants.takeActionBottomInset)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: TakeActionViewDelegate
    
    func submit() {
        if emailTextField.isFulfilled,
           passwordTextField.isFulfilled,
           let email = emailTextField.text,
           let password = passwordTextField.text {
            delegate?.login(email: email, password: password)
        } else {
            delegate?.errorFound(.generic)
        }
    }
    
    func goTo(_ type: ViewType) {
        delegate?.toggleMembershipView(toShowLogin: false)
    }
    
}
