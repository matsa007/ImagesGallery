//
//  DetailImageLoader.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 21.03.24.
//

import Foundation
import Combine

final class DetailImageLoader: DetailImageLoadable {
    
    // MARK: - Parameters
    
    private var cancellables: Set<AnyCancellable> = []
    private let cacheService: CacheServiceProtocol
    private let networkService: NetworkServiceProtocol
    private let helper: DetailImageHelpeable

    private let displayDataIsReadyForViewPublisher = PassthroughSubject<DetailImageDisplayModel, Never>()
    var anyDisplayDataIsReadyForViewPublisher: AnyPublisher<DetailImageDisplayModel, Never> {
        self.displayDataIsReadyForViewPublisher.eraseToAnyPublisher()
    }
    
    private let networkErrorMessagePublisher = PassthroughSubject<Error, Never>()
    var anyNetworkErrorMessagePublisher: AnyPublisher<Error, Never> {
        self.networkErrorMessagePublisher.eraseToAnyPublisher()
    }
    
    // MARK: - Initialization
    
    init(
        cacheService: CacheServiceProtocol,
        networkService: NetworkServiceProtocol,
        helper: DetailImageHelpeable
    ) {
        self.cacheService = cacheService
        self.networkService = networkService
        self.helper = helper
    }
    
    deinit {
        self.cancellables.forEach { $0.cancel() }
    }
    
    // MARK: - Request data

    func requestDetailImageURLs(for currentImageId: String) {
        Task {
            do {
                let responseData: DetailImageModel = try await self.networkService.requestData(
                    toEndPoint: self.helper.createDetailImageApiURL(
                        for: ApiURL.imagesApiURL,
                        with: currentImageId
                    ),
                    clientID: ApiKeys.unsplashApiKey.getClientID(),
                    httpMethod: .get
                )
                
                let initialImageTitle = responseData.slug ?? DefaultMessages.defaultImageTitle
                
                let initialImageDescription = responseData.description
                ?? responseData.altDescription
                ?? DefaultMessages.defaultImageDescription
                
                let updatedImageTitle = self.helper.updateDetailImageTitle(
                    for: initialImageTitle,
                    currentSeparator: .dash,
                    newSeparator: .space
                )
                
                let updatedImageDescription = self.helper.updateDetailImageDescription(
                    for: initialImageDescription
                )
                
                if let cachedData = self.checkChache(
                    for: self.helper.createDetailCacheId(
                        for: currentImageId,
                        with: .detailCacheId
                    )
                ) {
                    let detailImageDisplayData = DetailImageDisplayModel(
                        currentImageData: cachedData,
                        currentImageTitle: updatedImageTitle,
                        currentImageDescription: updatedImageDescription
                    )
                    self.displayDataIsReadyForViewPublisher.send(detailImageDisplayData)
                } else {
                    let detailImageDisplayData = DetailImageDisplayModel(
                        currentImageData: Data(),
                        currentImageTitle: updatedImageTitle,
                        currentImageDescription: updatedImageDescription
                    )
                                    
                    await self.requestDetailImageData(
                        from: responseData.urls.regular,
                        initialData: detailImageDisplayData, 
                        cacheId: self.helper.createDetailCacheId(
                            for: currentImageId,
                            with: .detailCacheId
                        )
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
        }
    }
    
    func requestDetailImageData(from imageUrl: String, initialData: DetailImageDisplayModel, cacheId: String) async {
        Task {
            do {
                let responseData = try await self.networkService.requestImageData(
                    from: imageUrl,
                    httpMethod: .get
                )
                
                let detailImageDisplayData = DetailImageDisplayModel(
                    currentImageData: responseData,
                    currentImageTitle: initialData.currentImageTitle,
                    currentImageDescription: initialData.currentImageDescription
                )
                                
                self.displayDataIsReadyForViewPublisher.send(
                    detailImageDisplayData
                )
                
                self.saveCache(
                    responseData,
                    for: cacheId
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
}

// MARK: - Cache service checker

private extension DetailImageLoader {
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
