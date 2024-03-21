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
    
    private let displayDataIsReadyForViewPublisher = PassthroughSubject<DetailImageDisplayModel, Never>()
    var anyDisplayDataIsReadyForViewPublisher: AnyPublisher<DetailImageDisplayModel, Never> {
        self.displayDataIsReadyForViewPublisher.eraseToAnyPublisher()
    }
    
    // MARK: - Request data

    func requestDetailImageURLs(for currentImageId: String) {
        let helper = DetailImageHelper()
        
        Task {
            do {
                let responseData: DetailImageModel = try await NetworkManager.shared.requestData(
                    toEndPoint: helper.createDetailImageApiURL(
                        for: ApiURL.imagesApiURL,
                        with: currentImageId
                    ),
                    clientID: ApiKeys.unsplashApiKey.getClientID(),
                    httpMethod: .get
                )
                
                let detailImageDisplayData = DetailImageDisplayModel(
                    currentImageData: Data(),
                    currentImageTitle: responseData.slug,
                    currentImageDescription: responseData.altDescription
                )
                                
                await self.requestDetailImageData(
                    from: responseData.urls.regular,
                    initialData: detailImageDisplayData
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
    
    func requestDetailImageData(from imageUrl: String, initialData: DetailImageDisplayModel) async {
        Task {
            do {
                let responseData = try await NetworkManager.shared.requestImageData(
                    from: imageUrl,
                    httpMethod: .get
                )
                
                let detailImageDisplayData = DetailImageDisplayModel(
                    currentImageData: responseData,
                    currentImageTitle: initialData.currentImageTitle,
                    currentImageDescription: initialData.currentImageDescription
                )
                
                dump(detailImageDisplayData)
                
                self.displayDataIsReadyForViewPublisher.send(
                    detailImageDisplayData
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
}
