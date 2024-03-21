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
    
    func requestDetailImageURLs(for currentImageId: String)
    func requestDetailImageData(from imageUrl: String, initialData: DetailImageDisplayModel) async
}