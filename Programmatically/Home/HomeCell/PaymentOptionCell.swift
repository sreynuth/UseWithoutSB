//
//  PaymentOptionCell.swift
//  Programmatically
//
//  Created by Nin Sreynuth on 13/10/25.
//

import UIKit

class PaymentOptionCell: UITableViewCell {
    
    let profileView     = UIView()
    let titleLabel      = UILabel()
    let subtitleLabel   = UILabel()
    let payButton       = UIButton(type: .system)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func setupViews(indexPath: Int, countItem: Int) {
        contentView.backgroundColor = UIColor.systemGray6
        if countItem == 1 {
            contentView.layer.maskedCorners     = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            contentView.layer.cornerRadius = 12
        } else {
            if indexPath == 0 {
                contentView.layer.maskedCorners     = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                contentView.layer.cornerRadius      = 12
            }else if indexPath == countItem - 1 {
                contentView.layer.maskedCorners     = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                contentView.layer.cornerRadius      = 12
            }else{
                contentView.layer.cornerRadius      = 0
            }
        }
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = .gray
        payButton.setTitle("결제", for: .normal)
        payButton.backgroundColor = UIColor.systemBlue
        payButton.tintColor = .white
        payButton.layer.cornerRadius = 6
        profileView.backgroundColor = UIColor.red
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        payButton.translatesAutoresizingMaskIntoConstraints = false
        profileView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(profileView)
        contentView.addSubview(stackView)
        contentView.addSubview(payButton)
        
        NSLayoutConstraint.activate([
            profileView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 24),
            profileView.widthAnchor.constraint(equalToConstant: 45),
            profileView.heightAnchor.constraint(equalToConstant: 45),
            
            stackView.topAnchor.constraint(equalTo: profileView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: profileView.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: profileView.rightAnchor, constant: 20),
            
            payButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            payButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            payButton.widthAnchor.constraint(equalToConstant: 60),
            payButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileView.layer.cornerRadius = profileView.frame.height / 2
        profileView.clipsToBounds = true
    }
    
    func configure(items: HomeModel.BankList, indexPath: Int, countItem: Int) {
        setupViews(indexPath: indexPath, countItem: countItem)
        titleLabel.text = items.currency
        subtitleLabel.text = "\(items.amount ?? 0)"
        payButton.setTitle("Pay", for: .normal)
    }
    
}
