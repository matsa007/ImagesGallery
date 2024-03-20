//
//  ImagesGalleryViewModelProtocol.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 18.03.24.
//

import Foundation
import Combine

protocol ImagesGalleryViewModelProtocol {
    var currentPage: Int { get set }
    var imagesGalleryDisplayData: [ImagesGalleryDisplayModel] { get set }
    var anyImagesGalleryDisplayDataIsReadyForViewPublisher: AnyPublisher<Void, Never> { get }
    var anyNetworkErrorAlertPublisher: AnyPublisher<Error, Never> { get }
    
    init(
        loader: ImagesGalleryLoadable,
        startPage: StartPageIndex
    )
    
    func readyForDisplay()
    func scrolledToItemWithItemIndex(_ index: Int)
}
