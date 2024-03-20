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
    
    // MARK: - Initialization
    
    init(detailImageInitialData: DetailImageInitialModel) {
        self.detailImageInitialData = detailImageInitialData
    }
}
