//
//  MenuViewModel.swift
//  NomahCoffee-iOSClient
//
//  Created by Caleb Rudnicki on 7/11/21.
//

import Foundation

class MenuViewModel {
    
    // MARK: Properties
    
    let coffees: [Coffee]
    
    // MARK: Init
    
    init(coffees: [Coffee]) {
        self.coffees = coffees
    }
    
}
