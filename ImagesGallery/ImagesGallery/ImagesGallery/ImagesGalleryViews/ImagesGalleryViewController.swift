//
//  ImagesGalleryViewController.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 17.03.24.
//

import UIKit
import SnapKit

final class ImagesGalleryViewController: UIViewController {
    
    // MARK: - GUI
    
    private lazy var imagesGalleryCollection: UICollectionView = {
        let colView = UICollectionView()
        return colView
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ColorsSet.favoritesBackgroundColor
    }
}
