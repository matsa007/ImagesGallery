//
//  ImagesGalleryCollectionViewCell.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 17.03.24.
//

import UIKit

final class ImagesGalleryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - GUI

    private lazy var thumbImageView: UIImageView = {
        let imView = UIImageView()
        return imView
    }()
    
    private lazy var likedImageIndicatorView: UIImageView = {
        let imView = UIImageView()
        imView.image = UIImage(
            systemName: ImageNames.heart.rawValue
        )
        imView.tintColor = ColorsSet.heartIndicatorColor
        return imView
    }()
    
    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.thumbImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubViews()
        self.setConstraints()
    }
    
    // MARK: - Add subviews

    private func addSubViews() {
        self.contentView.addSubview(self.thumbImageView)
        self.contentView.addSubview(self.likedImageIndicatorView)
    }
    
    // MARK: - Layout
    
    private func setLikedImageIndicatorView(for isFavorite: Bool) {
        self.likedImageIndicatorView.isHidden = isFavorite
        ? false
        : true
    }
    
    // MARK: - Constraints
    
    private func setConstraints() {
        self.thumbImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.likedImageIndicatorView.snp.makeConstraints {
            $0.width.height.equalToSuperview().multipliedBy(Sizes.heartHeightCoeff)
            $0.right.bottom.equalToSuperview().inset(Spacing.heartIndicatorSpacing)
        }
    }
}

// MARK: - Set cell display data

extension ImagesGalleryCollectionViewCell {
    func setCellDisplayData(for imageInfo: ImagesGalleryDisplayModel) {
        let image = UIImage(
            data: imageInfo.imageData
        )
        self.thumbImageView.image = image
        self.setLikedImageIndicatorView(
            for: imageInfo.isFavorite
        )
    }
}
