//
//  DetailImageViewModelProtocol.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 21.03.24.
//

import Foundation
import Combine

protocol DetailImageViewModelProtocol {    
    var detailImageDisplayData: DetailImageDisplayModel { get }
    var anyDetailImageDisplayDataIsReadyForViewPublisher: AnyPublisher<Void, Never> { get }
    var anyNetworkErrorAlertPublisher: AnyPublisher<Error, Never> { get }
    var anyImageFavoriteButtonTappedPublisher: AnyPublisher<FavoriteImageModel, Never> { get }
    var anyImageFavoriteStateIsChangedPublisher: AnyPublisher<Bool, Never> { get }

    init(
        detailImageInitialData: DetailImageInitialModel,
        detailImageLoader: DetailImageLoadable
    )
    
    func readyForDisplay()
    func swipedToLeftSide()
    func swipedToRightSide()
    func addToFavoritesButtonTapped()
}
