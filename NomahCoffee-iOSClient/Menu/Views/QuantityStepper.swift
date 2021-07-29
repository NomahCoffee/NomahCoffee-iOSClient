//
//  QuantityStepper.swift
//  NomahCoffee-iOSClient
//
//  Created by Caleb Rudnicki on 7/18/21.
//

import UIKit
import SnapKit
import NCUtils

class QuantityStepper: UIView {
    
    // MARK: Properties
    
    private let minusButton: UIButton = {
        let minusButton = UIButton()
        minusButton.setTitle("-", for: .normal)
        minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        minusButton.titleLabel?.font = FontManager.OxygenRegularFontSize(20)
        return minusButton
    }()
    
    public let quantityLabel: UILabel = {
        let quantityLabel = UILabel()
        quantityLabel.text = "1"
        quantityLabel.font = FontManager.OxygenRegularFontSize(20)
        return quantityLabel
    }()
    
    private let plusButton: UIButton = {
        let plusButton = UIButton()
        plusButton.setTitle("+", for: .normal)
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        plusButton.titleLabel?.font = FontManager.OxygenRegularFontSize(20)
        return plusButton
    }()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()
    
    // MARK: Init

    init() {
        super.init(frame: .zero)
        
        backgroundColor = Colors.shadow
        
        stack.addArrangedSubviews([minusButton, quantityLabel, plusButton])
        addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height / 4 * 1.5
    }
    
    // MARK: Actions
    
    @objc private func minusButtonTapped() {
        guard
            let quantityText = quantityLabel.text,
            let quantity = Int(quantityText),
            quantity > 1
        else { return }
        
        quantityLabel.text = String(describing: quantity - 1)
    }
    
    @objc private func plusButtonTapped() {
        guard
            let quantityText = quantityLabel.text,
            let quantity = Int(quantityText)
        else { return }
        
        quantityLabel.text = String(describing: quantity + 1)
    }
    
}
