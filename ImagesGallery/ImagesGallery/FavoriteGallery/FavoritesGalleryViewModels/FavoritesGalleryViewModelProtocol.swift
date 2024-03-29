//
//  FavoritesGalleryViewModelProtocol.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 29.03.24.
//

import Foundation
import Combine

protocol FavoritesGalleryViewModelProtocol {
    var favoritesDisplayData: [FavoritesGallerDisplayModel] { get set }
    var anySelectedItemPublisher: AnyPublisher<Int, Never> { get }
    
    init(favoritesDisplayData: [FavoriteImageModel])
    
    func collectionViewItemSelected(with index: Int)
}
