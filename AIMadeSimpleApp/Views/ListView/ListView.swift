//
//  ListView.swift
//  AIMadeSimpleApp
//
//  Created by Denis Kravets on 28.2.25.
//  Copyright © 2025 ___ORGANIZATIONNAME___. All rights reserved.
//

import SwiftUI

struct ListView: View {
    
    // MARK: properties
    
    @StateObject private var viewModel = ListViewModel()
    
    @State private var firstImages: [ImageModel] = []
    @State private var secondImages: [ImageModel] = []
    
    @State private var searchText: String = "" // введенный текст пользователя
    
    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""
    
    @State private var isLoadMore: Bool = false
    @State private var currentPage: Int = 1
    
    // MARK: body
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Введите текст...",
                          text: $searchText)
                .padding(.horizontal, 16)
                .textFieldStyle(.roundedBorder)
                .onAppear {
                    UITextField.appearance().clearButtonMode = .whileEditing
                }
                .onChange(of: self.searchText, { oldValue, newValue in
                    
                    self.firstImages.removeAll()
                    self.secondImages.removeAll()
                    self.currentPage = 1
                    
                    if !newValue.isEmpty && oldValue != newValue {
                        Task {
                            await self.loadData()
                        }
                    }
                })
                
                // разводим логику в зависимости от результатов поиска
                if self.searchText.isEmpty { // пустой текст запроса
                    MessageView(text: "Для начала поиска введите текст")
                    
                } else if self.firstImages.isEmpty { // нет картинок
                    MessageView(text: "Ничего не найдено.\nПопробуйте ввести другой текст")
                    
                } else { // есть картинки
                    ScrollImageView(firstImages: self.firstImages,
                                    secondImages: self.secondImages,
                                    isLoadMore: self.isLoadMore) {
                        Task {
                            self.isLoadMore = true
                            self.currentPage += 1
                            
                            // добавил задержку для пагинации
                            try await Task.sleep(nanoseconds: 3 * 1_000_000_000)
                            
                            await self.loadData()
                            self.isLoadMore = false
                        }
                    }
                }
            }
            .navigationTitle("Галерея")
            .navigationBarTitleDisplayMode(.inline)
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Внимание!"),
                  message: Text(self.errorMessage),
                  dismissButton: .default(Text("OK")))
        }
    }
}

private struct MessageView: View {
    
    // MARK: properties
    
    private let text: String
    
    // MARK: initializer
    
    init(text: String) {
        self.text = text
    }
    
    // MARK: body
    
    var body: some View {
        Spacer()
        Text(self.text)
            .font(.headline)
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
            .padding(.top, -40)
        Spacer()
    }
}

private struct ScrollImageView: View {
    
    // MARK: properties
    
    private let firstImages: [ImageModel]
    private let secondImages: [ImageModel]
    private let isLoadMore: Bool
    private let completion: (() -> Void)?
    
    // MARK: initializer
    
    init(firstImages: [ImageModel],
         secondImages: [ImageModel],
         isLoadMore: Bool,
         completion: (() -> Void)?) {
        
        self.firstImages = firstImages
        self.secondImages = secondImages
        self.isLoadMore = isLoadMore
        self.completion = completion
    }
    
    // MARK: body
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ForEach(self.firstImages,
                        id: \.id) { image in
                    // поиск второй картинки для текущей
                    let secondImage = self.secondImages.first(where: { $0.id == image.id })
                    
                    LazyVStack {
                        HStack {
                            // первая картинка
                            ImageView(url: URL(string: image.webformatURL),
                                      tags: image.tags) {
                                
                                if !self.isLoadMore,
                                   image.id == self.firstImages.last?.id {
                                    self.completion?()
                                }
                            }
                            // вторая картинка
                            if let secondImage {
                                ImageView(url: URL(string: secondImage.webformatURL),
                                          tags: secondImage.tags)
                            }
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 10)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray,
                                    lineWidth: 0.7)
                    )
                    .padding(.vertical, 4)
                }
            }
            
            if self.isLoadMore {
                ProgressView("Загрузка...")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .padding(.vertical)
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .padding(.top, 8)
        .padding(.horizontal, 16)
    }
}

private struct ImageView: View {
    
    // MARK: properties
    
    private let url: URL?
    private let tags: String
    private let completion: (() -> Void)?
    
    // MARK: initializer
    
    init(url: URL?,
         tags: String,
         completion: (() -> Void)? = nil) {
        
        self.url = url
        self.tags = tags
        self.completion = completion
    }
    
    // MARK: body
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                AsyncImage(url: self.url) { phase in
                    
                    switch phase {
                        
                    case .empty, .failure:
                        
                        ProgressView()
                            .frame(width: geometry.size.width,
                                   height: 150)
                        
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width,
                                   height: 150)
                        
                    @unknown default:
                        EmptyView()
                    }
                }
                .onAppear {
                    self.completion?()
                }
                .cornerRadius(10)
                .clipped()
            }
            .frame(height: 150)
            
            Text(self.tags)
                .font(.headline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}

private extension ListView {
    
    // загрузка данных
    func loadData() async {
        do {
            async let firstResult = self.viewModel.fetchImageList(self.searchText,
                                                                  page: self.currentPage,
                                                                  type: .search)
            async let secondResult = self.viewModel.fetchImageList(self.searchText,
                                                                   page: self.currentPage,
                                                                   type: .graffiti)
            
            let firstImages = try await firstResult
            let secondImages = try await secondResult
            
            self.firstImages.append(contentsOf: firstImages)
            self.secondImages.append(contentsOf: secondImages)
            
        } catch {
            
            guard let errorMessage = (error as? Errors)?.description else {
                return
            }
            
            self.errorMessage = errorMessage
            self.showErrorAlert = true
        }
    }
}

#Preview {
    ListView()
}
