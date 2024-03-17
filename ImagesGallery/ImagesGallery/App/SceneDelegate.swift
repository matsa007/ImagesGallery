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
    private lazy var tabBarVC: UITabBarController = {
        let vc = UITabBarController()
        vc.tabBar.isTranslucent = true
        return vc
    }()
    
    private let imagesGalleryVC = UINavigationController(
        rootViewController: ImagesGalleryViewController()
    )
    private let favoriteImagesVC = UINavigationController(
        rootViewController: FavoriteImagesViewController()
    )
    
    // MARK: - Set window scene

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        self.addViewControllers()
        window?.rootViewController = self.tabBarVC
        window?.makeKeyAndVisible()
    }
    
    // MARK: - Add view controllers
    
    private func addViewControllers() {
        self.tabBarVC.setViewControllers([
            self.imagesGalleryVC,
            self.favoriteImagesVC
        ], animated: true)
    }
}
