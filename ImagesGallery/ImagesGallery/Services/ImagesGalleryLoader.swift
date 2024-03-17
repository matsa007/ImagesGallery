//
//  ImagesGalleryLoader.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 18.03.24.
//

import Foundation

final class ImagesGalleryLoader: ImagesGalleryLoadable {
    
    // MARK: - Request data
    
    func requestImagesURLs(page: Int, pageQuantity: Int) {
        let helper = ImagesGalleryHelper()
        
        Task {
            do {
                let responseData: [PhotosModel] = try await NetworkManager.shared.requestData(
                    toEndPoint: helper.createPhotosApiURLForPage(
                        for: .imagesApiURL,
                        page: page,
                        pageQuantity: pageQuantity
                    ),
                    apiKey: .unsplashApiKey,
                    httpMethod: .get
                )
                dump(responseData)
            }
            
            catch let error {
                switch error {
                case NetworkError.invalidURL:
                    print(error)
                case NetworkError.invalidResponse:
                    print(error)
                case NetworkError.statusCode(Int.min...Int.max):
                    print(error)
                default:
                    break
                }
            }
        }
    }
}
