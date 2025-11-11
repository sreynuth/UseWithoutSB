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
        
        // Banner Banner
        var bannerList   = [HomeModel.BannerList]()
        let eventKoList = ["eventbanner_Ko_1", "eventbanner_Ko_2", "eventbanner_Ko_3"]
        let bannerEng   = ["mainbanner_Eng_1", "mainbanner_Eng_2", "mainbanner_Eng_3"]
        
        for bnrImgItem in bannerEng {
            bannerList.append(HomeModel.BannerList(imageList: bnrImgItem))
        }
        self.data.append(CustomMainData(mainSection: HomeType.BANNER.rawValue, value: bannerList))
        
        // Bank List
        var bankList    = [HomeModel.BankList]()
        bankList = [HomeModel.BankList(imageCoin: "", currency: "비플머니", amount: 100),
                    HomeModel.BankList(imageCoin: "", currency: "UPIT", amount: 200),
                    HomeModel.BankList(imageCoin: "", currency: "COIN", amount: 300)]
        self.data.append(CustomMainData(mainSection: HomeType.BANKLIST.rawValue, value: bankList))
        
        // Main Title
        let eventTitle = [HomeModel(headerList: "이벤트", eventList: nil, bankList: nil, mainList: nil)]
        self.data.append(CustomMainData(mainSection: HomeType.EVENTTITLE.rawValue, value: eventTitle))
        
        // Event List
        var eventList    = [HomeModel.EventList]()
        for bnrImgItem in eventKoList {
            eventList.append(HomeModel.EventList(imageList: bnrImgItem))
        }
        self.data.append(CustomMainData(mainSection: HomeType.EVENTLIST.rawValue, value: eventList))
    }
    
    
}
