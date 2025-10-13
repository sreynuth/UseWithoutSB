//
//  ViewController.swift
//  Programmatically
//
//  Created by Nin Sreynuth on 13/10/25.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        title = "Home (Programmatic UI)"
        setupUI()
    }

    private func setupUI() {
        let label = UILabel()
        label.text = "Hello, Swift 6 UIKit!"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

