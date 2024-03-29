//
//  FavoritesTableViewCell.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 28.03.24.
//

import UIKit

final class FavoritesCollectionViewCell: UICollectionViewCell {
    
    // MARK: - GUI

    private lazy var favoriteImageView: UIImageView = {
        let imView = UIImageView()
        imView.contentMode = .scaleAspectFit
        return imView
    }()
    
    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.favoriteImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setupLayout()
    }
}

// MARK: - Layout

private extension FavoritesCollectionViewCell {
    func setupLayout() {
        self.addSubViews()
        self.setConstraints()
    }
}

// MARK: - Add subviews

private extension FavoritesCollectionViewCell {
    func addSubViews() {
        self.contentView.addSubview(self.favoriteImageView)
    }
}

// MARK: - Constraints

private extension FavoritesCollectionViewCell {
    private func setConstraints() {
        self.favoriteImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - Set cell display data

extension FavoritesCollectionViewCell {
    func setCellDisplayData(for imageInfo: FavoritesGallerDisplayModel) {
        let image = UIImage(
            data: imageInfo.imageData
        )
        self.favoriteImageView.image = image
    }
}
