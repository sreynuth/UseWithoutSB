//
//  BannerCollectionViewCell.swift
//  Programmatically
//
//  Created by Nin Sreynuth on 14/10/25.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {
    
    private let bannerImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(bannerImageView)
        
        NSLayoutConstraint.activate([
            bannerImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bannerImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bannerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func configure(items: HomeModel.BannerList) {
        bannerImageView.image = UIImage(named: items.imageList ?? "")
    }
    
    func configureEventList(items: HomeModel.EventList) {
        bannerImageView.image = UIImage(named: items.imageList ?? "")
    }
    
}
