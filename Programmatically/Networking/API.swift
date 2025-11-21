//
//  API.swift
//  Programmatically
//
//  Created by Nin Sreynuth on 13/11/25.
//

import UIKit

struct API {
    private init(){}
    
    static var serverURL    : String { return "https://dev-biz-zero.bizplay.co.kr"}
    
    static var MG001        : String { return "C_MG_001" }
    
    static var MG001URL     : String {
        return "https://mg-dev.bizplay.co.kr/" + "MgGate?master_id=I_BIZ_BEPLEWALLET_v" + "v1-1-4"/*AppInfo.getAppVersion()*/ + "_MG001"
    }
}
