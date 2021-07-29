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
import NCUtils

class CartViewController: UIViewController, CartViewDelegate {
    
    // MARK: Properties
    
    private var paymentSheet: PaymentSheet?
    
    lazy var header: CartHeader = {
        let header = CartHeader()
        return header
    }()
    
    lazy var cartView: CartView = {
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceivedData(_:)), name: .didReceiveData, object: nil)
        
        view.backgroundColor = Colors.rockBlue
        view.addSubviews([header, cartView])
        
        header.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        cartView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        if let me = AuthKitManager.shared.currentUser as? User {
            self.cartView.viewModel = CartViewModel(cartItems: me.cart)
        }
        
        AuthKitManager.shared.updateCurrentUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let me = AuthKitManager.shared.currentUser as? User {
            let viewModel = CartViewModel(cartItems: me.cart)
            self.header.viewModel = viewModel
            self.cartView.viewModel = viewModel
        }
        
        setupPaymentDrawer()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .didReceiveData, object: nil)
    }
    
    func setupPaymentDrawer() {
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
                    let viewModel = CartViewModel(cartItems: currentUser.cart)
                    self.header.viewModel = viewModel
                    self.cartView.viewModel = viewModel
                }
            }
        })
    }
    
    // MARK: NotificationCenter
    
    @objc func onDidReceivedData(_ notification: Notification) {
        if let me = AuthKitManager.shared.currentUser as? User {
            let viewModel = CartViewModel(cartItems: me.cart)
            self.header.viewModel = viewModel
            self.cartView.viewModel = viewModel
            self.setupPaymentDrawer()
        }
    }

}

extension Notification.Name {
    
    static let didReceiveData = Notification.Name("didReceiveData")
    
}
