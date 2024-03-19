//
//  ImagesGalleryLoadable.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 18.03.24.
//

import Foundation
import Combine

protocol ImagesGalleryLoadable {
    var anyDisplayDataIsReadyForViewPublisher: AnyPublisher<[ImagesGalleryDisplayModel], Never> { get }
    
    func requestImagesURLs(page: Int, pageQuantity: Int)
    func requestImagesData(for initialImagesData: [InitialImagesGalleryDataModel]) async
}
