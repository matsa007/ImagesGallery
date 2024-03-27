//
//  DetailImageLoadable.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 21.03.24.
//

import Foundation
import Combine

protocol DetailImageLoadable {
    var anyDisplayDataIsReadyForViewPublisher: AnyPublisher<DetailImageDisplayModel, Never> { get }
    var anyNetworkErrorMessagePublisher: AnyPublisher<Error, Never> { get }

    func requestDetailImageURLs(for currentImageId: String, with isFavorite: Bool)
    func requestDetailImageData(from imageUrl: String, initialData: DetailImageDisplayModel, cacheId: String) async
}
