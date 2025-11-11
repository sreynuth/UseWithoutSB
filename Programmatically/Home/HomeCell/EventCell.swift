//
//  EventCell.swift
//  Programmatically
//
//  Created by Nin Sreynuth on 13/10/25.
//

import UIKit

class EventCell: UITableViewCell {

    let imageSlid = UIImageView()
    let contentUIView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func setupViews() {
        contentUIView.cornerAllRadius           = 12
        contentUIView.layer.masksToBounds       = true
        contentUIView.backgroundColor           = UIColor(hexString: "#D9D9D9")
        imageSlid.contentMode                   = .scaleAspectFill
        
        imageSlid.translatesAutoresizingMaskIntoConstraints = false
        contentUIView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(contentUIView)
        contentUIView.addSubview(imageSlid)
        
        NSLayoutConstraint.activate([
            // ContentUIView
            contentUIView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentUIView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            contentUIView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            contentUIView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            
            imageSlid.topAnchor.constraint(equalTo: contentUIView.topAnchor),
            imageSlid.leftAnchor.constraint(equalTo: contentUIView.leftAnchor),
            imageSlid.rightAnchor.constraint(equalTo: contentUIView.rightAnchor),
            imageSlid.bottomAnchor.constraint(equalTo: contentUIView.bottomAnchor)
        ])
    }
    
    func configure(items: HomeModel.MainList) {
        imageSlid.image = UIImage(named: items.imageList ?? "")
    }
}
