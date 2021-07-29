//
//  ProductDetailView.swift
//  NomahCoffee-iOSClient
//
//  Created by Caleb Rudnicki on 7/14/21.
//

import UIKit
import NCUtils
import SnapKit

class ProductDetailView: UIScrollView {
    
    // MARK: Properties
    
    var cartDelegate: CartProtocol?
    
    var coffee: Coffee? {
        didSet {
            if let imageUrl = coffee?.image {
                imageView.load(url: imageUrl)
            } else {
                imageView.image = nil
            }
            
            titleLabel.text = coffee?.name
            descriptionLabel.text = coffee?.description
            
            let formatter = NumberFormatter()
            formatter.locale = Locale.current
            formatter.numberStyle = .currency
            if let price = formatter.string(from: (coffee?.price ?? 0.0) as NSNumber) {
                priceLabel.text = price
            }
        }
    }
    
    private let backgroundView: UIView = {
        let backgroundView = UIView()
        return backgroundView
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.font = FontManager.OxygenBoldFontSize(32)
        titleLabel.numberOfLines = 1
        return titleLabel
    }()
    
    private let priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.lineBreakMode = .byTruncatingTail
        priceLabel.font = FontManager.OxygenRegularFontSize(24)
        priceLabel.numberOfLines = 1
        return priceLabel
    }()
    
    private let quantityStepper = QuantityStepper()
    
    private let horizontalStack: UIStackView = {
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = MenuConstants.labelStackSpacing
        return horizontalStack
    }()
    
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.lineBreakMode = .byTruncatingTail
        descriptionLabel.font = FontManager.OxygenLightFontSize(20)
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    
    private let addToCartButton: UIButton = {
        let addToCartButton = UIButton()
        addToCartButton.setTitle("Add to Cart", for: .normal)
        addToCartButton.setTitleColor(.white, for: .normal)
        addToCartButton.backgroundColor = Colors.bismark
        addToCartButton.titleLabel?.font = FontManager.OxygenBoldFontSize(16)
        addToCartButton.layer.cornerRadius = 16
        addToCartButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return addToCartButton
    }()
    
    // MARK: Init
    
    init() {
        super.init(frame: .zero)
        
        horizontalStack.addArrangedSubviews([priceLabel, quantityStepper])
        backgroundView.addSubviews([imageView, titleLabel, horizontalStack, descriptionLabel, addToCartButton])
        addSubview(backgroundView)
                
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(imageView.snp.width).multipliedBy(1.2)
        }
        
        quantityStepper.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        horizontalStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(horizontalStack.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        addToCartButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(8)
            make.height.equalTo(64)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    
    @objc private func addButtonTapped() {
        guard
            let coffee = coffee,
            let quantityText = quantityStepper.quantityLabel.text,
            let quantity = Int(quantityText)
        else { return }
        
        cartDelegate?.add(coffee: coffee, with: quantity)
    }
    
}
