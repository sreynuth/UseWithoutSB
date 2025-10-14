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
        contentUIView.layer.shadowRadius        = 12
        contentUIView.cornerAllRadius           = 12
        contentUIView.layer.applySketchShadow(color: UIColor(hexString: "#000000") ?? .black , alpha: 0.08, x: 0, y: 6, blur: 16, spread: 0)
        
        imageSlid.translatesAutoresizingMaskIntoConstraints = false
        contentUIView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(contentUIView)
        contentUIView.addSubview(imageSlid)
        
        NSLayoutConstraint.activate([
            // ContentUIView
            contentUIView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentUIView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            contentUIView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            contentUIView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 20),
            
            imageSlid.topAnchor.constraint(equalTo: contentUIView.topAnchor),
            imageSlid.leadingAnchor.constraint(equalTo: contentUIView.leadingAnchor),
            imageSlid.trailingAnchor.constraint(equalTo: contentUIView.trailingAnchor),
            imageSlid.bottomAnchor.constraint(equalTo: contentUIView.bottomAnchor)
        ])
    }
    
    func configure(items: HomeModel.MainList) {
        imageSlid.image = UIImage(named: items.imageList ?? "")
    }
}
