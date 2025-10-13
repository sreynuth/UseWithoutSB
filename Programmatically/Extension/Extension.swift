//
//  Extension.swift
//  Programmatically
//
//  Created by Nin Sreynuth on 13/10/25.
//

import Foundation
import UIKit

extension UIViewController {
    
    func setupHomeMenuView(withTarget target: UIViewController,
                           title: String,
                           leftAction: Selector? = nil,
                           rightAction: Selector? = nil) {

        // Create a UILabel for the title
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .left

        // Wrap it in a UIView
        let containerView = UIView()
        containerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])

        // Important: use a UIBarButtonItem to align left
        let leftItem = UIBarButtonItem(customView: containerView)
        target.navigationItem.leftBarButtonItem = leftItem
    }
    
    func setupMenuView(withTarget target : UIViewController ,actionData: String, leftAction: Selector?, rightAction: Selector?, manualTitle: String? = nil) {
        //Left button
        let leftBtn = UIButton(type: .custom)
        leftBtn.contentHorizontalAlignment = .left
        leftBtn.frame = CGRect(x: 0, y: 0, width: 60, height: 20)
        leftBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
       
        leftBtn.setImage(UIImage(named: "btn_navi_back"), for: .normal)
        leftBtn.setImage(UIImage(named: "btn_navi_back"), for: .highlighted)
        leftBtn.accessibilityLabel = "상위메뉴로 이동"
        
        if leftAction != nil {
            leftBtn.addTarget(target, action: leftAction!, for: .touchUpInside)
        }
        
        let leftBarButton = UIBarButtonItem(customView: leftBtn)
        self.addBarButtonAnchor(barButton: leftBarButton)
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func addBarButtonAnchor(barButton : UIBarButtonItem, heightAnchor : CGFloat = 24, widthAnchor : CGFloat = 50) {
        barButton.customView?.heightAnchor.constraint(equalToConstant: heightAnchor).isActive = true
        barButton.customView?.widthAnchor.constraint(equalToConstant: widthAnchor).isActive = true
    }
}
