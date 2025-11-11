//
//  HomeModel.swift
//  Programmatically
//
//  Created by Nin Sreynuth on 13/10/25.
//

import Foundation

enum HomeType: Int, CaseIterable {
    case EVENT
    case BANKLIST
    case MAINTITLE
    case MAINLIST
}
struct HomeModel {
    let headerList  : String?
    let eventList   : [EventList]?
    let bankList    : [BankList]?
    let mainList    : [MainList]?
    
    struct EventList {
        let imageList       : String?
    }
    
    struct BankList {
        let imageCoin       : String?
        let currency        : String?
        let amount          : Double?
    }
    
    struct MainList {
        let imageList       : String?
    }
}
