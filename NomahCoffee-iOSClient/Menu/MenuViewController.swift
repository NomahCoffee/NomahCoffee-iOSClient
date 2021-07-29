//
//  MenuViewController.swift
//  NomahCoffee-iOSClient
//
//  Created by Caleb Rudnicki on 7/11/21.
//

import UIKit
import SnapKit
import AuthKit
import NCUtils

class MenuViewController: UIViewController, MenuViewDelegate, UIGestureRecognizerDelegate {
    
    // MARK: Properties
    
    private lazy var menuView: MenuView = {
        let menuView = MenuView()
        menuView.menuViewDelegate = self
        return menuView
    }()
    
    private let cartViewController: CartViewController = {
        let cartViewController = CartViewController()
        cartViewController.view.layer.cornerRadius = 16
        cartViewController.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return cartViewController
    }()
    
    private var lastDirectionWasUp: Bool = false
        
    // MARK: Init

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        gesture.delegate = self
        cartViewController.header.addGestureRecognizer(gesture)
        
        view.addSubviews([menuView, cartViewController.view])
        
        menuView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cartViewController.view.snp.makeConstraints { make in
//            make.top.equalTo(menuView.collectionView.snp.bottom).offset(32)
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(view.snp.height)
        }
        
        self.cartViewController.view.frame = CGRect(x: 0,
                                               y: self.lastDirectionWasUp ? 0 : self.menuView.collectionView.frame.maxY + 32,
                                               width: self.view.frame.width,
                                               height: self.view.frame.height)
        
        cartViewController.cartView.isUserInteractionEnabled = false
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
                
        self.cartViewController.view.frame = CGRect(x: 0,
                                               y: self.lastDirectionWasUp ? 0 : self.menuView.collectionView.frame.maxY + 32,
                                               width: self.view.frame.width,
                                               height: self.view.frame.height)
    }
    
    // MARK: CartProtocol
    
    func present(viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
    
    func add(_ coffee: Coffee, with quantity: Int) {
        NetworkingManager.addToCart(coffee: coffee, with: quantity, completion: { currentUser, error in
            if let error = error {
                let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                AuthKitManager.shared.updateCurrentUser()
                let alert = UIAlertController(title: "Successfully added \(coffee.name) to cart!",
                                              message: nil,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { _ in
                    NotificationCenter.default.post(name: .didReceiveData, object: nil)
                    self.cartViewController.view.frame = CGRect(x: 0,
                                                                y: self.lastDirectionWasUp ? 0 : self.menuView.collectionView.frame.maxY + 32,
                                                                width: self.view.frame.width,
                                                                height: self.view.frame.height)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    // MARK: Actions
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        
        if recognizer.state == .ended {
            UIView.animate(withDuration: 0.5) {
                self.cartViewController.view.frame = CGRect(x: 0,
                                                       y: self.lastDirectionWasUp ? 0 : self.menuView.collectionView.frame.maxY + 32,
                                                       width: self.view.frame.width,
                                                       height: self.view.frame.height)
            }
            
            cartViewController.cartView.isUserInteractionEnabled = self.lastDirectionWasUp
        } else {
            if recognizer.velocity(in: view).y < 0 {
                lastDirectionWasUp = true
            } else if recognizer.velocity(in: view).y > 0 {
                lastDirectionWasUp = false
            }
            
            let y = cartViewController.view.frame.minY
            cartViewController.view.frame = CGRect(x: 0,
                                              y: max(y + translation.y, 0),
                                              width: view.frame.width,
                                              height: view.frame.height)
            recognizer.setTranslation(.zero, in: view)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}











internal class FontManager {
    
    // MARK: Public Functions
    
    class func OxygenBoldFontSize(_ size: CGFloat) -> UIFont {
        let fontName = "Oxygen-Bold"
        return loadFont(withName: fontName, size: size)
    }
    
    class func OxygenLightFontSize(_ size: CGFloat) -> UIFont {
        let fontName = "Oxygen-Light"
        return loadFont(withName: fontName, size: size)
    }
    
    class func OxygenRegularFontSize(_ size: CGFloat) -> UIFont {
        let fontName = "Oxygen-Regular"
        return loadFont(withName: fontName, size: size)
    }
    
    // MARK: Private Functions
    
    private class func loadFont(withName fontName: String, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: fontName, size: size) else {
            loadFontFromBundle(fontName)
            guard let font = UIFont(name: fontName, size: size) else {
                return UIFont.systemFont(ofSize: size)
            }
            return font
        }
        return font
    }
    
    private class func loadFontFromBundle(_ fontName: String) {
        let bundle = Bundle(for: FontManager.self)
        if let resourceURL = bundle.url(forResource: fontName, withExtension: "ttf") {
            if let fontData = try? Data(contentsOf: resourceURL) {
                if let provider = CGDataProvider(data: fontData as CFData), let fontRef = CGFont(provider) {
                    var error: Unmanaged<CFError>?
                    CTFontManagerRegisterGraphicsFont(fontRef, &error)
                }
            }
        }
    }
    
}
