//
//  ImagesGalleryHelpeable.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 26.03.24.
//

import Foundation

protocol ImagesGalleryHelpeable {
    func createPhotosApiURLForPage(for url: ApiURL, page: Int, pageQuantity: Int) -> String
}
