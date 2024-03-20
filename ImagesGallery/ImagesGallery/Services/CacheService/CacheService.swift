//
//  CacheService.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 20.03.24.
//

import Foundation

final class CacheService {
    
    // MARK: - Parameters
    static var shared = CacheService(
        cacheCountLimit: .oneHundred
    )
    
    private let cache = NSCache<NSString, NSData>()
    private let cacheCountLimit: Int
    
    // MARK: - Initialization
    
    private init(cacheCountLimit: CasheLimits) {
        self.cacheCountLimit = cacheCountLimit.rawValue
        self.setCacheService()
    }
}

// MARK: - Cache service methods

extension CacheService: CacheServiceProtocol {
    func saveToCache(_ data: Data, forId id: String) {
        let nsData = NSData(data: data)
        self.cache.setObject(nsData, forKey: id as NSString)
    }
    
    func readFromCache(forId id: String) -> Data? {
        if let nsData = self.cache.object(forKey: id as NSString) {
            return Data(referencing: nsData)
        }
        return nil
    }
}

// MARK: - Cashe service settings

private extension CacheService {
    func setCacheService() {
        self.cache.countLimit = self.cacheCountLimit
    }
}
