//
//  ProductDetailViewController.swift
//  NomahCoffee-iOSClient
//
//  Created by Caleb Rudnicki on 7/11/21.
//

import UIKit
import SnapKit
import NCUtils

class ProductDetailViewController: UIViewController, CartProtocol {
    
    // MARK: Properties
    
    private lazy var productDetailView: ProductDetailView = {
        let productDetailView = ProductDetailView()
        productDetailView.cartDelegate = self
        return productDetailView
    }()
    
    // MARK: Init
    
    init(coffee: Coffee) {
        super.init(nibName: nil, bundle: nil)
        
        productDetailView.coffee = coffee
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.sorrellBrown
        view.addSubview(productDetailView)
        
        productDetailView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: CartProtocol
    
    func add(coffee: Coffee, with quantity: Int) {
        NetworkingManager.addToCart(coffee: coffee, with: quantity, completion: { currentUser, error in
            if let error = error {
                let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Successfully added \(coffee.name) to cart!",  
                                              message: nil,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
}
