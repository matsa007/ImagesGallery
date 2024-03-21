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
        
        self.loader.requestDetailImageURLs(
            for: detailImageInitialData.imageIDs[currentIndex]
        )
    }
}

// MARK: - Handlers and actions

private extension DetailImageViewModel {
    func handleDisplayData(for displayData: DetailImageDisplayModel) {
        self.detailImageDisplayData = displayData
    }
}
