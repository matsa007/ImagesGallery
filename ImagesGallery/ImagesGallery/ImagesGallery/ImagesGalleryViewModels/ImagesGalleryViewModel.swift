//
//  ImagesGalleryViewModel.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 18.03.24.
//

import Foundation
import Combine

final class ImagesGalleryViewModel: ImagesGalleryViewModelProtocol {
    
    // MARK: - Parameters
    
    var currentPage: Int
    var imagesGalleryDisplayData = [ImagesGalleryDisplayModel]()
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let imagesGalleryDisplayDataIsReadyForViewPublisher = PassthroughSubject<Void, Never>()
    var anyImagesGalleryDisplayDataIsReadyForViewPublisher: AnyPublisher<Void, Never> {
        self.imagesGalleryDisplayDataIsReadyForViewPublisher.eraseToAnyPublisher()
    }
    
    private let networkErrorAlertPublisher = PassthroughSubject<Error, Never>()
    var anyNetworkErrorAlertPublisher: AnyPublisher<Error, Never> {
        self.networkErrorAlertPublisher.eraseToAnyPublisher()
    }

    // MARK: - Initialization
    
    init(startPage: StartPageIndex) {
        self.currentPage = startPage.rawValue
    }
    
    deinit {
        self.cancellables.forEach { $0.cancel() }
    }
    
    // MARK: - Data loading
    
    func readyForDisplay() {
        self.fetchImagesData(
            page: self.currentPage,
            resultsPerPage: .maximum
        )
    }
}

// MARK: - Fetch images data

private extension ImagesGalleryViewModel {
    func fetchImagesData(page: Int, resultsPerPage: ResultsPerPage) {
        let loader = ImagesGalleryLoader()
        
        loader.anyDisplayDataIsReadyForViewPublisher
            .sink { [weak self] data in
                guard let self else { return }
                self.handleDisplayData(for: data)
            }
            .store(in: &self.cancellables)
        
        loader.anyNetworkErrorMessagePublisher
            .sink { [weak self] error in
                guard let self else { return }
                self.handleAlertForNetworkError(for: error)
            }
            .store(in: &self.cancellables)
        
        loader.requestImagesURLs(
            page: page,
            pageQuantity: resultsPerPage.rawValue
        )
    }
}

// MARK: - Handlers and actions

extension ImagesGalleryViewModel {
    func handleDisplayData(for data: [ImagesGalleryDisplayModel]) {
        self.imagesGalleryDisplayData = data
        self.imagesGalleryDisplayDataIsReadyForViewPublisher.send()
    }
    
    func handleAlertForNetworkError(for error: Error) {
        self.networkErrorAlertPublisher.send(error)
    }
}
