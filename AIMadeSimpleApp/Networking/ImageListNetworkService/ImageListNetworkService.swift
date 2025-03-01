//
//  ImageListNetworkService.swift
//  AIMadeSimpleApp
//
//  Created by Denis Kravets on 28.2.25.
//  Copyright © 2025 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

final class ImageListNetworkService {
    
    // MARK: enum
    
    enum ImageListType {
        
        case search
        case graffiti
    }
    
    // MARK: methods
    
    // получение списка картинок
    func fetchImageList(_ text: String,
                        page: Int,
                        type: ImageListType) async throws -> [ImageModel] {
        
        var url: URL?
        
        switch type {
            
        case .search:
            url = URL(string: "\(Keys.pixabayAPI.value)?key=\(Keys.apiKey.value)&page=\(page)&per_page=10&q=\(text)")
        case .graffiti:
            url = URL(string: "\(Keys.pixabayAPI.value)?key=\(Keys.apiKey.value)&page=\(page)&per_page=10&q=\(text)%20graffiti")
        }
        
        guard let url else {
            throw Errors.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                throw Errors.imageListFailure
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                
                let response = try decoder.decode(ImageResponseModel.self,
                                                  from: data)
                return response.hits
                
            } catch {
                throw Errors.imageListFailure
            }
        } catch {
            throw Errors.imageListFailure
        }
    }
}
