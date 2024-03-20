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
        
        self.view.backgroundColor = .yellow
    }
}
