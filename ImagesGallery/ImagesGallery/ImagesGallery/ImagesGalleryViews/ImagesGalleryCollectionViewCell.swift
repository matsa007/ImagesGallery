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
    
    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.thumbImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubViews()
        self.setCellViews()
        self.setConstraints()
    }
    
    // MARK: - Add subviews

    private func addSubViews() {
        self.contentView.addSubview(self.thumbImageView)
    }
    
    // MARK: - Layout
    
    private func setCellViews() {
        self.setCell()
    }
    
    private func setCell() {
        self.contentView.backgroundColor = .blue
    }
    
    // MARK: - Constraints
    
    private func setConstraints() {
        self.thumbImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
    }
}
