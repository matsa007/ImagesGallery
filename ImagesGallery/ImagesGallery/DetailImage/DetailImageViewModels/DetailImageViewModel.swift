//
//  DetailImageViewModel.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 21.03.24.
//

import Foundation

final class DetailImageViewModel: DetailImageViewModelProtocol {
    
    // MARK: - Parameters
    
    var detailImageInitialData: DetailImageInitialModel
    var detailImageDisplayData: DetailImageDisplayModel
    
    // MARK: - Initialization
    
    init(detailImageInitialData: DetailImageInitialModel) {
        self.detailImageInitialData = detailImageInitialData
        self.detailImageDisplayData = DetailImageDisplayModel(
            currentImageData: Data(),
            currentImageTitle: nil,
            currentImageDescription: nil
        )
    }
}
