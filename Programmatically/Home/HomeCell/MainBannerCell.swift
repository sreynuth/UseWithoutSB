//
//  MainBannerCell.swift
//  Programmatically
//
//  Created by Nin Sreynuth on 13/10/25.
//

import UIKit

class MainBannerCell: UITableViewCell {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal // horizontal scrolling
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private let badgeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.systemGray5
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.layer.cornerRadius = 11
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Data for collection view
    private var items               : [HomeModel.BannerList] = []
    private var bannerTimer         : Timer?
    private var currentIndexPath    : IndexPath = IndexPath(item: 0, section: 0)
    private var moveBannerDirection : Int = 1
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(containerView)
        containerView.addSubview(collectionView)
        containerView.addSubview(badgeLabel)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: "BannerCollectionViewCell")
        
        // ✅ Make the collection view fill the entire cell
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            collectionView.topAnchor.constraint(equalTo: containerView.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            badgeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4),
            badgeLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -4),
            badgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 46),
            badgeLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection          = .horizontal
        layout.sectionInset             = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing       = 0
        layout.minimumInteritemSpacing  = 0
        let wCell = UIScreen.main.bounds.width - 40
        let aspectRatio: CGFloat = (86/335)
        let hCell = wCell * aspectRatio
        layout.itemSize = CGSize(width: wCell , height: hCell)
        self.collectionView.setCollectionViewLayout(layout, animated: false)
        self.collectionView.isPagingEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -OBJC
    @objc private func makeBannerScrollAction() {
        
        // reverse moving
        if self.currentIndexPath.item == (self.items.count) - 1 {
            self.moveBannerDirection = -1
        }
        
        // normal moving
        if self.currentIndexPath.item == 0 {
            self.moveBannerDirection = 1
        }
        
        
        if self.moveBannerDirection == -1 {
            DispatchQueue.main.async {
                self.currentIndexPath = IndexPath(item: 0, section: 0)
                self.collectionView.scrollToItem(at: self.currentIndexPath, at: .centeredHorizontally, animated: true)
                self.collectionView.selectItem(at: self.currentIndexPath, animated: false, scrollPosition: .right)
                self.badgeLabel.text = ("\(self.currentIndexPath.row + 1) / \(self.items.count)")
                self.moveBannerDirection = 1
            }
        } else if self.currentIndexPath.row < (self.items.count) {
            DispatchQueue.main.async{
                let numberOfItem = self.collectionView.numberOfItems(inSection: 0)
                if numberOfItem > 1 {  // Protection when have only one item in section
                    self.currentIndexPath = IndexPath(item: self.currentIndexPath.row + self.moveBannerDirection, section: 0)
                    self.collectionView.scrollToItem(at: IndexPath(row: self.currentIndexPath.row, section: 0), at: .centeredHorizontally, animated: true)
                    self.collectionView.selectItem(at:self.currentIndexPath, animated: false, scrollPosition: .right)
                } else {
                    return
                }
                self.badgeLabel.text = ("\(self.currentIndexPath.row + 1) / \(self.items.count)")
            }
        }

    }
    
    func configure(items: [HomeModel.BannerList]) {
        self.items = items
        self.badgeLabel.text =  ("\(self.currentIndexPath.row + 1) / \(items.count)")
        self.collectionView.isScrollEnabled = (self.items.count) > 1
    }
    
    func startAutoScrollBanner(isAutoRolling: Bool) {
        let haveDataToScroll = (items.count > 1) && !(items.isEmpty)
        if haveDataToScroll && isAutoRolling {
            stopAutoScrollBanner()
            self.bannerTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(makeBannerScrollAction), userInfo: nil, repeats: true)
        }
    }
    
    func stopAutoScrollBanner() {
        self.bannerTimer?.invalidate()
        self.bannerTimer = nil
    }
}

extension MainBannerCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell", for: indexPath) as! BannerCollectionViewCell
        let item = items[indexPath.item]
        cell.configure(items: item)
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.stopAutoScrollBanner()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.startAutoScrollBanner(isAutoRolling: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let indexPath = self.collectionView.indexPathForItem(at: visiblePoint) {
            self.currentIndexPath       = indexPath
            self.badgeLabel.text = ("\(self.currentIndexPath.row + 1) / \(self.items.count)")
        }
    }
}
