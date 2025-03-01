//
//  DetailedView.swift
//  AIMadeSimpleApp
//
//  Created by Denis Kravets on 1.3.25.
//  Copyright © 2025 ___ORGANIZATIONNAME___. All rights reserved.
//

import SwiftUI

struct DetailedView: View {
    
    // MARK: properties
    
    @State private var selectedIndex = 0
    
    private let firstString: String?
    private let secondString: String?
    private let number: Int
    
    // MARK: initializer
    
    init(firstString: String? = nil,
         secondString: String? = nil,
         number: Int = 1) {
        
        self.firstString = firstString
        self.secondString = secondString
        self.number = number
    }
    
    // MARK: body
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedIndex) {
                // первая картинка
                if let firstString {
                    ImageView(string: firstString,
                              number: "Первая картинка")
                    .padding(.horizontal, 10)
                    .tag(0)
                }
                // вторая картинка
                if let secondString {
                    ImageView(string: secondString,
                              number: "Вторая картинка")
                    .padding(.horizontal, 10)
                    .tag(1)
                }
            }
            .tabViewStyle(.page)
            .onAppear {
                self.selectedIndex = self.number == 1 ? 0 : 1
            }
        }
        .navigationTitle("Картинка")
    }
}

private struct ImageView: View {
    
    // MARK: properties
    
    let string: String
    let number: String
    
    // MARK: initializer
    
    init(string: String, number: String) {
        
        self.string = string
        self.number = number
    }
    
    // MARK: body
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: self.string)) { phase in
                
                switch phase {
                    
                case .empty, .failure:
                    
                    ProgressView()
                        .frame(maxWidth: .infinity)
                    
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                    
                @unknown default:
                    EmptyView()
                }
            }
            .cornerRadius(10)
            
            Text(self.number)
                .font(.headline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    DetailedView()
}
