//
//  SceneDelegate.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 17.03.24.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Parameters

    var window: UIWindow?
    
    private let imagesGalleryVC = UINavigationController(
        rootViewController: ImagesGalleryViewController(
            viewModel: ImagesGalleryViewModel(
                loader: ImagesGalleryLoader(
                    cacheService: CacheService(
                        cacheCountLimit: .twoHundred
                    )
                ),
                startPage: .fromZero
            )
        )
    )
    
    // MARK: - Set window scene

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = self.imagesGalleryVC
        window?.makeKeyAndVisible()
    }
}
