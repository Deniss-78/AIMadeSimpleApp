//
//  ListViewModel.swift
//  AIMadeSimpleApp
//
//  Created by Denis Kravets on 28.2.25.
//  Copyright © 2025 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol ListViewModelProtocol: AnyObject {
    
    func fetchImageList(_ text: String,
                        page: Int,
                        type: ImageListNetworkService.ImageListType) async throws -> [ImageModel]
}

final class ListViewModel: ObservableObject {
    
}

// MARK: реализация протокола ListViewModelProtocol

extension ListViewModel: ListViewModelProtocol {
    
    // получение списка изображений
    func fetchImageList(_ text: String,
                        page: Int,
                        type: ImageListNetworkService.ImageListType) async throws -> [ImageModel] {
        
        try await ImageListNetworkService().fetchImageList(text,
                                                           page: page,
                                                           type: type)
    }
}
