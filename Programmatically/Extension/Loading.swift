//
//  Loading.swift
//  Programmatically
//
//  Created by Nin Sreynuth on 13/11/25.
//

import Foundation
import UIKit

@MainActor
final class Loading {
    static let shared = Loading()

    private init() {}
    
    private var containerView: UIView?
    
    func showLoading(){
        let loadingView = UIView(frame: containerView?.bounds ?? CGRect())
        loadingView.backgroundColor = UIColor(white: 0, alpha: 0.4)

        let spinner = UIActivityIndicatorView(style: .large)
        spinner.center = loadingView.center
        spinner.startAnimating()

        loadingView.addSubview(spinner)
        containerView?.addSubview(loadingView)
    }

    func hideLoading() {
        containerView?.removeFromSuperview()
    }
    
    func delayBeforeHide(after seconds: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.hideLoading()
        }
    }
}
