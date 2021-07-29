//
//  TakeActionView.swift
//  AuthKit
//
//  Created by Caleb Rudnicki on 7/17/21.
//

import UIKit
import SnapKit
import NCUtils

protocol TakeActionViewDelegate {
    /// Triggers a switch to the opposite membership screen
    /// - Parameter type: a `Type` object signifying the membership screen to show
    func goTo(_ type: ViewType)
    /// Trigger either a log in or sign up action
    func submit()
}

/// A subview of the membership screen holding both the
/// login / signup button and the go to button
internal class TakeActionView: UIView {

    // MARK: Properties
    
    var delegate: TakeActionViewDelegate?
    
    var viewModel: MembershipViewModel? {
        didSet {
            guard oldValue?.type != viewModel?.type else { return }
            
            if viewModel?.type == .login {
                submitButton.setTitle(MembershipConstants.Login.submitButtonTitle, for: .normal)
                goToLabel.text = MembershipConstants.Login.toggleText
                goToButton.setTitle(MembershipConstants.Login.toggleButtonTitle, for: .normal)
            } else {
                submitButton.setTitle(MembershipConstants.Signup.submitButtonTitle, for: .normal)
                goToLabel.text = MembershipConstants.Signup.toggleText
                goToButton.setTitle(MembershipConstants.Signup.toggleButtonTitle, for: .normal)
            }
            
            switch AuthKitManager.shared.membershipOption {
            case .loginOnly, .signupOnly:
                goToStack.isHidden = true
                addSubview(submitButton)
            case .loginAndSignup:
                goToStack.isHidden = false
                goToStack.addArrangedSubviews([goToLabel, goToButton])
                addSubviews([submitButton, goToStack])
            }
            
            layoutSubviews()
        }
    }
    
    private let submitButton: UIButton = {
        let submitButton = UIButton()
        submitButton.backgroundColor = Colors.bismark
        submitButton.titleLabel?.font = Fonts.Oxygen.button1
        submitButton.layer.cornerRadius = MembershipConstants.submitButtonCornerRadius
        submitButton.setTitleColor(.white, for: .normal)
        return submitButton
    }()
    
    private let goToLabel: UILabel = {
        let goToLabel = UILabel()
        goToLabel.textColor = .lightGray
        goToLabel.font = Fonts.Oxygen.subtitle2
        return goToLabel
    }()
    
    private let goToButton: UIButton = {
        let goToButton = UIButton()
        goToButton.titleLabel?.font = Fonts.Oxygen.subtitle2
        goToButton.setTitleColor(Colors.rockBlue, for: .normal)
        return goToButton
    }()
    
    private let goToStack: UIStackView = {
        let goToStack = UIStackView()
        goToStack.axis = .horizontal
        goToStack.spacing = MembershipConstants.goToStackSpacing
        return goToStack
    }()
    
    // MARK: Init
    
    init() {
        super.init(frame: .zero)
        
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        goToButton.addTarget(self, action: #selector(goToButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Overrides
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        submitButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(MembershipConstants.submitButtonHorizontalInset)
            make.height.equalTo(MembershipConstants.submitButtonHeight)
            if goToStack.isHidden {
                make.bottom.equalToSuperview()
            }
        }
        
        if !goToStack.isHidden {
            goToStack.snp.makeConstraints { make in
                make.top.equalTo(submitButton.snp.bottom)
                make.centerX.bottom.equalToSuperview()
            }
        }
    }
    
    // MARK: Actions
    
    @objc private func goToButtonTapped() {
        delegate?.goTo(.signup)
    }
    
    @objc private func submitButtonTapped() {
        delegate?.submit()
    }

}
