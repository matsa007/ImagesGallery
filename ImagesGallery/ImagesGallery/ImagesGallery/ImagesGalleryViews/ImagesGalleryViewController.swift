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
        colView.backgroundColor = .yellow
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
}

// MARK: - Layout

private extension ImagesGalleryViewController {
    func setupLayout() {
        self.setView()
        self.setSubViews()
        self.setConstraints()
    }
    
    func setView() {
        self.view.backgroundColor = ColorsSet.favoritesBackgroundColor
    }
    
    func setSubViews() {
        self.view.addSubview(self.imagesGalleryCollection)
        self.setNavBar()
        self.setImagesGalleryCollection()
    }
    
    func setConstraints() {
        self.imagesGalleryCollection.snp.makeConstraints {
            $0.centerX.height.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.width.equalTo(self.view.frame.width * Sizes.imagesGalleryCollectionWidthCoeff)
        }
    }
}

// MARK: - Setters

private extension ImagesGalleryViewController {
    func setNavBar() {
        self.navigationItem.title = Titles.imagesGaleryBarTitle.rawValue
    }
    
    func setImagesGalleryCollection() {
        self.imagesGalleryCollection.register(
            ImagesGalleryCollectionViewCell.self,
            forCellWithReuseIdentifier: CellIdentificators.imagesGalleryCellIdentificator
        )
    }
}

// MARK: - View Model binding

extension ImagesGalleryViewController {
    func binding() {
        self.bindOutput()
    }

    func bindOutput() {
        self.viewModel.anyImagesGalleryDisplayDataIsReadyForViewPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.imagesGalleryDisplayDataIsReadyHandler()
            }
            .store(in: &self.cancellables)
    }
}

// MARK: - Actions and handlers

extension ImagesGalleryViewController {
    func imagesGalleryDisplayDataIsReadyHandler() {
        self.imagesGalleryCollection.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension ImagesGalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CellIdentificators.imagesGalleryCellIdentificator,
            for: indexPath
        ) as? ImagesGalleryCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ImagesGalleryViewController: UICollectionViewDelegate {}
