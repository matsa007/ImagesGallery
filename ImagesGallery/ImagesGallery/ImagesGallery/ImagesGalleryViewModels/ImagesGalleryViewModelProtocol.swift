//
//  ImagesGalleryViewModelProtocol.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 18.03.24.
//

import Foundation

protocol ImagesGalleryViewModelProtocol {
    var currentPage: Int { get set }
    
    init(startPage: StartPageIndex)
    
    func readyForDisplay()
}
