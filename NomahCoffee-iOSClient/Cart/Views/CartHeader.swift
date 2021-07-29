//
//  CartHeader.swift
//  NomahCoffee-iOSClient
//
//  Created by Caleb Rudnicki on 7/27/21.
//

import UIKit
import SnapKit
import NCUtils

class CartHeader: UIView {
    
    // MARK: Properties
            
    var viewModel: CartViewModel? {
        didSet {
            guard
                let cartCount = viewModel?.cartItems.count,
                cartCount > 0
            else {
                titleLabel.text = CartConstants.navigationBarTitle
                return
            }
            titleLabel.text = CartConstants.navigationBarTitle + " (\(cartCount))"
        }
    }
    
    private var pullBar: UIView = {
        let pullBar = UIView()
        pullBar.backgroundColor = .black
        pullBar.layer.cornerRadius = 4
        return pullBar
    }()
    
    private var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = CartConstants.navigationBarTitle
        titleLabel.font = Fonts.Oxygen.header1
        return titleLabel
    }()
    
    // MARK: Init
    
    init() {
        super.init(frame: .zero)
        
        addSubviews([pullBar, titleLabel])
        
        pullBar.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.height.equalTo(2)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(24)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
