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
    
    private let imageFavoriteButtonTappedPublisher = PassthroughSubject<DetailImageFavoriteModel, Never>()
    var anyImageFavoriteButtonTappedPublisher: AnyPublisher<DetailImageFavoriteModel, Never> {
        self.imageFavoriteButtonTappedPublisher.eraseToAnyPublisher()
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
            currentImageTitle: String(),
            currentImageDescription: String()
        )
    }
    
    deinit {
        self.cancellables.forEach { $0.cancel() }
    }
    
    // MARK: - Data loading
    
    func readyForDisplay() {
        self.fetchCurrentImageData()
    }
    
    func swipedToLeftSide() {
        self.handleLeftSwipe()
    }
    
    func swipedToRightSide() {
        self.handleRightSwipe()
    }
    
    func addToFavoritesButtonTapped() {
        self.favoritesButtonTappedHandler()
    }
}

// MARK: - Fetch detail image data

private extension DetailImageViewModel {
    func fetchCurrentImageData() {
        let currentIndex = self.detailImageInitialData.selectedImageIndex
        
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
            for: self.detailImageInitialData.imageIDs[currentIndex]
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
    
    func handleLeftSwipe() {
        self.detailImageInitialData.selectedImageIndex += 1
        self.fetchCurrentImageData()
    }
    
    func handleRightSwipe() {
        self.detailImageInitialData.selectedImageIndex -= 1
        self.fetchCurrentImageData()
    }
    
    func favoritesButtonTappedHandler() {
        let index = self.detailImageInitialData.selectedImageIndex
        self.imageFavoriteButtonTappedPublisher.send(
            DetailImageFavoriteModel(
                index: index,
                id: self.detailImageInitialData.imageIDs[index],
                regularImageData: self.detailImageDisplayData.currentImageData
            )
        )
    }
}
