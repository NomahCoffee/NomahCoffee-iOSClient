//
//  MembershipViewModel.swift
//  AuthKit
//
//  Created by Caleb Rudnicki on 7/16/21.
//

import Foundation

enum ViewType {
    case login
    case signup
}

class MembershipViewModel {
    
    // MARK: Properties
    
    var type: ViewType
    
    // MARK: Init
    
    init(type: ViewType) {
        self.type = type
    }
    
}
