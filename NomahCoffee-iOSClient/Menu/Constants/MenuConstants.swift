//
//  MenuConstants.swift
//  NomahCoffee-iOSClient
//
//  Created by Caleb Rudnicki on 7/11/21.
//

import UIKit

struct MenuConstants {
    
    static var collectionViewInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    static var cellSize: CGSize {
        let columnCount: CGFloat = 2
        // Set the space between the colums to be be half of the outer margins (24+12+24)
        let totalInset = collectionViewInsets.left * 2 + ((columnCount - 1) * (collectionViewInsets.left / 2))
        let storyWidth = (UIScreen.main.bounds.width - totalInset) / columnCount
        return CGSize(width: 250, height: 400)
    }
    
    static let imageViewCornerRadius: CGFloat = 4
    static let imageViewBorderWidth: CGFloat = 1
    static let labelStackSpacing: CGFloat = 8
    static let logoutButtonHeight: CGFloat = 64
    
    static let logoutButtonTitle: String = "Logout"
    static let navigationBarTitle: String = "Menu"
    
}
