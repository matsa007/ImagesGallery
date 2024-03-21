//
//  DetailImageViewModelProtocol.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 21.03.24.
//

import Foundation
import Combine

protocol DetailImageViewModelProtocol {    
    var detailImageDisplayData: DetailImageDisplayModel { get }
    var anyDetailImageDisplayDataIsReadyForViewPublisher: AnyPublisher<Void, Never> { get }

    init(
        detailImageInitialData: DetailImageInitialModel,
        detailImageLoader: DetailImageLoadable
    )
    
    func readyForDisplay()
}
