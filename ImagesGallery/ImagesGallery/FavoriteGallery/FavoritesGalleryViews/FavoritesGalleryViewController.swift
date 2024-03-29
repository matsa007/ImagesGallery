//
//  FavoritesGalleryViewController.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 28.03.24.
//

import UIKit
import Combine

final class FavoritesGalleryViewController: UIViewController {
    
    // MARK: - Parameters
    
    private let viewModel: FavoritesGalleryViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - GUI
    
    private lazy var favoritesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let colView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        colView.dataSource = self
        colView.delegate = self
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
    
    deinit {
        self.cancellables.forEach { $0.cancel() }
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.binding()
        self.setupLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setItemSizeParameters(rowSpacing: .standartRowsSpacing, imageHeightCoeff: Sizes.imageHeightCoeff)
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
    
    func setItemSizeParameters(rowSpacing: CollectionViewRowsSpacing, imageHeightCoeff: CGFloat) {
        if let layout = self.favoritesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let minimumLineSpacing = rowSpacing.rawValue
            layout.minimumLineSpacing = minimumLineSpacing
            
            let itemWidth = self.favoritesCollectionView.frame.width
            let itemHeight = itemWidth * imageHeightCoeff
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        }
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

// MARK: - View Model binding

private extension FavoritesGalleryViewController {
    func binding() {
        self.bindInput()
    }
    
    func bindInput() {
        self.viewModel.anySelectedItemPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                guard let self else { return }
                self.handleCollectionViewItemSelectedIndex(index)
            }
            .store(in: &self.cancellables)
    }
}

// MARK: - Actions and handlers

extension FavoritesGalleryViewController {
    func handleCollectionViewItemSelectedIndex(_ index: Int) {
        let vc = FullScreenFavoriteViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension FavoritesGalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.favoritesDisplayData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CellIdentificators.favoritesGalleryCellId.rawValue,
            for: indexPath
        ) as? FavoritesCollectionViewCell else { return UICollectionViewCell() }
        
        cell.setCellDisplayData(
            for: self.viewModel.favoritesDisplayData[indexPath.item]
        )
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension FavoritesGalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.collectionViewItemSelected(with: indexPath.item)
    }
}
