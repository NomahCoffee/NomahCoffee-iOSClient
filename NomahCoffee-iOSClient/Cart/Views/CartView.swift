//
//  CartView.swift
//  NomahCoffee-iOSClient
//
//  Created by Caleb Rudnicki on 7/11/21.
//

import UIKit
import NCUtils

protocol CartViewDelegate {
    /// Triggers a checkout attempt
    func checkout()
    /// Triggers a cart item to be deleted
    /// - Parameter cartItem: the `CartItem` that is to be deleted from cart
    func delete(_ cartItem: CartItem)
}

class CartView: UIView, UITableViewDataSource, UITableViewDelegate {

    // MARK: Properties
    
    var delegate: CartViewDelegate?
        
    var viewModel: CartViewModel? {
        didSet {
            tableView.reloadData()
            
            // Count the total price
            guard let cartItems = viewModel?.cartItems else { return }
            var totalPrice = 0.0
            for item in cartItems {
                totalPrice += item.coffee.price * Double(item.quantity)
            }
            let formatter = NumberFormatter()
            formatter.locale = Locale.current
            formatter.numberStyle = .currency
            if let totalPriceString = formatter.string(from: totalPrice as NSNumber) {
                checkoutButton.setTitle("\(CartConstants.checkoutButtonTitle) \(totalPriceString)",
                                        for: .normal)
            }
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = Colors.rockBlue
        tableView.register(CartCell.self, forCellReuseIdentifier: CartCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private let checkoutButton: UIButton = {
        let checkoutButton = UIButton()
        checkoutButton.setTitle(CartConstants.checkoutButtonTitle, for: .normal)
        checkoutButton.setTitleColor(.white, for: .normal)
        checkoutButton.backgroundColor = Colors.bismark
        checkoutButton.titleLabel?.font = FontManager.OxygenBoldFontSize(16)
        checkoutButton.addTarget(self, action: #selector(checkoutButtonTapped), for: .touchUpInside)
        checkoutButton.layer.cornerRadius = 16
        return checkoutButton
    }()
    
    // MARK: Init
    
    init() {
        super.init(frame: .zero)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        addSubviews([tableView, checkoutButton])
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        checkoutButton.snp.makeConstraints { make in
            make.height.equalTo(CartConstants.checkoutButtonHeight)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(24)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    
    @objc private func checkoutButtonTapped() {
        delegate?.checkout()
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.cartItems.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.reuseIdentifier, for: indexPath) as? CartCell,
              let cartItem = viewModel?.cartItems[indexPath.row]
        else {
            return UITableViewCell()
        }
        
        cell.cartItem = cartItem
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let cartItems = viewModel?.cartItems else { return }
            delegate?.delete(cartItems[indexPath.row])
        }
    }

}
