//
//  FullScreenFavoriteViewModel.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 29.03.24.
//

import Foundation
import Combine

final class FullScreenFavoriteViewModel: FullScreenFavoriteViewModelProtocol {
    
    // MARK: - Parameters
    
    var favoriteImageData: FullScreenFavoriteDisplayModel
    
    private let deleteButtonTappedPublisher = PassthroughSubject<Void, Never>()
    var anyDeleteButtonTappedPublisher: AnyPublisher<Void, Never> {
        self.deleteButtonTappedPublisher.eraseToAnyPublisher()
    }
    
    private let favoriteImageDeletedPublisher = PassthroughSubject<Int, Never>()
    var anyFavoriteImageDeletedPublisher: AnyPublisher<Int, Never> {
        self.favoriteImageDeletedPublisher.eraseToAnyPublisher()
    }
    
    // MARK: - Initialization
    
    init(favoriteImageData: FullScreenFavoriteDisplayModel) {
        self.favoriteImageData = favoriteImageData
    }
    
    // MARK: - Events
    
    func deleteButtonTapped() {
        self.handleDeleteButtonTapped(
            for: self.favoriteImageData.favoritesIndex
        )
    }
}

// MARK: - Handlers and actions

private extension FullScreenFavoriteViewModel {
    func handleDeleteButtonTapped(for index: Int) {
        self.favoriteImageDeletedPublisher.send(index)
        self.deleteButtonTappedPublisher.send()
    }
}
