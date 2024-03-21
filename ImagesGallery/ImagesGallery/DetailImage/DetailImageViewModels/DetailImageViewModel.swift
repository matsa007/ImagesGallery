//
//  DetailImageViewModel.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 21.03.24.
//

import Foundation
import Combine

final class DetailImageViewModel: DetailImageViewModelProtocol {
    
    // MARK: - Parameters
    
    private let loader: DetailImageLoadable
    private var detailImageInitialData: DetailImageInitialModel
    var detailImageDisplayData: DetailImageDisplayModel
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let detailImageDisplayDataIsReadyForViewPublisher = PassthroughSubject<Void, Never>()
    var anyDetailImageDisplayDataIsReadyForViewPublisher: AnyPublisher<Void, Never> {
        self.detailImageDisplayDataIsReadyForViewPublisher.eraseToAnyPublisher()
    }
    
    private let networkErrorAlertPublisher = PassthroughSubject<Error, Never>()
    var anyNetworkErrorAlertPublisher: AnyPublisher<Error, Never> {
        self.networkErrorAlertPublisher.eraseToAnyPublisher()
    }


    // MARK: - Initialization
    
    init(
        detailImageInitialData: DetailImageInitialModel,
        detailImageLoader: DetailImageLoadable
    ) {
        self.detailImageInitialData = detailImageInitialData
        self.loader = detailImageLoader
        self.detailImageDisplayData = DetailImageDisplayModel(
            currentImageData: Data(),
            currentImageTitle: nil,
            currentImageDescription: nil
        )
    }
    
    deinit {
        self.cancellables.forEach { $0.cancel() }
    }
    
    // MARK: - Data loading
    
    func readyForDisplay() {
        self.fetchCurrentImageData()
    }
}

private extension DetailImageViewModel {
    func fetchCurrentImageData() {
        let currentIndex = detailImageInitialData.selectedImageIndex
        
        self.loader.anyDisplayDataIsReadyForViewPublisher
            .sink { [weak self] data in
                guard let self else { return }
                self.handleDisplayData(for: data)
            }
            .store(in: &self.cancellables)
        
        self.loader.anyNetworkErrorMessagePublisher
            .sink { [weak self] error in
                guard let self else { return }
                self.handleAlertForNetworkError(for: error)
            }
            .store(in: &self.cancellables)
        
        self.loader.requestDetailImageURLs(
            for: detailImageInitialData.imageIDs[currentIndex]
        )
    }
}

// MARK: - Handlers and actions

private extension DetailImageViewModel {
    func handleDisplayData(for displayData: DetailImageDisplayModel) {
        self.detailImageDisplayData = displayData
        self.detailImageDisplayDataIsReadyForViewPublisher.send()
    }
    
    func handleAlertForNetworkError(for error: Error) {
        self.networkErrorAlertPublisher.send(error)
    }
}
