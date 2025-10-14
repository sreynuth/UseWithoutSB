//
//  PaymentOptionCell.swift
//  Programmatically
//
//  Created by Nin Sreynuth on 13/10/25.
//

import UIKit

class PaymentOptionCell: UITableViewCell {
    
    let contentUIView    = UIView()
    let profileView      = UIView()

    private lazy var profileImg: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints    = false
        return image
    }()
    
    private lazy var titleLbl: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return title
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        title.textColor = .gray
        return title
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("결제", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 6
        
        button.translatesAutoresizingMaskIntoConstraints     = false
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLbl, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .fill
        stack.distribution = .fill
        
        stack.translatesAutoresizingMaskIntoConstraints     = false
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func setupViews() {
        
        contentUIView.translatesAutoresizingMaskIntoConstraints = false
        profileView.translatesAutoresizingMaskIntoConstraints   = false
        
        contentView.addSubview(contentUIView)
        contentUIView.addSubview(profileView)
        profileView.addSubview(profileImg)
        contentUIView.addSubview(stackView)
        contentUIView.addSubview(payButton)
        
        NSLayoutConstraint.activate([
            // ContentUIView
            contentUIView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentUIView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            contentUIView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            contentUIView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Profile View
            profileView.centerYAnchor.constraint(equalTo: contentUIView.centerYAnchor),
            profileView.leftAnchor.constraint(equalTo: contentUIView.leftAnchor, constant: 24),
            profileView.widthAnchor.constraint(equalToConstant: 45),
            profileView.heightAnchor.constraint(equalToConstant: 45),
            
            // Image View
            profileImg.centerXAnchor.constraint(equalTo: profileView.centerXAnchor),
            profileImg.centerYAnchor.constraint(equalTo: profileView.centerYAnchor),
            profileImg.widthAnchor.constraint(equalToConstant: 21),
            profileImg.heightAnchor.constraint(equalToConstant: 21),
            
            // Text View
            stackView.topAnchor.constraint(equalTo: profileView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: profileView.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: profileView.rightAnchor, constant: 20),
            
            // Pay Button View
            payButton.centerYAnchor.constraint(equalTo: contentUIView.centerYAnchor),
            payButton.rightAnchor.constraint(equalTo: contentUIView.rightAnchor, constant: -16),
            payButton.widthAnchor.constraint(equalToConstant: 60),
            payButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileView.layer.cornerRadius = profileView.frame.height / 2
        profileView.clipsToBounds = true
    }
    
    func checkUIView(indexPath: Int, countItem: Int) {
        contentUIView.backgroundColor           = UIColor(hexString: "#FFFFFF")
        contentUIView.layer.shadowRadius        = 12
        contentUIView.layer.masksToBounds       = false
        contentUIView.layer.applySketchShadow(color: UIColor(hexString: "#000000") ?? .black , alpha: 0.08, x: 0, y: 6, blur: 16, spread: 0)
        
        if countItem == 1 {
            contentUIView.cornerAllRadius         = 12
        } else {
            if indexPath == 0 {
                contentUIView.cornerTopRadius           = 12
            }else if indexPath == countItem - 1 {
                contentUIView.cornerBottomRadius        = 12
            }else{
                contentUIView.cornerAllRadius           = 0
                contentUIView.shadowOffset              = CGSize(width: 0, height: 0)
            }
        }
    }
    
    func configure(items: HomeModel.BankList, indexPath: Int, countItem: Int) {
        checkUIView(indexPath: indexPath, countItem: countItem)
        titleLbl.text = items.currency
        subtitleLabel.text = "\(items.amount ?? 0)"
        payButton.setTitle("Pay", for: .normal)
        profileImg.image = UIImage(named: "BiplePay")
    }
    
}
