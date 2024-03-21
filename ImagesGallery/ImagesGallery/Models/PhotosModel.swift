//
//  PhotosModel.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 17.03.24.
//

import Foundation

// MARK: - Photos JSON response decoding model

struct PhotosModel: Codable {
    let id: String
    let urls: URLs
}

// MARK: - URL's

struct URLs: Codable {
    let thumb: String
}
