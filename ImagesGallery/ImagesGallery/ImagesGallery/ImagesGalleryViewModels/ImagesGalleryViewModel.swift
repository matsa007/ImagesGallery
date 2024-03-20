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
    
    let loader: ImagesGalleryLoadable
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
    
    private let selectedItemDataIsReadyPublisher = PassthroughSubject<(ImagesGalleryDisplayModel, Int), Never>()
    var anySelectedItemDataIsReadyPublisher: AnyPublisher<(ImagesGalleryDisplayModel, Int), Never> {
        self.selectedItemDataIsReadyPublisher.eraseToAnyPublisher()
    }

    // MARK: - Initialization
    
    init(
        loader: ImagesGalleryLoadable,
        startPage: StartPageIndex
    ) {
        self.loader = loader
        self.currentPage = startPage.rawValue
    }
    
    deinit {
        self.cancellables.forEach { $0.cancel() }
    }
    
    // MARK: - Data loading
    
    func readyForDisplay() {
        self.fetchImagesData(
            with: .maximum
        )
    }
    
    func scrolledToItemWithItemIndex(_ index: Int) {
        self.handleScrolledToItemWithItemIndex(index)
    }
    
    func collectionViewItemSelected(with index: Int) {
        self.handleCollectionViewItemSelected(for: index)
    }
}

// MARK: - Fetch images data

private extension ImagesGalleryViewModel {
    func fetchImagesData(with resultsPerPage: ResultsPerPage) {
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
        
        self.loader.requestImagesURLs(
            page: self.currentPage,
            pageQuantity: resultsPerPage.rawValue
        )
    }
}

// MARK: - Handlers and actions

extension ImagesGalleryViewModel {
    func handleDisplayData(for data: [ImagesGalleryDisplayModel]) {
        self.imagesGalleryDisplayData += data
        self.imagesGalleryDisplayDataIsReadyForViewPublisher.send()
    }
    
    func handleAlertForNetworkError(for error: Error) {
        self.networkErrorAlertPublisher.send(error)
    }
    
    func handleScrolledToItemWithItemIndex(_ index: Int) {
        let lastItemIndex = self.imagesGalleryDisplayData.count - 1
        
        if index == lastItemIndex {
            self.currentPage += 1
            
            self.fetchImagesData(
                with: .maximum
            )
        }
    }
    
    func handleCollectionViewItemSelected(for index: Int) {
        self.selectedItemDataIsReadyPublisher.send(
            (
                self.imagesGalleryDisplayData[index],
                index
            )
        )
    }
}
