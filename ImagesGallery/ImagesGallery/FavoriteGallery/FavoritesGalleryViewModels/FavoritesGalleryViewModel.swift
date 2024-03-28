//
//  FavoritesGalleryViewModel.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 29.03.24.
//

import Foundation

final class FavoritesGalleryViewModel: FavoritesGalleryViewModelProtocol {
    
    // MARK: - Parameters
    
    var favoritesDisplayData: [FavoritesGallerDisplayModel]
    
    // MARK: - Initialization
    
    init(favoritesDisplayData: [FavoriteImageModel]) {
        self.favoritesDisplayData = favoritesDisplayData.map {
            FavoritesGallerDisplayModel(
                id: $0.id,
                imageData: $0.regularImageData
            )
        }
    }
}
