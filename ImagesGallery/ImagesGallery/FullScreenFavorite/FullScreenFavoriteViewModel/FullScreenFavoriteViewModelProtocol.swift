//
//  FullScreenFavoriteViewModelProtocol.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 29.03.24.
//

import Foundation
import Combine

protocol FullScreenFavoriteViewModelProtocol {
    var favoriteImageData: FullScreenFavoriteDisplayModel { get }
    var anyDeleteButtonTappedPublisher: AnyPublisher<Void, Never> { get }
    
    func deleteButtonTapped()
}
