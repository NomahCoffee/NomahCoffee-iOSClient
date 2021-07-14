//
//  MenuViewController.swift
//  NomahCoffee-iOSClient
//
//  Created by Caleb Rudnicki on 7/11/21.
//

import UIKit
import SnapKit
import AuthKit

class MenuViewController: UIViewController, MenuViewDelegate {
    
    // MARK: Properties
    
    private lazy var menuView: MenuView = {
        let menuView = MenuView()
        menuView.delegate = self
        return menuView
    }()
    
    // MARK: Init

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "cart"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(cartButtonTapped))
        title = MenuConstants.navigationBarTitle
        
        view.backgroundColor = .systemBackground
        view.addSubview(menuView)
        
        menuView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        NetworkingManager.getCoffee(completion: { coffees, error in
            if let error = error {
                let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                guard let coffees = coffees else { return }
                self.menuView.viewModel = MenuViewModel(coffees: coffees)
            }
        })
    }
    
    // MARK: Actions
    
    @objc private func cartButtonTapped() {
        let navigationController = UINavigationController(rootViewController: CartViewController())
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: MenuViewDelegate
    
    func logout() {
        AuthKitManager.shared.logout(from: self)
    }
    
    func present(viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
    
    func add(_ coffee: Coffee) {
        NetworkingManager.addToCart(coffee: coffee, completion: { currentUser, error in
            if let error = error {
                let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Successfully added \(coffee) to cart!",
                                              message: nil,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }

}
