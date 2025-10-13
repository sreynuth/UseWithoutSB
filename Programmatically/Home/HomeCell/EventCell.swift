//
//  EventCell.swift
//  Programmatically
//
//  Created by Nin Sreynuth on 13/10/25.
//

import UIKit

class EventCell: UITableViewCell {
    
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let iconLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func setupViews() {
        contentView.backgroundColor = UIColor.systemGray6
        contentView.layer.cornerRadius = 12
        
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        subtitleLabel.font = UIFont.systemFont(ofSize: 16)
        subtitleLabel.numberOfLines = 0
        iconLabel.font = UIFont.systemFont(ofSize: 28)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(iconLabel)
        
        NSLayoutConstraint.activate([
            iconLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            iconLabel.widthAnchor.constraint(equalToConstant: 40),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            subtitleLabel.rightAnchor.constraint(equalTo: iconLabel.leftAnchor, constant: -8)
        ])
    }
    
    func configure(title: String, subtitle: String, icon: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        iconLabel.text = icon
    }
}
