//
//  DetailImageViewModelProtocol.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 21.03.24.
//

import Foundation

protocol DetailImageViewModelProtocol {    
    init(
        detailImageInitialData: DetailImageInitialModel,
        detailImageLoader: DetailImageLoadable
    )
    
    func readyForDisplay()
}
