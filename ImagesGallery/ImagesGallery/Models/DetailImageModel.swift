//
//  DetailImageModel.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 21.03.24.
//

import Foundation

// MARK: - Detail image JSON response decoding model

struct DetailImageModel: Codable {
    let id: String
    let slug: String?
    let urls: DetailImageURLs
    let description: String?
    let altDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case id, slug, urls, description
        case altDescription = "alt_description"
    } 
}

// MARK: - Detail image URL's

struct DetailImageURLs: Codable {
    let full, regular, small: String
}
