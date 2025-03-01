//
//  ImageResponseModel.swift
//  AIMadeSimpleApp
//
//  Created by Denis Kravets on 28.2.25.
//  Copyright © 2025 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

struct ImageResponseModel: Decodable {
    let hits: [ImageModel]
}
