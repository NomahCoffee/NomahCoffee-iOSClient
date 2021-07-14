//
//  MenuCell.swift
//  NomahCoffee-iOSClient
//
//  Created by Caleb Rudnicki on 7/11/21.
//

import UIKit
import SnapKit

protocol MenuCellDelegate {
    /// Triggers an add to cart action
    /// - Parameter coffee: the `Coffee` object that is to be added
    func add(coffee: Coffee)
}

class MenuCell: UICollectionViewCell {
    
    // MARK: Properties
    
    static let reuseIdentifier = String(describing: MenuCell.self)
    
    var delegate: MenuCellDelegate?
    
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
                subtitleLabel.text = price
            }
            
            configureCell()
        }
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = MenuConstants.imageViewBorderWidth
        imageView.layer.cornerRadius = MenuConstants.imageViewCornerRadius
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 1
        return titleLabel
    }()
    
    private let subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.lineBreakMode = .byTruncatingTail
        subtitleLabel.numberOfLines = 1
        return subtitleLabel
    }()
    
    private let labelStack: UIStackView = {
        let labelStack = UIStackView()
        labelStack.axis = .vertical
        labelStack.spacing = MenuConstants.labelStackSpacing
        return labelStack
    }()
    
    private let addButton: UIButton = {
        let addButton = UIButton()
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        return addButton
    }()
    
    private let detailStack: UIStackView = {
        let detailStack = UIStackView()
        detailStack.axis = .horizontal
        detailStack.spacing = MenuConstants.labelStackSpacing
        return detailStack
    }()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        coffee = nil
    }
    
    private func configureCell() {
        labelStack.addArrangedSubviews([titleLabel, subtitleLabel])
        detailStack.addArrangedSubviews([labelStack, addButton])
        addSubviews([imageView, detailStack])
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        
        detailStack.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: Actions
    
    @objc private func addButtonTapped() {
        guard let coffee = coffee else { return }
        delegate?.add(coffee: coffee)
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
