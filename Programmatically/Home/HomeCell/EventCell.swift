//
//  EventCell.swift
//  Programmatically
//
//  Created by Nin Sreynuth on 13/10/25.
//

import UIKit

class EventCell: UITableViewCell {

    let imageSlid = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func setupViews() {
        contentView.backgroundColor = UIColor.systemGray6
        contentView.layer.cornerRadius = 12
        
        imageSlid.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageSlid)
        
        NSLayoutConstraint.activate([
            imageSlid.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageSlid.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageSlid.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageSlid.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(items: HomeModel.MainList) {
        imageSlid.image = UIImage(named: items.imageList ?? "")
    }
}
