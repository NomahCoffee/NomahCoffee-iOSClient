//
//  CartViewController.swift
//  NomahCoffee-iOSClient
//
//  Created by Caleb Rudnicki on 7/10/21.
//

import UIKit
import SnapKit
import Stripe
import AuthKit

class CartViewController: UIViewController, CartViewDelegate {
    
    // MARK: Properties
    
    private var paymentSheet: PaymentSheet?
    
    private lazy var cartView: CartView = {
        let cartView = CartView()
        cartView.delegate = self
        return cartView
    }()
        
    // MARK: Init

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                           target: self,
                                                           action: #selector(closeButtonTapped))
        title = CartConstants.navigationBarTitle
        
        view.backgroundColor = .systemBackground
        view.addSubview(cartView)
        
        cartView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Fetch the PaymentIntent and Customer information from the backend if user has something in their cart
        guard let user = AuthKitManager.shared.currentUser as? User, user.cart.count > 0 else { return }
        
        NetworkingManager.setupPayment(completion: { customerId, customerEphemeralKeySecret, paymentIntentClientSecret, error in
            if let error = error {
                let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                guard
                    let customerId = customerId,
                    let customerEphemeralKeySecret = customerEphemeralKeySecret,
                    let paymentIntentClientSecret = paymentIntentClientSecret
                else {
                    return
                }
                
                var configuration = PaymentSheet.Configuration()
                configuration.merchantDisplayName = CartConstants.merchantDisplayName
                configuration.customer = .init(id: customerId,
                                               ephemeralKeySecret: customerEphemeralKeySecret)
                self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let me = AuthKitManager.shared.currentUser as? User {
            self.cartView.viewModel = CartViewModel(cartItems: me.cart)
        }
    }
    
    // MARK: Action
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: CartViewDelegate
    
    func checkout() {
        paymentSheet?.present(from: self) { paymentResult in
            switch paymentResult {
            case .completed:
                NetworkingManager.clearCart(completion: { currentUser, error in
                    if let error = error {
                        let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        guard
                            let currentUser = currentUser,
                            !currentUser.cart.isEmpty
                        else { return }
                        
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                })
            case .canceled: break
            case .failed(let error):
                let alert = UIAlertController(title: CartConstants.failedPaymentPresentErrorTitle,
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
        
    func delete(_ cartItem: CartItem) {
        NetworkingManager.deleteFromCart(cartItem: cartItem, completion: { currentUser, error in
            if let error = error {
                let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                guard let currentUser = currentUser else { return }
                
                DispatchQueue.main.async {
                    self.cartView.viewModel = CartViewModel(cartItems: currentUser.cart)
                }
            }
        })
    }

}
