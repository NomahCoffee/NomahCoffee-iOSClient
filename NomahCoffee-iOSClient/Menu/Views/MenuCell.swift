//
//  MenuCell.swift
//  NomahCoffee-iOSClient
//
//  Created by Caleb Rudnicki on 7/11/21.
//

import UIKit
import SnapKit
import NCUtils

protocol CartProtocol {
    /// Triggers an add to cart action
    /// - Parameter coffee: the `Coffee` object that is to be added
    /// - Parameter quantity: an `Int` representing the quantity of coffee
    func add(coffee: Coffee, with quantity: Int)
}

class MenuCell: UICollectionViewCell {
    
    // MARK: Properties
    
    static let reuseIdentifier = String(describing: MenuCell.self)
    
    var delegate: CartProtocol?
    
    var coffee: Coffee? {
        didSet {
            if let imageUrl = coffee?.image {
                imageView.load(url: imageUrl)
            } else {
                imageView.image = nil
            }
            titleLabel.text = coffee?.name
            
            let formatter = NumberFormatter()
            formatter.locale = Locale.current
            formatter.numberStyle = .currency
            if let price = formatter.string(from: (coffee?.price ?? 0.0) as NSNumber) {
                priceLabel.text = price
            }
            
            configureCell()
        }
    }
    
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
        titleLabel.font = FontManager.OxygenBoldFontSize(24)
        titleLabel.numberOfLines = 1
        return titleLabel
    }()
    
    private let priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.lineBreakMode = .byTruncatingTail
        priceLabel.font = FontManager.OxygenRegularFontSize(20)
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
    
    private let addToCartButton: UIButton = {
        let addToCartButton = UIButton()
        addToCartButton.setTitle("Add to Cart", for: .normal)
        addToCartButton.setTitleColor(.white, for: .normal)
        addToCartButton.backgroundColor = Colors.bismark
        addToCartButton.titleLabel?.font = FontManager.OxygenBoldFontSize(16)
        addToCartButton.layer.cornerRadius = 16
        return addToCartButton
    }()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.masksToBounds = true
        layer.cornerRadius = 16
        backgroundColor = Colors.sorrellBrown
        
        configureCell()
        addToCartButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        coffee = nil
    }
    
    private func configureCell() {
        horizontalStack.addArrangedSubviews([priceLabel, quantityStepper])
        addSubviews([imageView, titleLabel, horizontalStack, addToCartButton])
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        quantityStepper.snp.makeConstraints { make in
            make.height.equalTo(32)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        horizontalStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        addToCartButton.snp.makeConstraints { make in
            make.top.equalTo(horizontalStack.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(8)
            make.height.equalTo(48)
        }
    }
    
    // MARK: Actions
    
    @objc private func addButtonTapped() {
        guard
            let coffee = coffee,
            let quantityText = quantityStepper.quantityLabel.text,
            let quantity = Int(quantityText)
        else { return }
        
        delegate?.add(coffee: coffee, with: quantity)
    }
    
}

extension UIImageView {
    
    /// Loads an image from a URL asynchronously
    /// - Parameter url: the `URL` where the image lives
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
}
