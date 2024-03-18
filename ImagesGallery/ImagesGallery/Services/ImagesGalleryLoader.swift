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
                var initialImagesData = [InitialImagesGalleryDataModel]()
                
                let responseData: [PhotosModel] = try await NetworkManager.shared.requestData(
                    toEndPoint: helper.createPhotosApiURLForPage(
                        for: .imagesApiURL,
                        page: page,
                        pageQuantity: pageQuantity
                    ),
                    apiKey: .unsplashApiKey,
                    httpMethod: .get
                )
                
                responseData.forEach {
                    let imageURLs = $0.urls
                    
                    initialImagesData.append(
                        InitialImagesGalleryDataModel(
                            id: $0.id,
                            thumbImgURL: imageURLs.thumb
                        )
                    )
                }
                await self.requestImagesData(
                    for: initialImagesData
                )
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
    
    func requestImagesData(for initialImagesData: [InitialImagesGalleryDataModel]) async {
        await withTaskGroup(of: ImagesGalleryDisplayModel.self) { taskGroup in
            var imagesGalleryDisplayData = [ImagesGalleryDisplayModel]()
            
            initialImagesData.forEach { initialImageInfo in
                taskGroup.addTask {
                    var displayData = ImagesGalleryDisplayModel(
                        id: String(),
                        imageData: Data()
                    )
                    
                    do {
                        let responseData = try await NetworkManager.shared.requestImageData(
                            from: initialImageInfo.thumbImgURL,
                            httpMethod: .get
                        )
                        
                        displayData = ImagesGalleryDisplayModel(
                            id: initialImageInfo.id,
                            imageData: responseData
                        )
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
                    return displayData
                }
            }
            
            for await data in taskGroup {
                imagesGalleryDisplayData.append(data)
            }
        }
    }
}
