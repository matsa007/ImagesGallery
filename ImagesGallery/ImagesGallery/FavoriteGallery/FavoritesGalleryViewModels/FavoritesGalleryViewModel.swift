//
//  FavoritesGalleryViewModel.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 29.03.24.
//

import Foundation
import Combine

final class FavoritesGalleryViewModel: FavoritesGalleryViewModelProtocol {
    
    // MARK: - Parameters
    
    var favoritesDisplayData: [FavoritesGallerDisplayModel]
    
    private let selectedItemPublisher = PassthroughSubject<Int, Never>()
    var anySelectedItemPublisher: AnyPublisher<Int, Never> {
        self.selectedItemPublisher.eraseToAnyPublisher()
    }
    
    private let favoritesDisplayDataUpdated = PassthroughSubject<Void, Never>()
    var anyFavoritesDisplayDataUpdated: AnyPublisher<Void, Never> {
        self.favoritesDisplayDataUpdated.eraseToAnyPublisher()
    }
    
    // MARK: - Initialization
    
    init(favoritesDisplayData: [FavoriteImageModel]) {
        self.favoritesDisplayData = favoritesDisplayData.map {
            FavoritesGallerDisplayModel(
                id: $0.id,
                imageData: $0.regularImageData
            )
        }
    }
    
    // MARK: - Events
    
    func collectionViewItemSelected(with index: Int) {
        self.handleCollectionViewItemSelected(for: index)
    }
    
    func favoriteImageDeleted(with index: Int) {
        self.handleFavoriteImageDeleted(with: index)
    }
}

// MARK: - Handlers and actions

private extension FavoritesGalleryViewModel {
    func handleCollectionViewItemSelected(for index: Int) {
        self.selectedItemPublisher.send(index)
    }
    
    func handleFavoriteImageDeleted(with index: Int) {
        print("COUNT BEFORE = \(self.favoritesDisplayData.count)")
        self.favoritesDisplayData.remove(at: index)
        print("COUNT AFTER = \(self.favoritesDisplayData.count)")

        self.favoritesDisplayDataUpdated.send()
    }
}
