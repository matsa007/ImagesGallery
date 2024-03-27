//
//  ImagesGalleryViewController.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 17.03.24.
//

import UIKit
import SnapKit
import Combine

final class ImagesGalleryViewController: UIViewController {
    
    // MARK: - Parameters
    
    private let viewModel: ImagesGalleryViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - GUI
    
    private lazy var imagesGalleryCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let colView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        colView.delegate = self
        colView.dataSource = self
        return colView
    }()
    
    // MARK: - Initialization
    
    init(viewModel: ImagesGalleryViewModelProtocol) {
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
        self.viewModel.readyForDisplay()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        switch UIDevice.current.orientation {
        case .portrait, .unknown:
            self.setItemSizeParameters(
                itemsSpacing: .standartItemsSpacing,
                rowSpacing: .standartRowsSpacing,
                columnsQuantity: .threeColumnsQuantity
            )
            
        default:
            self.setItemSizeParameters(
                itemsSpacing: .standartItemsSpacing,
                rowSpacing: .standartRowsSpacing,
                columnsQuantity: .fourColumnsQuantity
            )
        }
        self.view.layoutIfNeeded()
    }
}

// MARK: - Layout

private extension ImagesGalleryViewController {
    func setupLayout() {
        self.setView()
        self.setSubViews()
        self.setConstraints()
    }
    
    func setView() {
        self.view.backgroundColor = ColorsSet.galleryBackgroundColor
    }
    
    func setSubViews() {
        self.setNavBar()
        self.setImagesGalleryCollection()
        self.addSubViews()
    }
    
    func setConstraints() {
        self.imagesGalleryCollection.snp.makeConstraints {
            $0.centerX.height.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.width.equalTo(self.view.snp.width).multipliedBy(Sizes.imagesGalleryCollectionWidthCoeff)
        }
    }
}

// MARK: - Add subviews

private extension ImagesGalleryViewController {
    func addSubViews() {
        self.view.addSubview(self.imagesGalleryCollection)
    }
}

// MARK: - Setters

private extension ImagesGalleryViewController {
    func setNavBar() {
        self.navigationItem.title = Titles.imagesGaleryBarTitle.rawValue
        self.navigationController?.navigationBar.barTintColor = ColorsSet.galleryBackgroundColor
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: ColorsSet.navBarTitleColor
        ]
    }
    
    func setImagesGalleryCollection() {
        self.imagesGalleryCollection.backgroundColor = ColorsSet.galleryBackgroundColor
        
        self.imagesGalleryCollection.register(
            ImagesGalleryCollectionViewCell.self,
            forCellWithReuseIdentifier: CellIdentificators.imagesGalleryCellIdentificator
        )
    }
    
    func setItemSizeParameters(
        itemsSpacing: CollectionViewItemsSpacing,
        rowSpacing: CollectionViewRowsSpacing,
        columnsQuantity: CollectionViewQuantity
    ) {
        if let layout = self.imagesGalleryCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            let minimumInteritemSpacing = itemsSpacing.rawValue
            layout.minimumInteritemSpacing = minimumInteritemSpacing
            
            let minimumLineSpacing = rowSpacing.rawValue
            layout.minimumLineSpacing = minimumLineSpacing
            
            let collectionWidth = self.imagesGalleryCollection.frame.width
            let totalSpacingWidth = CGFloat(columnsQuantity.rawValue - 1) * minimumInteritemSpacing
            let itemWidth = (collectionWidth - totalSpacingWidth) / CGFloat(columnsQuantity.rawValue)
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        }
    }
}

// MARK: - View Model binding

extension ImagesGalleryViewController {
    func binding() {
        self.bindInput()
        self.bindOutput()
    }
    
    func bindInput() {
        self.viewModel.anySelectedItemDataIsReadyPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                guard let self else { return }
                self.handleCollectionViewItemSelectedIndex(
                    index: index
                )
            }
            .store(in: &self.cancellables)
    }

    func bindOutput() {
        self.viewModel.anyImagesGalleryDisplayDataIsReadyForViewPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.imagesGalleryDisplayDataIsReadyHandler()
            }
            .store(in: &self.cancellables)
        
        self.viewModel.anyNetworkErrorAlertPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self else { return }
                self.handleShowErrorWithAlert(for: error)
            }
            .store(in: &self.cancellables)
    }
}

// MARK: - Actions and handlers

extension ImagesGalleryViewController {
    func imagesGalleryDisplayDataIsReadyHandler() {
        self.imagesGalleryCollection.reloadData()
    }
    
    func handleShowErrorWithAlert(for error: Error) {
        self.alertForError(
            for: error,
            with: .alertTitle,
            with: .alertButtonTitle
        )
    }
    
    func handleCollectionViewItemSelectedIndex(index: Int) {
        let vm = DetailImageViewModel(
            detailImageInitialData: DetailImageInitialModel(
                imagesGalleryDisplayData: self.viewModel.imagesGalleryDisplayData,
                selectedImageIndex: index
            ),
            detailImageLoader: DetailImageLoader(
                cacheService: CacheService(
                    cacheCountLimit: .twoHundred
                ),
                networkService: NetworkService(),
                helper: DetailImageHelper()
            )
        )
        
        let vc = DetailImageViewController(
            viewModel: vm
        )
        
        vm.anyImageFavoriteButtonTappedPublisher
            .sink { [weak self] favoritesData in
                guard let self else { return }
                self.handleFavoritesButtonTappedData(
                    favoritesData: favoritesData
                )
            }
            .store(in: &self.cancellables)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func handleFavoritesButtonTappedData(favoritesData: FavoriteImageModel) {
        self.viewModel.stateOfImageIsFavoriteChanged(
            for: favoritesData
        )
    }
}

// MARK: - UICollectionViewDataSource

extension ImagesGalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.imagesGalleryDisplayData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CellIdentificators.imagesGalleryCellIdentificator,
            for: indexPath
        ) as? ImagesGalleryCollectionViewCell else { return UICollectionViewCell() }
        
        let imageInfo = self.viewModel.imagesGalleryDisplayData[indexPath.item]
        
        cell.setCellDisplayData(
            for: imageInfo
        )
        
        return cell
    }
}

 // MARK: - UICollectionViewDelegate

extension ImagesGalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.viewModel.scrolledToItemWithItemIndex(indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.collectionViewItemSelected(with: indexPath.item)
    }
}
