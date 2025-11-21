//
//  HomeModel.swift
//  Programmatically
//
//  Created by Nin Sreynuth on 13/10/25.
//

import Foundation

enum HomeType: Int, CaseIterable, Sendable {
    case BANNER
    case BANKLIST
    case EVENTTITLE
    case EVENTLIST
}
struct HomeModel: Sendable {
    let headerList  : String?
    let eventList   : [BannerList]?
    let bankList    : [BankList]?
    let mainList    : [EventList]?
    
    struct BannerList: Sendable {
        let imageList       : String?
    }
    
    struct BankList: Sendable {
        let imageCoin       : String?
        let currency        : String?
        let amount          : Double?
    }
    
    struct EventList: Sendable {
        let imageList       : String?
    }
}
