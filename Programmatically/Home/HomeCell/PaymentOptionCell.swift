//
//  PaymentOptionCell.swift
//  Programmatically
//
//  Created by Nin Sreynuth on 13/10/25.
//

import UIKit

class PaymentOptionCell: UITableViewCell {
    
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let payButton = UIButton(type: .system)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func setupViews() {
        contentView.backgroundColor = UIColor.systemGray6
        contentView.layer.cornerRadius = 12
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = .gray
        payButton.setTitle("결제", for: .normal)
        payButton.backgroundColor = UIColor.systemBlue
        payButton.tintColor = .white
        payButton.layer.cornerRadius = 6
        payButton.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(payButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            payButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            payButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            payButton.widthAnchor.constraint(equalToConstant: 60),
            payButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func configure(title: String, subtitle: String, buttonTitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        payButton.setTitle(buttonTitle, for: .normal)
    }
    
}
