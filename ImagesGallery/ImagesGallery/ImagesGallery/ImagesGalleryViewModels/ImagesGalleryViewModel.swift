//
//  ImagesGalleryViewModel.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 18.03.24.
//

import Foundation

final class ImagesGalleryViewModel: ImagesGalleryViewModelProtocol {
    
    // MARK: - Parameters
    
    var currentPage: Int
    
    // MARK: - Initialization
    
    init(startPage: StartPageIndex) {
        self.currentPage = startPage.rawValue
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
        
        loader.requestImagesURLs(
            page: page,
            pageQuantity: resultsPerPage.rawValue
        )
    }
}
