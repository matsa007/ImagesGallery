//
//  ImagesGalleryLoadable.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 18.03.24.
//

import Foundation

protocol ImagesGalleryLoadable {
    func requestImagesURLs(page: Int, pageQuantity: Int)
    func requestImagesData(for initialImagesData: [InitialImagesGalleryDataModel]) async
}
