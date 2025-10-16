//
//  PaymentOptionCell.swift
//  Programmatically
//
//  Created by Nin Sreynuth on 13/10/25.
//

import UIKit

class PaymentOptionCell: UITableViewCell {
    
    // MARK: - Public
    var indexPath       : Int?
    var countItem       : Int?
    
    // MARK: - Views
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
        stack.alignment = .leading
        stack.distribution = .fill
        
        stack.translatesAutoresizingMaskIntoConstraints     = false
        return stack
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Layout
    func setupViews() {
        
        contentUIView.translatesAutoresizingMaskIntoConstraints = false
        profileView.translatesAutoresizingMaskIntoConstraints   = false
        
        contentView.addSubview(contentUIView)
        contentUIView.addSubview(profileView)
        profileView.addSubview(profileImg)
        contentUIView.addSubview(stackView)
        contentUIView.addSubview(payButton)
        
        // card inset inside cell (gives visible gap between rows)
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
        
        contentUIView.backgroundColor           = UIColor(hexString: "#FFFFFF")
        contentUIView.layer.shadowRadius        = 12
        contentUIView.layer.masksToBounds       = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // circular profile
        profileView.layer.cornerRadius = profileView.frame.height / 2
        profileView.backgroundColor = UIColor(red: 0.18, green: 0.49, blue: 0.98, alpha: 1)
        profileView.clipsToBounds = true

        checkUIView()
    }
    
    // Check UI shadow
    func checkUIView() {
        if self.countItem == 1 {
            contentUIView.cornerAllRadius         = 12
            contentUIView.addShadow(position: .all)
        } else {
            if self.indexPath == 0 { // First row
                contentUIView.cornerTopRadius           = 12
                contentUIView.addShadow(position: .topLeftRight)
                
            }else if self.indexPath == (self.countItem ?? 0) - 1 { // Last row
                contentUIView.cornerBottomRadius        = 12
                contentUIView.addShadow(position: .bottomLeftRight)
                
            }else{ // Center row
                contentUIView.cornerAllRadius           = 0
                contentUIView.addShadow(position: .leftRight)
            }
        }
    }
    
    
    func configure(items: HomeModel.BankList, indexPath: Int, countItem: Int) {
        self.indexPath = indexPath
        self.countItem = countItem
        titleLbl.text = items.currency
        subtitleLabel.text = "\(items.amount ?? 0)"
        payButton.setTitle("Pay", for: .normal)
        profileImg.image = UIImage(named: "BiplePay")
    }
    
}
