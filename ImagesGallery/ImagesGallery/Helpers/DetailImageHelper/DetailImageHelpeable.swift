//
//  DetailImageHelpeable.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 26.03.24.
//

import Foundation

protocol DetailImageHelpeable {
    func createDetailImageApiURL(for url: ApiURL, with id: String) -> String
    func createDetailCacheId(for id: String, with prefix: CacheIdPrefix) -> String
    func updateDetailImageTitle(
        for initialTitle: String,
        currentSeparator: StringSeparators,
        newSeparator: StringSeparators
    ) -> String
    func updateDetailImageDescription(for initialDescription: String) -> String
}
