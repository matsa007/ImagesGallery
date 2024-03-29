//
//  FullScreenFavoriteViewController.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 29.03.24.
//

import UIKit

final class FullScreenFavoriteViewController: UIViewController {
    
    // MARK: - Parameters
    
    private lazy var favoriteImageView: UIImageView = {
        let imView = UIImageView()
        imView.contentMode = .scaleAspectFit
        return imView
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .yellow
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setupLayout()
    }
}

// MARK: - Layout

private extension FullScreenFavoriteViewController {
    func setupLayout() {
        self.setView(backgroundColor: ColorsSet.favoriteFullScreenBackgroundColor)
        self.setSubViews()
        self.addSubViews()
        self.setConstraints()
    }
}

// MARK: - Add subviews

private extension FullScreenFavoriteViewController {
    func addSubViews() {
        self.view.addSubview(self.favoriteImageView)
    }
}

// MARK: - Setters

private extension FullScreenFavoriteViewController {
    func setView(backgroundColor: UIColor) {
        self.view.backgroundColor = backgroundColor
    }
    
    func setSubViews() {
        self.setNavBar(
            title: .favoriteImageBarTitle,
            tintColor: ColorsSet.favoriteBackgroundColor,
            titleColor: ColorsSet.navBarTitleColor, 
            buttonColor: ColorsSet.trashButtonColor
        )
        
        self.setFavoriteImageView()
    }
    
    func setNavBar(title: Titles, tintColor: UIColor, titleColor: UIColor, buttonColor: UIColor) {
        self.navigationItem.title = title.rawValue
        self.navigationController?.navigationBar.barTintColor = tintColor
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: titleColor
        ]
                
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .trash,
            target: self,
            action: #selector(self.deleteButtonTapped)
        )
        
        self.navigationItem.rightBarButtonItem?.tintColor = buttonColor
    }
    
    func setFavoriteImageView() {}
}

// MARK: - Constraints

private extension FullScreenFavoriteViewController {
    func setConstraints() {
        self.favoriteImageView.snp.makeConstraints {
            $0.centerX.bottom.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.width.equalTo(self.view.snp.width).multipliedBy(Sizes.favoritesGalleryCollectionWidthCoeff)
        }
    }
}

// MARK: - Actions and handlers

private extension FullScreenFavoriteViewController {
    @objc func deleteButtonTapped() {
        print("deleteButtonTapped")
    }
}
