//
//  EventCell.swift
//  Programmatically
//
//  Created by Nin Sreynuth on 13/10/25.
//

import UIKit

class EventCell: UITableViewCell {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical // horizontal scrolling
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    private let imageSlid: UIImageView = {
        let view = UIImageView()
        view.contentMode                   = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var items: [HomeModel.EventList] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func setupViews() {
        contentView.addSubview(collectionView)
        collectionView.addSubview(imageSlid)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: "BannerCollectionViewCell")
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            
            imageSlid.topAnchor.constraint(equalTo: collectionView.topAnchor),
            imageSlid.leftAnchor.constraint(equalTo: collectionView.leftAnchor),
            imageSlid.rightAnchor.constraint(equalTo: collectionView.rightAnchor),
            imageSlid.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
        ])
    }
}

extension EventCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell", for: indexPath) as! BannerCollectionViewCell
        let item = items[indexPath.item]
        cell.configureEventList(items: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let wCell = UIScreen.main.bounds.width - 40
        let aspectRatio: CGFloat = (126/335)
        let hCell = wCell * aspectRatio
        return CGSize(width: wCell, height: hCell)
    }
}
