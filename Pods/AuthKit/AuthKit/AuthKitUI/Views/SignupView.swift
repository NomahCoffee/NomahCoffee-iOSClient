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

class SignupView: UIView, TakeActionViewDelegate {
    
    var delegate: SignupViewDelegate?
    
    private let headlineView: HeadlineView = {
        let headlineView = HeadlineView()
        headlineView.viewModel = MembershipViewModel(type: .signup)
        return headlineView
    }()
    
    private let emailTextField: NCEmailTextField = {
        let emailTextField = NCEmailTextField()
        emailTextField.textColor = .black
        emailTextField.font = Fonts.Oxygen.title6
        emailTextField.backgroundColor = Colors.sorrellBrown
        emailTextField.activeBorderColor = UIColor.white.cgColor
        emailTextField.placeholder = MembershipConstants.Signup.emailTextFieldPlaceholder
        return emailTextField
    }()
    
    private let usernameTextField: NCTextField = {
        let usernameTextField = NCTextField()
        usernameTextField.textColor = .black
        usernameTextField.font = Fonts.Oxygen.title6
        usernameTextField.autocapitalizationType = .none
        usernameTextField.backgroundColor = Colors.sorrellBrown
        usernameTextField.activeBorderColor = UIColor.white.cgColor
        usernameTextField.placeholder = MembershipConstants.Signup.usernameTextFieldPlaceholder
        return usernameTextField
    }()
    
    private let firstNameTextField: NCTextField = {
        let firstNameTextField = NCTextField()
        firstNameTextField.textColor = .black
        firstNameTextField.font = Fonts.Oxygen.title6
        firstNameTextField.backgroundColor = Colors.sorrellBrown
        firstNameTextField.activeBorderColor = UIColor.white.cgColor
        firstNameTextField.placeholder = MembershipConstants.Signup.firstNameTextFieldPlaceholder
        return firstNameTextField
    }()
    
    private let lastNameTextField: NCTextField = {
        let lastNameTextField = NCTextField()
        lastNameTextField.textColor = .black
        lastNameTextField.font = Fonts.Oxygen.title6
        lastNameTextField.backgroundColor = Colors.sorrellBrown
        lastNameTextField.activeBorderColor = UIColor.white.cgColor
        lastNameTextField.placeholder = MembershipConstants.Signup.lastNameTextFieldPlaceholder
        return lastNameTextField
    }()
    
    private let passwordTextField: NCPasswordTextField = {
        let passwordTextField = NCPasswordTextField()
        passwordTextField.textColor = .black
        passwordTextField.font = Fonts.Oxygen.title6
        passwordTextField.backgroundColor = Colors.sorrellBrown
        passwordTextField.activeBorderColor = UIColor.white.cgColor
        passwordTextField.placeholder = MembershipConstants.Signup.passwordTextFieldPlaceholder
        return passwordTextField
    }()
    
    private let repasswordTextField: NCPasswordTextField = {
        let repasswordTextField = NCPasswordTextField()
        repasswordTextField.textColor = .black
        repasswordTextField.font = Fonts.Oxygen.title6
        repasswordTextField.backgroundColor = Colors.sorrellBrown
        repasswordTextField.activeBorderColor = UIColor.white.cgColor
        repasswordTextField.placeholder = MembershipConstants.Signup.repasswordTextFieldPlaceholder
        return repasswordTextField
    }()
    
    private let stackContainer = UIView()
    
    private let nameStack: UIStackView = {
        let nameStack = UIStackView()
        nameStack.axis = .horizontal
        nameStack.distribution = .fillEqually
        nameStack.spacing = MembershipConstants.textFieldStackSpacing
        return nameStack
    }()
    
    private let takeActionView: TakeActionView = {
        let takeActionView = TakeActionView()
        takeActionView.viewModel = MembershipViewModel(type: .signup)
        return takeActionView
    }()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = MembershipConstants.textFieldStackSpacing
        return stack
    }()
    
    // MARK: Init
    
    init() {
        super.init(frame: .zero)
        
        takeActionView.delegate = self
        
        nameStack.addArrangedSubviews([firstNameTextField, lastNameTextField])
        stack.addArrangedSubviews([emailTextField, usernameTextField, nameStack,
                                   passwordTextField, repasswordTextField])
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
            make.centerY.equalToSuperview()
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
    
    func goTo(_ type: ViewType) {
        delegate?.toggleMembershipView(toShowLogin: true)
    }

}
