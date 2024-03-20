//
//  DetailImageInitialModel.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 21.03.24.
//

import Foundation

struct DetailImageInitialModel {
    let imageIDs: [String]
    let selectedImageIndex: Int
    
    init(imagesGalleryDisplayData: [ImagesGalleryDisplayModel], selectedImageIndex: Int) {
        self.imageIDs = imagesGalleryDisplayData.map { $0.id }
        self.selectedImageIndex = selectedImageIndex
    }
}
