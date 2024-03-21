//
//  DetailImageViewController.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 21.03.24.
//

import UIKit

final class DetailImageViewController: UIViewController {
    
    // MARK: - Parameters
    
    private let viewModel: DetailImageViewModelProtocol
    
    // MARK: - GUI
    
    private lazy var detailImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .yellow
        return stackView
    }()
    
    private lazy var detailImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var addToFavoritesButton: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()
    
    private lazy var imageTitleLabel: UILabel = {
       let label = UILabel()
        return label
    }()
    
    private lazy var imageDescriptionLabel: UILabel = {
       let label = UILabel()
        return label
    }()
    
    // MARK: - Initialization
    
    init(viewModel: DetailImageViewModelProtocol) {
        self.viewModel = viewModel
        
        dump(self.viewModel.detailImageInitialData)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ColorsSet.detailBackgroundColor
    }
}
