//
//  DetailImageHelper.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 21.03.24.
//

import Foundation

final class DetailImageHelper {
    func createDetailImageApiURL(for url: ApiURL, with id: String) -> String {
        url.rawValue + id
    }
}
