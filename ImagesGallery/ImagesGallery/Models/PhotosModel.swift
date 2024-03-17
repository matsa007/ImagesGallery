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
    let width, height: Int
    let urls: Urls
}

// MARK: - Urls

struct Urls: Codable {
    let full, regular, small, thumb: String
}
