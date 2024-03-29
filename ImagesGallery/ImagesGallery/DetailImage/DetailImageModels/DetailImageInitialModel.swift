//
//  DetailImageInitialModel.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 21.03.24.
//

import Foundation

struct DetailImageInitialModel {
    var initialImagesInfo: [InitialImageInfo]
    var selectedImageIndex: Int
    
    init(imagesGalleryDisplayData: [ImagesGalleryDisplayModel], selectedImageIndex: Int) {
        self.initialImagesInfo = imagesGalleryDisplayData.map {
            InitialImageInfo(
                imageId: $0.id,
                isFavorite: $0.isFavorite
            )
        }
        self.selectedImageIndex = selectedImageIndex
    }
    
    struct InitialImageInfo {
        let imageId: String
        var isFavorite: Bool
    }
}
