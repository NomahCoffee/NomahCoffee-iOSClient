//
//  CartCell.swift
//  NomahCoffee-iOSClient
//
//  Created by Caleb Rudnicki on 7/11/21.
//

import UIKit
import NCUtils

class CartCell: UITableViewCell {

    // MARK: Properties
    
    static let reuseIdentifier = String(describing: CartCell.self)
            
    var cartItem: CartItem? {
        didSet {
            if let imageUrl = cartItem?.coffee.image {
                productImageView.load(url: imageUrl)
            } else {
                productImageView.image = nil
            }
            titleLabel.text = cartItem?.coffee.name
            
            let formatter = NumberFormatter()
            formatter.locale = Locale.current
            formatter.numberStyle = .currency
            if let price = formatter.string(from: (cartItem?.coffee.price ?? 0.0) as NSNumber) {
                subtitleLabel.text = price
            }
            
            if let quantity = cartItem?.quantity {
                quantityLabel.text = "\(CartConstants.quantityButtonTitle): \(quantity)"
            }
            
            configureCell()
        }
    }
    
    private let productImageView: UIImageView = {
        let productImageView = UIImageView()
        productImageView.backgroundColor = .systemGray
        productImageView.contentMode = .scaleAspectFill
        productImageView.layer.cornerRadius = CartConstants.imageViewCornerRadius
        productImageView.layer.masksToBounds = true
        return productImageView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.font = FontManager.OxygenBoldFontSize(24)
        titleLabel.numberOfLines = 1
        return titleLabel
    }()
    
    private let subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.lineBreakMode = .byTruncatingTail
        subtitleLabel.font = FontManager.OxygenRegularFontSize(20)
        subtitleLabel.numberOfLines = 1
        return subtitleLabel
    }()
    
    private let quantityLabel: UILabel = {
        let quantityLabel = UILabel()
        quantityLabel.lineBreakMode = .byTruncatingTail
        quantityLabel.font = FontManager.OxygenRegularFontSize(20)
        quantityLabel.numberOfLines = 1
        return quantityLabel
    }()
    
    private let labelStack: UIStackView = {
        let labelStack = UIStackView()
        labelStack.axis = .vertical
//        labelStack.distribution = .fillEqually
        labelStack.spacing = 4//CartConstants.labelStackSpacing
        return labelStack
    }()
    
    // MARK: Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Colors.rockBlue
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        cartItem = nil
    }
    
    private func configureCell() {
        labelStack.addArrangedSubviews([titleLabel, subtitleLabel, quantityLabel])
        addSubviews([productImageView, labelStack])
        
        productImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(CartConstants.cellInset)
            make.height.equalTo(productImageView.snp.width)
        }
        
        labelStack.snp.makeConstraints { make in
            make.leading.equalTo(productImageView.snp.trailing).offset(CartConstants.cellInset)
            make.top.trailing.equalToSuperview().inset(CartConstants.cellInset)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
}
