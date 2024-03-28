//
//  FavoritesGalleryViewController.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 28.03.24.
//

import UIKit

final class FavoritesGalleryViewController: UIViewController {
    
    // MARK: - Parameters
    
    private let viewModel: FavoritesGalleryViewModelProtocol
    
    // MARK: - GUI
    
    private lazy var favoritesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let colView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return colView
    }()
    
    // MARK: - Initialization
    
    init(viewModel: FavoritesGalleryViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setupLayout()
    }
}

// MARK: - Layout

private extension FavoritesGalleryViewController {
    func setupLayout() {
        self.setView(backgroundColor: ColorsSet.galleryBackgroundColor)
        self.setSubViews()
        self.addSubViews()
        self.setConstraints()
    }
}

// MARK: - Add subviews

private extension FavoritesGalleryViewController {
    func addSubViews() {
        self.view.addSubview(self.favoritesCollectionView)
    }
}

// MARK: - Setters

private extension FavoritesGalleryViewController {
    func setView(backgroundColor: UIColor) {
        self.view.backgroundColor = backgroundColor
    }
    
    func setSubViews() {
        self.setNavBar(
            title: .favoritesGalleryBarTitle,
            tintColor: ColorsSet.favoriteBackgroundColor,
            titleColor: ColorsSet.navBarTitleColor
        )
        
        self.setFavoritesTableView(
            backgroundColor: ColorsSet.favoriteBackgroundColor,
            cellId: .favoritesGalleryCellId
        )
    }
    
    func setNavBar(title: Titles, tintColor: UIColor, titleColor: UIColor) {
        self.navigationItem.title = title.rawValue
        self.navigationController?.navigationBar.barTintColor = tintColor
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: titleColor
        ]
    }
    
    func setFavoritesTableView(backgroundColor: UIColor, cellId: CellIdentificators) {
        self.favoritesCollectionView.backgroundColor = backgroundColor
        self.favoritesCollectionView.register(
            FavoritesCollectionViewCell.self,
            forCellWithReuseIdentifier: cellId.rawValue
        )
    }
}

// MARK: - Constraints

private extension FavoritesGalleryViewController {
    func setConstraints() {
        self.favoritesCollectionView.snp.makeConstraints {
            $0.centerX.height.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.width.equalTo(self.view.snp.width).multipliedBy(Sizes.favoritesGalleryCollectionWidthCoeff)
        }
    }
}
