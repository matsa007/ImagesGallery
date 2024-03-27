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
    var favoriteImagesData = [FavoriteImageModel]()
    
    private let userDefaultsService: UserDefaultsServiceProtocol
    private let loader: ImagesGalleryLoadable
    private var cancellables: Set<AnyCancellable> = []
    
    private let imagesGalleryDisplayDataIsReadyForViewPublisher = PassthroughSubject<Void, Never>()
    var anyImagesGalleryDisplayDataIsReadyForViewPublisher: AnyPublisher<Void, Never> {
        self.imagesGalleryDisplayDataIsReadyForViewPublisher.eraseToAnyPublisher()
    }
    
    private let networkErrorAlertPublisher = PassthroughSubject<Error, Never>()
    var anyNetworkErrorAlertPublisher: AnyPublisher<Error, Never> {
        self.networkErrorAlertPublisher.eraseToAnyPublisher()
    }
    
    private let selectedItemDataIsReadyPublisher = PassthroughSubject<Int, Never>()
    var anySelectedItemDataIsReadyPublisher: AnyPublisher<Int, Never> {
        self.selectedItemDataIsReadyPublisher.eraseToAnyPublisher()
    }

    // MARK: - Initialization
    
    init(
        userDefaultsService: UserDefaultsServiceProtocol,
        loader: ImagesGalleryLoadable,
        startPage: StartPageIndex
    ) {
        self.userDefaultsService = userDefaultsService
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
    
    func stateOfImageIsFavoriteChanged(for imageDetails: FavoriteImageModel) {
        self.handleStateOfImageIsFavoriteChanged(
            for: imageDetails
        )
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
        self.updateImagesGalleryWithStoredState()
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
        self.selectedItemDataIsReadyPublisher.send(index)
    }
    
    func handleStateOfImageIsFavoriteChanged(for imageDetails: FavoriteImageModel) {
        let isFavorite = imageDetails.isFavorite
        
        switch isFavorite {
        case true:
            self.favoriteImagesData.append(
                FavoriteImageModel(
                    index: imageDetails.index,
                    id: imageDetails.id,
                    regularImageData: imageDetails.regularImageData,
                    isFavorite: imageDetails.isFavorite
                )
            )
            
            self.updateImagesGalleryWithNewState(for: imageDetails.id)
            
            self.userDefaultsService.saveToUserDefaults(
                self.favoriteImagesData,
                key: .favoriteImages
            )
            
        case false:
            self.favoriteImagesData.removeAll { imageData in
                imageData.id == imageDetails.id
            }
            
            self.updateImagesGalleryWithNewState(for: imageDetails.id)
            
            self.userDefaultsService.saveToUserDefaults(
                self.favoriteImagesData,
                key: .favoriteImages
            )
        }
    }
    
    func updateImagesGalleryWithNewState(for id: String) {
        let statusWillChangedForIndex = self.imagesGalleryDisplayData.firstIndex { imageData in
            imageData.id == id
        }
        
        guard let index = statusWillChangedForIndex else { return }
        self.imagesGalleryDisplayData[index].isFavorite = !self.imagesGalleryDisplayData[index].isFavorite
        self.imagesGalleryDisplayDataIsReadyForViewPublisher.send()
    }
    
    func updateImagesGalleryWithStoredState() {
        self.loadStoredFavoriteImagesData()
        self.favoriteImagesData.forEach {
            self.updateImagesGalleryWithNewState(
                for: $0.id
            )
        }
    }
    
    func loadStoredFavoriteImagesData() {
        let storedData = self.userDefaultsService.readFromUserDefaults(
            key: .favoriteImages
        )
        
        self.favoriteImagesData = storedData
    }
}
