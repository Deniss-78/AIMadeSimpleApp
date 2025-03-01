//
//  ImageModel.swift
//  AIMadeSimpleApp
//
//  Created by Denis Kravets on 28.2.25.
//  Copyright © 2025 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

struct ImageModel: Decodable,
                   Identifiable {
    
    let id: Int
    let tags: String
    let webformatURL: String
}
