//
//  ImagesGalleryLoader.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 18.03.24.
//

import Foundation
import Combine

final class ImagesGalleryLoader: ImagesGalleryLoadable {
    
    // MARK: - Parameters
    
    private var cancellables: Set<AnyCancellable> = []
    private let cacheService: CacheServiceProtocol
    private let networkService: NetworkServiceProtocol
    
    private let displayDataIsReadyForViewPublisher = PassthroughSubject<[ImagesGalleryDisplayModel], Never>()
    var anyDisplayDataIsReadyForViewPublisher: AnyPublisher<[ImagesGalleryDisplayModel], Never> {
        self.displayDataIsReadyForViewPublisher.eraseToAnyPublisher()
    }
    
    private let networkErrorMessagePublisher = PassthroughSubject<Error, Never>()
    var anyNetworkErrorMessagePublisher: AnyPublisher<Error, Never> {
        self.networkErrorMessagePublisher.eraseToAnyPublisher()
    }
    
    // MARK: - Initialization
    
    init(cacheService: CacheServiceProtocol, networkService: NetworkServiceProtocol) {
        self.cacheService = cacheService
        self.networkService = networkService
    }
    
    deinit {
        self.cancellables.forEach { $0.cancel() }
    }
    
    // MARK: - Request data
    
    func requestImagesURLs(page: Int, pageQuantity: Int) {
        let helper = ImagesGalleryHelper()
        
        Task {
            do {
                var initialImagesData = [InitialImagesGalleryDataModel]()
                
                let responseData: [PhotosModel] = try await self.networkService.requestData(
                    toEndPoint: helper.createPhotosApiURLForPage(
                        for: .imagesApiURL,
                        page: page,
                        pageQuantity: pageQuantity
                    ),
                    clientID: ApiKeys.unsplashApiKey.getClientID(),
                    httpMethod: .get
                )
                
                guard !responseData.isEmpty else { return }
                
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
                    self.networkErrorMessagePublisher.send(error)
                case NetworkError.invalidResponse:
                    self.networkErrorMessagePublisher.send(error)
                case NetworkError.statusCode(Int.min...Int.max):
                    self.networkErrorMessagePublisher.send(error)
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
                        
                        if let cachedData = self.checkChache(
                            for: initialImageInfo.id
                        ) {
                            displayData = ImagesGalleryDisplayModel(
                                id: initialImageInfo.id,
                                imageData: cachedData
                            )
                        } else {
                            let responseData = try await self.networkService.requestImageData(
                                from: initialImageInfo.thumbImgURL,
                                httpMethod: .get
                            )
                            
                            displayData = ImagesGalleryDisplayModel(
                                id: initialImageInfo.id,
                                imageData: responseData
                            )
                            
                            self.saveCache(
                                responseData,
                                for: initialImageInfo.id
                            )
                        }
                    }
                    
                    catch let error {
                        switch error {
                        case NetworkError.invalidURL:
                            self.networkErrorMessagePublisher.send(error)
                        case NetworkError.invalidResponse:
                            self.networkErrorMessagePublisher.send(error)
                        case NetworkError.statusCode(Int.min...Int.max):
                            self.networkErrorMessagePublisher.send(error)
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
            
            self.displayDataIsReadyForViewPublisher.send(imagesGalleryDisplayData)
        }
    }
}

// MARK: - Cache service checker

private extension ImagesGalleryLoader {
    func checkChache(for id: String) -> Data? {
        if let data = self.cacheService.readFromCache(forId: id) {
            return data
        } else {
            return nil
        }
    }
    
    func saveCache(_ data: Data, for id: String) {
        self.cacheService.saveToCache(data, forId: id)
    }
}
