//
//  ViewController.swift
//  Programmatically
//
//  Created by Nin Sreynuth on 13/10/25.
//

import UIKit

class HomeViewController: UIViewController {
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    let paymentOptions = [
            ("내계좌 결제", "하나은행 (1234)", "결제"),
            ("비플머니", "265,273원", "결제")
        ]
    let events = [
        ("비플월렛 소식", "내코인(USDT, USDC) 이제 제로페이로 바로 쓰자!", "💱"),
        ("상품권 소식", "친구 추천하고 신세계상품권 10만원 받기", "🎁")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        self.setupNavigation()
        self.registerCell()
        self.setupTableView()
        
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
    
    private func registerCell() {
        tableView.register(EventCell.self, forCellReuseIdentifier: "MainBannerCell")
        tableView.register(PaymentOptionCell.self, forCellReuseIdentifier: "PaymentOptionCell")
        tableView.register(EventCell.self, forCellReuseIdentifier: "EventCell")
    }
    
    private func setupNavigation() {
        self.setupHomeMenuView(withTarget: self, title: "비플월렛", leftAction: nil, rightAction: nil)
        self.navigationController?.navigationBar.barTintColor = .white
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return HomeType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let mainSection = HomeType(rawValue: section)
        switch mainSection {
        case .EVENT     : return 1
        case .BANKLIST  : return paymentOptions.count
        case .MAINTITLE : return 1
        case .MAINLIST  : return events.count
        case .none      : return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let mainSection = HomeType(rawValue: indexPath.section)else {
            return UITableViewCell()
        }
        switch mainSection{
        case .EVENT:
            let cell = UITableViewCell()
            let label = UILabel()
            label.text = "비플월렛, 코인도 충전 가능!\n제로페이 가맹점 어디서나!"
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 16)
            label.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(label)
            cell.contentView.backgroundColor = UIColor.systemGray6
            cell.contentView.layer.cornerRadius = 12
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 16),
                label.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 16),
                label.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: -16),
                label.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -16)
            ])
            return cell
        case .BANKLIST:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentOptionCell", for: indexPath) as! PaymentOptionCell
            let data = paymentOptions[indexPath.row]
            cell.configure(title: data.0, subtitle: data.1, buttonTitle: data.2)
            return cell
        case .MAINTITLE:
            let cell = UITableViewCell()
            let label = UILabel()
            label.text = "비플월렛, 코인도 충전 가능!\n제로페이 가맹점 어디서나!"
            return cell
        case .MAINLIST:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
            let data = events[indexPath.row]
            cell.configure(title: data.0, subtitle: data.1, icon: data.2)
            return cell
        }
    }
}
