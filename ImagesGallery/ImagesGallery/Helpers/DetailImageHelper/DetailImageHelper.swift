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
    
    func createDetailCacheId(for id: String, with prefix: CacheIdPrefix) -> String {
        prefix.rawValue + id
    }
    
    func updateDetailImageTitle(
        for initialTitle: String,
        currentSeparator: StringSeparators,
        newSeparator: StringSeparators
    ) -> String {
        let titleComponents = initialTitle.components(separatedBy: currentSeparator.rawValue)
        let updatedTitle = titleComponents.dropLast()
            .map { $0.uppercased() }
            .joined(separator: newSeparator.rawValue)
        return updatedTitle
    }
    
    func updateDetailImageDescription(for initialDescription: String) -> String {
        guard let firstLetter = initialDescription.first else { return DefaultMessages.defaultImageDescription}
        let updatedDescription = firstLetter.uppercased() + initialDescription.dropFirst()
        return updatedDescription
    }
}
