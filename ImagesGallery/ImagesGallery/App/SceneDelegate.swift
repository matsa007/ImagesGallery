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
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = ColorsSet.tabBarBackgroundColor
        tabBarController.tabBar.tintColor = ColorsSet.tabBarTintColor
        tabBarController.tabBar.isTranslucent = false
        return tabBarController
    }()
    
    private let imagesGalleryVC = UINavigationController(
        rootViewController: ImagesGalleryViewController(
            viewModel: ImagesGalleryViewModel()
        )
    )
    private let favoriteImagesVC = UINavigationController(
        rootViewController: FavoriteImagesViewController()
    )
    
    // MARK: - Set window scene

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        self.addViewControllers()
        
        self.setTabBarController(
            galleryTitle: .imagesGaleryBarTitle,
            favoritesTitle: .favoriteImagesBarTitle,
            galleryImgName: .imagesGaleryImageName,
            favoritesImgName: .favoriteImagesImageName
        )
        
        window?.rootViewController = self.tabBarVC
        window?.makeKeyAndVisible()
    }
    
    // MARK: - Set tab bar controller
    
    private func setTabBarController(
        galleryTitle: Titles,
        favoritesTitle: Titles,
        galleryImgName: ImageNames,
        favoritesImgName: ImageNames
    ) {
        self.imagesGalleryVC.tabBarItem = UITabBarItem(
            title: galleryTitle.rawValue,
            image: UIImage(systemName: galleryImgName.rawValue),
            selectedImage: nil
        )
        
        self.favoriteImagesVC.tabBarItem = UITabBarItem(
            title: favoritesTitle.rawValue,
            image: UIImage(systemName: favoritesImgName.rawValue),
            selectedImage: nil
        )
                
        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: FontSettings.tabBarItemFont ?? UIFont.systemFont(ofSize: 12)
        ]
        
        self.imagesGalleryVC.tabBarItem.setTitleTextAttributes(
            titleTextAttributes,
            for: .normal
        )
        
        self.favoriteImagesVC.tabBarItem.setTitleTextAttributes(
            titleTextAttributes,
            for: .normal
        )

    }
    
    // MARK: - Add view controllers to tab bar
    
    private func addViewControllers() {
        self.tabBarVC.setViewControllers([
            self.imagesGalleryVC,
            self.favoriteImagesVC
        ], animated: true)
    }
}
