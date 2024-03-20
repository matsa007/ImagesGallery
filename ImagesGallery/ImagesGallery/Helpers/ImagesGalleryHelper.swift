//
//  ImagesGalleryHelper.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 18.03.24.
//

import Foundation

final class ImagesGalleryHelper {
    func createPhotosApiURLForPage(for url: ApiURL, page: Int, pageQuantity: Int) -> String {
        url.rawValue + ApiURLExtensions.page + String(page) + ApiURLExtensions.itemsPerPage + String(pageQuantity)
    }
    
    func getClientID(for apiKey: ApiKeys) -> String {
        URLRequestValues.clientID + apiKey.rawValue
    }
}
