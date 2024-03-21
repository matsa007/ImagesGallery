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
        imageView.backgroundColor = .green
        return imageView
    }()
    
    private lazy var addToFavoritesButton: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()
    
    private lazy var imageTitleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .red
        return label
    }()
    
    private lazy var imageDescriptionLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .orange
        return label
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
        self.addSubViews()
    }
    
    func setConstraints() {
        self.detailImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(
                self.navigationController?.navigationBar.snp.bottom
                ?? self.view.safeAreaLayoutGuide.snp.bottom
            ).offset(Spacing.regulardSpacing)
        }
        
        self.imageTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.detailImageView.snp.bottom)
                .offset(Spacing.regulardSpacing)
        }
        
        self.imageDescriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.imageTitleLabel.snp.bottom)
                .offset(Spacing.regulardSpacing)
        }
    }
}

// MARK: - Add subviews

private extension DetailImageViewController {
    func addSubViews() {
        self.view.addSubview(self.detailImageView)
        self.view.addSubview(self.imageTitleLabel)
        self.view.addSubview(self.imageDescriptionLabel)
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
    }
}

// MARK: - Actions and handlers

private extension DetailImageViewController {
    func detailImageDisplayDataIsReadyHandler() {
        
    }
    
    func handleShowErrorWithAlert(for error: Error) {
        self.alertForError(
            for: error,
            with: .alertTitle,
            with: .alertButtonTitle
        )
    }
}
