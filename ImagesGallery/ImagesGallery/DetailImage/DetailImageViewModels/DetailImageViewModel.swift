//
//  DetailImageViewModel.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 21.03.24.
//

import Foundation

final class DetailImageViewModel: DetailImageViewModelProtocol {
    var currentImageIndex: Int
    
    init(selectedItemIndex: Int) {
        self.currentImageIndex = selectedItemIndex
    }
}
