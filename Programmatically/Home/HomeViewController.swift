//
//  ViewController.swift
//  Programmatically
//
//  Created by Nin Sreynuth on 13/10/25.
//

import UIKit

class HomeViewController: UIViewController {
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    lazy var homeVM = HomeViewModel()
    
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
        tableView.register(MainBannerCell.self, forCellReuseIdentifier: "MainBannerCell")
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
        return homeVM.data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let mainSection = HomeType(rawValue: homeVM.data[section].mainSection)
        switch mainSection {
        case .EVENT     : return 1
        case .BANKLIST  : return (self.homeVM.data[section].value as? [HomeModel.BankList])?.count ?? 0
        case .MAINTITLE : return 1
        case .MAINLIST  : return (self.homeVM.data[section].value as? [HomeModel.MainList])?.count ?? 0
        case .none      : return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let mainSection = HomeType(rawValue: homeVM.data[indexPath.section].mainSection)else {
            return UITableViewCell()
        }
        switch mainSection{
        case .EVENT:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainBannerCell", for: indexPath) as! MainBannerCell
            cell.configure(items: self.homeVM.data[indexPath.section].value as? [HomeModel.EventList] ?? [])
            return cell
            
        case .BANKLIST:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentOptionCell", for: indexPath) as! PaymentOptionCell
            let item = self.homeVM.data[indexPath.section].value as? [HomeModel.BankList] ?? []
            cell.configure(items: item[indexPath.row], indexPath: indexPath.row, countItem: item.count)
            return cell
        case .MAINTITLE:
            let cell = UITableViewCell()
            let label = UILabel()
            label.text = "이벤트"
            return cell
        case .MAINLIST:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
            let item = self.homeVM.data[indexPath.section].value as? [HomeModel.MainList] ?? []
            cell.configure(items: item[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let mainSection = HomeType(rawValue: indexPath.section)else {return CGFloat()}
        switch mainSection{
        case .EVENT:
            return 80
        case .BANKLIST:
            return 93
        case .MAINTITLE:
            return 89
        case .MAINLIST:
            return 80
        }
    }
}
