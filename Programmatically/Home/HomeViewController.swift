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
        self.requestMG001()
        
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
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
        tableView.register(MainTitleCell.self, forCellReuseIdentifier: "MainTitleCell")
        tableView.register(EventCell.self, forCellReuseIdentifier: "EventCell")
    }
    
    private func setupNavigation() {
        self.setupHomeMenuView(withTarget: self, title: "비플월렛", leftAction: nil, rightAction: nil)
        self.navigationController?.navigationBar.barTintColor = .white
    }
    
    private func requestMG001() {
        homeVM.fetchMG001(showLoading: false) { (error) in
            guard error == nil else {
                if error?.code == -1009 { // 네트워크 통신 에러 -> 기본팝업_type3a 으로 변경
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        print("error: -1009")
                    }
                }
                else {
                    print("close App")
                }
                return
            }
            
            print("==============================** Success **==============================")
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return homeVM.data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let mainSection = HomeType(rawValue: homeVM.data[section].mainSection)
        switch mainSection {
        case .BANNER     : return 1
        case .BANKLIST  : return (self.homeVM.data[section].value as? [HomeModel.BankList])?.count ?? 0
        case .EVENTTITLE, .EVENTLIST : return 1
        case .none      : return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let mainSection = HomeType(rawValue: homeVM.data[indexPath.section].mainSection)else {
            return UITableViewCell()
        }
        switch mainSection{
        case .BANNER:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainBannerCell", for: indexPath) as! MainBannerCell
            cell.configure(items: self.homeVM.data[indexPath.section].value as? [HomeModel.BannerList] ?? [])
            cell.selectionStyle = .none
            return cell
            
        case .BANKLIST:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentOptionCell", for: indexPath) as! PaymentOptionCell
            let item = self.homeVM.data[indexPath.section].value as? [HomeModel.BankList] ?? []
            cell.configure(items: item[indexPath.row], indexPath: indexPath.row, countItem: item.count)
            cell.selectionStyle = .none
            return cell
        case .EVENTTITLE:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainTitleCell", for: indexPath) as! MainTitleCell
            cell.configure(with: "이벤트")
            cell.selectionStyle = .none
            return cell
        case .EVENTLIST:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
            let item = self.homeVM.data[indexPath.section].value as? [HomeModel.EventList] ?? []
            cell.items = item
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let mainSection = HomeType(rawValue: indexPath.section)else {return CGFloat()}
        switch mainSection{
        case .BANNER:
            let wCell = UIScreen.main.bounds.width - 40
            let aspectRatio: CGFloat = (86/335)
            let hCell = wCell * aspectRatio
            let topPadding = 12.0
            return hCell + topPadding
        case .BANKLIST:
            let countPayment = (self.homeVM.data[indexPath.section].value as? [HomeModel.BankList])?.count ?? 0
            let lastRow = (countPayment - 1 == indexPath.row)
            if indexPath.row == 0 {
                if countPayment == 1 {
                    return 120
                }
                return 90 // 0 : topShadow + 75 : item, 15 : top
            } else if lastRow {
                return 90
            } else {
                return 60
            }
        case .EVENTTITLE:
            return 56
        case .EVENTLIST:
            let eventCount = (self.homeVM.data[indexPath.section].value as? [HomeModel.EventList])?.count ?? 0
            let wCell = UIScreen.main.bounds.width - 40
            let aspectRatio: CGFloat = (126/335)
            let hCell = (wCell * aspectRatio)
            let spacing = 16
            let bottomPadding = 32.0
            let dynamicHeight = CGFloat(hCell * CGFloat(eventCount))
            let totalSpacing = CGFloat(spacing * (eventCount - 1))
            
            let totalHeight = dynamicHeight + totalSpacing + bottomPadding
            
            return CGFloat(totalHeight)
        }
    }
}
