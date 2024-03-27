//
//  DetailImageViewController.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 21.03.24.
//

import UIKit
import SnapKit
import Combine

final class DetailImageViewController: UIViewController {
    
    // MARK: - Parameters
    
    private let viewModel: DetailImageViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - GUI
    
    private lazy var detailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var addToFavoritesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(
            UIImage(systemName: ImageNames.heart.rawValue),
            for: .normal
        )
        return button
    }()
    
    private lazy var imageTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.font = FontSettings.detailImageTitleFont
        return label
    }()
    
    private lazy var imageDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.font = FontSettings.detailImageDescriptionFont
        return label
    }()
    
    private lazy var leftSwipeGestureRecognizer: UISwipeGestureRecognizer = {
        let recognizer = UISwipeGestureRecognizer()
        recognizer.direction = .left
        return recognizer
    }()
    
    private lazy var rightSwipeGestureRecognizer: UISwipeGestureRecognizer = {
        let recognizer = UISwipeGestureRecognizer()
        recognizer.direction = .right
        return recognizer
    }()
    
    // MARK: - Initialization
    
    init(viewModel: DetailImageViewModelProtocol) {
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
        self.viewModel.readyForDisplay()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setupLayout()
    }
}

// MARK: - Layout

private extension DetailImageViewController {
    func setupLayout() {
        self.setView()
        self.setSubViews()
        self.setConstraints()
    }
    
    func setView() {
        self.view.backgroundColor = ColorsSet.detailBackgroundColor
    }
    
    func setSubViews() {
        self.setNavBar()
        self.setSwipeGestureRecognizers()
        self.setFavoritesButton()
        self.addSubViews()
    }
    
    func setConstraints() {
        self.detailImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(Sizes.detailImageWidthCoeff)
            $0.height.equalToSuperview().multipliedBy(Sizes.detailImageViewHeightCoeff)
            $0.top.equalTo(
                self.navigationController?.navigationBar.snp.bottom
                ?? self.view.safeAreaLayoutGuide.snp.bottom
            ).offset(Spacing.regulardSpacing)
        }
        
        self.addToFavoritesButton.snp.makeConstraints {
            $0.height.equalToSuperview().dividedBy(15)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.detailImageView.snp.bottom)
                .offset(Spacing.minSpacing)
        }
        
        self.imageTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(Sizes.detailImageWidthCoeff)
            $0.top.equalTo(self.addToFavoritesButton.snp.bottom)
                .offset(Spacing.minSpacing)
        }
        
        self.imageDescriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(Sizes.detailImageWidthCoeff)
            $0.top.equalTo(self.imageTitleLabel.snp.bottom)
                .offset(Spacing.regulardSpacing)
        }
    }
}

// MARK: - Add subviews

private extension DetailImageViewController {
    func addSubViews() {
        self.view.addSubview(self.detailImageView)
        self.view.addSubview(self.addToFavoritesButton)
        self.view.addSubview(self.imageTitleLabel)
        self.view.addSubview(self.imageDescriptionLabel)
        self.detailImageView.addGestureRecognizer(self.leftSwipeGestureRecognizer)
        self.detailImageView.addGestureRecognizer(self.rightSwipeGestureRecognizer)
    }
}

// MARK: - Setters

private extension DetailImageViewController {
    func setNavBar() {
        self.navigationItem.title = Titles.detailImageTitle.rawValue
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: ColorsSet.navBarTitleColor
        ]
    }
    
    func setSwipeGestureRecognizers() {
        self.setLeftSwipeGestureRecognizer()
        self.setRightSwipeGestureRecognizer()
    }
    
    func setLeftSwipeGestureRecognizer() {
        self.leftSwipeGestureRecognizer.addTarget(
            self,
            action: #selector(self.didLeftSwipe)
        )
    }
    
    func setRightSwipeGestureRecognizer() {
        self.rightSwipeGestureRecognizer.addTarget(
            self,
            action: #selector(self.didRightSwipe)
        )
    }
    
    func setFavoritesButton() {
        self.setHeartButtonColor(
            for: self.viewModel.detailImageDisplayData.isFavorite
        )
        
        self.addToFavoritesButton.addTarget(
            self,
            action: #selector(self.addToFavoritesButtonTapped),
            for: .touchUpInside
        )
    }
    
    func setHeartButtonColor(for isFavorite: Bool) {
        self.addToFavoritesButton.tintColor = isFavorite
        ? ColorsSet.heartButtonFavorite
        : ColorsSet.heartButtonNotFavorite
    }
}

// MARK: - Set display data

private extension DetailImageViewController {
    func setDisplayData(imageData: Data, imageTitle: String, imageDescription: String) {
        self.detailImageView.image = UIImage(data: imageData)
        self.imageTitleLabel.text = imageTitle
        self.imageDescriptionLabel.text = imageDescription
    }
}

// MARK: - View Model binding

private extension DetailImageViewController {
    func binding() {
        self.bindOutput()
    }
    
    func bindOutput() {
        self.viewModel.anyDetailImageDisplayDataIsReadyForViewPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.detailImageDisplayDataIsReadyHandler()
            }
            .store(in: &self.cancellables)
        
        self.viewModel.anyNetworkErrorAlertPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self else { return }
                self.handleShowErrorWithAlert(for: error)
            }
            .store(in: &self.cancellables)
        
        self.viewModel.anyImageFavoriteStateIsChangedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isFavorite in
                guard let self else { return }
                self.handleImageIsFavoriteStateIsChanged(
                    on: isFavorite
                )
            }
            .store(in: &self.cancellables)
    }
}

// MARK: - Actions and handlers

private extension DetailImageViewController {
    func detailImageDisplayDataIsReadyHandler() {
        self.setDisplayData(
            imageData: self.viewModel.detailImageDisplayData.currentImageData,
            imageTitle: self.viewModel.detailImageDisplayData.currentImageTitle,
            imageDescription: self.viewModel.detailImageDisplayData.currentImageDescription
        )
    }
    
    func handleShowErrorWithAlert(for error: Error) {
        self.alertForError(
            for: error,
            with: .alertTitle,
            with: .alertButtonTitle
        )
    }
    
    func handleImageIsFavoriteStateIsChanged(on isFavorite: Bool) {
        self.setHeartButtonColor(
            for: isFavorite
        )
    }
    
    @objc func didLeftSwipe() {
        self.viewModel.swipedToLeftSide()
    }
    
    @objc func didRightSwipe() {
        self.viewModel.swipedToRightSide()
    }
    
    @objc func addToFavoritesButtonTapped() {
        self.viewModel.addToFavoritesButtonTapped()
    }
}
