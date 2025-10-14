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

extension UIColor {
    //Convert to Hex
    public convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

extension CALayer {
  func applySketchShadow(
    color: UIColor = .black,
    alpha: Float = 0.08,
    x: CGFloat = 0,
    y: CGFloat = 14,
    blur: CGFloat = 32,
    spread: CGFloat = 0)
    {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
          shadowPath = nil
        } else {
          let dx = -spread
          let rect = bounds.insetBy(dx: dx, dy: dx)
          shadowPath = UIBezierPath(rect: rect).cgPath
        }
      }
}

extension UIView {
    @IBInspectable
    var borderViewWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderViewColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    @IBInspectable
    var cornerAllRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var cornerTopRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            if #available(iOS 11.0, *) {
                layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    @IBInspectable
    var cornerBottomRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            if #available(iOS 11.0, *) {
                layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    @IBInspectable
    var cornerLeftRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            if #available(iOS 11.0, *) {
                layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    @IBInspectable
    var cornerRightRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            if #available(iOS 11.0, *) {
                layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}
