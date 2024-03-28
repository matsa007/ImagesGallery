//
//  ImagesGalleryViewModelProtocol.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 18.03.24.
//

import Foundation
import Combine

protocol ImagesGalleryViewModelProtocol {
    var imagesGalleryDisplayData: [ImagesGalleryDisplayModel] { get set }
    var anyImagesGalleryDisplayDataIsReadyForViewPublisher: AnyPublisher<Void, Never> { get }
    var anyNetworkErrorAlertPublisher: AnyPublisher<Error, Never> { get }
    var anySelectedItemDataIsReadyPublisher: AnyPublisher<Int, Never> { get }
    var anyFavoritesListButtonTappedPublisher: AnyPublisher<Void, Never> { get }
    
    init(
        userDefaultsService: UserDefaultsServiceProtocol,
        loader: ImagesGalleryLoadable,
        startPage: StartPageIndex
    )
    
    func readyForDisplay()
    func scrolledToItemWithItemIndex(_ index: Int)
    func collectionViewItemSelected(with index: Int)
    func stateOfImageIsFavoriteChanged(for imageDetails: FavoriteImageModel)
    func favoritesListButtonTapped()
}
