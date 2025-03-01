//
//  Errors.swift
//  AIMadeSimpleApp
//
//  Created by Denis Kravets on 28.2.25.
//  Copyright © 2025 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

/// обработчик ошибок
enum Errors: Error,
             Equatable {
    
    // расположено в алфовитном порядке
    case imageListFailure
    case invalidURL
}

extension Errors: LocalizedError {
    
    var description: String {
        
        switch self {
            
        case .imageListFailure:
            return "Ошибка получения списка изображений"
            
        case .invalidURL:
            return "некорректный URL"
        }
    }
}
