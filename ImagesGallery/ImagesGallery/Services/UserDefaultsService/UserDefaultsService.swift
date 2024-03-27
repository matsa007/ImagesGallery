//
//  UserDefaultsService.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 27.03.24.
//

import Foundation

struct UserDefaultsService: UserDefaultsServiceProtocol {
    private let defaults = UserDefaults.standard
    
    func saveToUserDefaults(_ favoriteImageData: [FavoriteImageModel], key: UserDefaultsKeys) {
        let encoder = JSONEncoder()
        
        if let data = try? encoder.encode(favoriteImageData) {
            self.defaults.set(
                data,
                forKey: key.rawValue
            )
        }
    }
    
    func readFromUserDefaults(key: UserDefaultsKeys) -> [FavoriteImageModel] {
        if let data = self.defaults.data(forKey: key.rawValue) {
            let decoder = JSONDecoder()
            
            if let favoriteImageData = try? decoder.decode([FavoriteImageModel].self, from: data) {
                return favoriteImageData
            }
        }
        return []
    }
}
