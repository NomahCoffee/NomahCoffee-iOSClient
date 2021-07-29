//
//  HeadlineView.swift
//  AuthKit
//
//  Created by Caleb Rudnicki on 7/16/21.
//

import UIKit
import SnapKit
import NCUtils

/// A subview of the membership screen holding the title and subtitle
internal class HeadlineView: UIView {
    
    // MARK: Properties
    
    var viewModel: MembershipViewModel? {
        didSet {
            guard oldValue?.type != viewModel?.type else { return }
            
            if viewModel?.type == .login {
                titleLabel.text = MembershipConstants.Login.headerTitle
                subtitleLabel.text = MembershipConstants.Login.headerSubtitle
            } else {
                titleLabel.text = MembershipConstants.Signup.headerTitle
                subtitleLabel.text = MembershipConstants.Signup.headerSubtitle
            }
        }
    }
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = Fonts.Oxygen.header1
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private let subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.font = Fonts.Oxygen.body2
        subtitleLabel.textColor = .lightGray
        subtitleLabel.textAlignment = .center
        return subtitleLabel
    }()
    
    // MARK: Init

    init() {
        super.init(frame: .zero)
        
        addSubviews([titleLabel, subtitleLabel])
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(MembershipConstants.headlineTextVerticalSpacing)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
