//
//  CacheServiceProtocol.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 20.03.24.
//

import Foundation

protocol CacheServiceProtocol {
    func saveToCache(_ data: Data, forId id: String)
    func readFromCache(forId id: String) -> Data?
}
