//
//  SettingsViewController.swift
//  NomahCoffee-iOSClient
//
//  Created by Caleb Rudnicki on 7/22/21.
//

import UIKit
import AuthKit

class SettingsViewController: UIViewController {
    
    let popup = UIAlertController(title: "Want to logout", message: nil, preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground

        popup.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            AuthKitManager.shared.logout(from: self)
        }))
        popup.addAction(UIAlertAction(title: "No", style: .destructive, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        
        present(popup, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        present(popup, animated: true, completion: nil)
    }
    

}
