//
//  HomeModel.swift
//  Programmatically
//
//  Created by Nin Sreynuth on 13/10/25.
//

import Foundation

enum HomeType: Int, CaseIterable {
    case BANNER
    case BANKLIST
    case EVENTTITLE
    case EVENTLIST
}
struct HomeModel {
    let headerList  : String?
    let eventList   : [BannerList]?
    let bankList    : [BankList]?
    let mainList    : [EventList]?
    
    struct BannerList {
        let imageList       : String?
    }
    
    struct BankList {
        let imageCoin       : String?
        let currency        : String?
        let amount          : Double?
    }
    
    struct EventList {
        let imageList       : String?
    }
}
