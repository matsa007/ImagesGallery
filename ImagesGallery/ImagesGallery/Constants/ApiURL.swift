//
//  ApiURL.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 17.03.24.
//

import Foundation

enum ApiURL: String {
    case imagesApiURL = "https://api.unsplash.com/photos/"
}

enum ApiURLExtensions {
    static let page = "?page="
    static let itemsPerPage = "&per_page="
}

enum ResultsPerPage: Int {
    case maximum = 30
}

enum StartPageIndex: Int {
    case fromFirstPage = 1
}

enum URLRequestValues {
    static let clientID = "Client-ID "
}
