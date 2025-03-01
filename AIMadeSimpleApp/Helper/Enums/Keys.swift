//
//  Keys.swift
//  AIMadeSimpleApp
//
//  Created by Denis Kravets on 28.2.25.
//  Copyright © 2025 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

enum Keys {
    
    case apiKey
    case pixabayAPI
    
    var value: String {
        
        switch self {
            
        case .apiKey:
            return "38738026-cb365c92113f40af7a864c24a"
            
        case .pixabayAPI:
            return "https://pixabay.com/api/"
        }
    }
}
