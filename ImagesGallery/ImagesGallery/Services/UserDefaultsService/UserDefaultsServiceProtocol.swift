//
//  UserDefaultsServiceProtocol.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 27.03.24.
//

import Foundation

protocol UserDefaultsServiceProtocol {
    func saveToUserDefaults(_ favoriteImageData: [FavoriteImageModel], key: UserDefaultsKeys)
    func readFromUserDefaults(key: UserDefaultsKeys) -> [FavoriteImageModel]
}
