//
//  HomeViewModel.swift
//  Programmatically
//
//  Created by Nin Sreynuth on 13/10/25.
//

import Foundation
import Network

struct CustomMainData<T: Sendable>: Sendable {
    var mainSection: HomeType.RawValue
    var value: [T]?
}

@MainActor
class HomeViewModel: ObservableObject {
    @Published var data: [CustomMainData<Sendable>] = []
    
    init() {
        initData()
    }

    final func initData() {
        self.data.removeAll()
        
        // Banner Data
        let bannerEng = ["mainbanner_Eng_1", "mainbanner_Eng_2", "mainbanner_Eng_3"]
        let bannerList = bannerEng.map { HomeModel.BannerList(imageList: $0) }
        
        self.data.append(
            CustomMainData(mainSection: HomeType.BANNER.rawValue,
                           value: bannerList)
        )
        
        // Bank List
        let bankList = [
            HomeModel.BankList(imageCoin: "", currency: "비플머니", amount: 100),
            HomeModel.BankList(imageCoin: "", currency: "UPIT", amount: 200),
            HomeModel.BankList(imageCoin: "", currency: "COIN", amount: 300)
        ]
        
        self.data.append(
            CustomMainData(mainSection: HomeType.BANKLIST.rawValue,
                           value: bankList)
        )
        
        // Event Title
        let eventTitle = [
            HomeModel(headerList: "이벤트", eventList: nil, bankList: nil, mainList: nil)
        ]
        
        self.data.append(
            CustomMainData(mainSection: HomeType.EVENTTITLE.rawValue,
                           value: eventTitle)
        )
        
        // Event List
        let eventKoList = ["eventbanner_Ko_1", "eventbanner_Ko_2", "eventbanner_Ko_3"]
        let eventList = eventKoList.map { HomeModel.EventList(imageList: $0) }
        
        self.data.append(
            CustomMainData(mainSection: HomeType.EVENTLIST.rawValue,
                           value: eventList)
        )
    }
    
    func fetchMG001(showLoading: Bool, completion: @escaping @MainActor (NSError?) -> Void) {
        Task {
            DataAccess().fetchGateWay(
                id: API.MG001,
                body: MG001Model.Request(),
                responseType: Response<MG001Model.MGResponse>.self,
                shouldShowLoading: showLoading
            ) { result in
                
                Task { @MainActor in
                    switch result {
                    case .failure(let error):
                        completion(error)
                        
                    case .success(let data):
                        if let mgData = data.RESP_DATA?._tran_res_data.first {
                            ShareConstant.shared.mg001Data = mgData
                            completion(nil)
                        } else {
                            let error = NSError(
                                domain: "ERROR_MG",
                                code: 1168,
                                userInfo: [NSLocalizedDescriptionKey: Network_Message.errorOccurredWhileProcessing]
                            )
                            completion(error)
                        }
                    }
                }
            }
        }
    }
    
    
}
