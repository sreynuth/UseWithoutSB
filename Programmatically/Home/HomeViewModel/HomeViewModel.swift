//
//  HomeViewModel.swift
//  Programmatically
//
//  Created by Nin Sreynuth on 13/10/25.
//

import Foundation

struct CustomMainData<T> {
    var mainSection      : HomeType.RawValue
    var value        : [T]?
}
class HomeViewModel {
    var data        = [CustomMainData<Any>]()
    
    init() {
        initData()
    }
    
    func initData() {
        self.data.removeAll()
        
        // Event Banner
        var eventList   = [HomeModel.EventList]()
        eventList = [HomeModel.EventList(title: "비플월렛, 코인도 충전 가능!\n제로페이 가맹점 어디서나!"),
                     HomeModel.EventList(title: "비플월렛, 코인도 충전 가능!\n제로페이 가맹점 어디서나!"),
                     HomeModel.EventList(title: "비플월렛, 코인도 충전 가능!\n제로페이 가맹점 어디서나!"),
                     HomeModel.EventList(title: "비플월렛, 코인도 충전 가능!\n제로페이 가맹점 어디서나!")]
        self.data.append(CustomMainData(mainSection: HomeType.EVENT.rawValue, value: eventList))
        
        // Bank List
        var bankList    = [HomeModel.BankList]()
        bankList = [HomeModel.BankList(imageCoin: "", currency: "비플머니", amount: 100),
                    HomeModel.BankList(imageCoin: "", currency: "UPIT", amount: 200),
                    HomeModel.BankList(imageCoin: "", currency: "COIN", amount: 300)]
        self.data.append(CustomMainData(mainSection: HomeType.BANKLIST.rawValue, value: bankList))
        
        // Main List
        var mainList    = [HomeModel.MainList]()
        mainList = [HomeModel.MainList(imageList: "list"),
                    HomeModel.MainList(imageList: "list"),
                    HomeModel.MainList(imageList: "list")]
        self.data.append(CustomMainData(mainSection: HomeType.MAINLIST.rawValue, value: mainList))
    }
    
    
}
