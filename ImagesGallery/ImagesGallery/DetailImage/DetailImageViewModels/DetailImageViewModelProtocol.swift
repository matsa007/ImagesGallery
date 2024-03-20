//
//  DetailImageViewModelProtocol.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 21.03.24.
//

import Foundation

protocol DetailImageViewModelProtocol {
    var detailImageInitialData: DetailImageInitialModel { get set }
    
    init(detailImageInitialData: DetailImageInitialModel)
}
