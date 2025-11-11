//
//  MainTitleCell.swift
//  Programmatically
//
//  Created by Nin Sreynuth on 16/10/25.
//

import UIKit

class MainTitleCell: UITableViewCell {
    let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupUI() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .black
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 11)
        ])
    }
    
    func configure(with text: String) {
        titleLabel.text = text
    }
}
