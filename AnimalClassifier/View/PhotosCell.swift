//
//  PhotosCell.swift
//  AnimalClassifier
//
//  Created by yauheni prakapenka on 16.11.2019.
//  Copyright © 2019 yauheni prakapenka. All rights reserved.
//

import UIKit
import SDWebImage

class PhotosCell: UICollectionViewCell {
    
    // MARK: - Input
    
    static let reuseId = "PhotosCell"
    
    // MARK: - Subview
    
    private let checkmark: UIImageView = {
        let image = #imageLiteral(resourceName: "check")
        let imageView = UIImageView(image: image)
        imageView.alpha = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    // MARK: - View lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photoImageView.image = nil
    }
    
    override var isSelected: Bool {
        didSet {
            updateSelectedState()
        }
    }
    
    var unsplashPhoto: Unsplashphoto! {
        didSet {
            let photoUrl = unsplashPhoto.urls["regular"]
            guard let imageURL = photoUrl, let url = URL(string: imageURL) else { return }
            photoImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        addSubview(checkmark)
        
        makeConstraints()
        updateSelectedState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func updateSelectedState() {
        photoImageView.alpha = isSelected ? 0.7 : 1
        checkmark.alpha = isSelected ? 1 : 0
    }
}

// MARK: - Layout

private extension PhotosCell {
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: self.topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            checkmark.centerXAnchor.constraint(equalTo: photoImageView.centerXAnchor),
            checkmark.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor),
            checkmark.widthAnchor.constraint(equalToConstant: 60),
            checkmark.heightAnchor.constraint(equalTo: checkmark.widthAnchor)
        ])
    }
}
