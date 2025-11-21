//
//  ShareConstant.swift
//  Programmatically
//
//  Created by Nin Sreynuth on 13/11/25.
//

import Foundation
import UIKit

@MainActor
struct ShareConstant {
    private init(){}
    static var shared = ShareConstant()
    
    var mg001Data           : MG001Model.TranResData!
    
    var isShareTracking     : Bool = false
    static var language     : LanguageCode = .Korean
    
    
    var userAgent: String {
        let deviceInfo      = DeviceInfo.info
        let nma_app_ver     = deviceInfo.getAppVersion()
        let nma_plf_ver     = deviceInfo.systemVersion
        let nma_model       = "iPhone XS Max"
        let nma_app_id      = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String ?? ""
        let nma_app_cd      = Encryption_UserAgent.nma_app_cd
        let nma_dev_id      = deviceInfo.getUUID()
        let nma_netnm       = deviceInfo.getCarrierName()
        let nma_phoneno     = ""
        let nma_adr_id      = ""
        let nma_adid        = ""
        let nma_idfv        = deviceInfo.getUUID()
        
        //        let originalUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS \(UIDevice.current.systemVersion) like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148;nma-plf=IOS;nma-bizplay20=Y;nma-app-ver=\(nma_app_ver);nma-plf-ver=\(nma_plf_ver);nma-model=\(nma_model);nma-app-id=\(nma_app_id);nma-app-cd=\(nma_app_cd);nma-dev-id=\(nma_dev_id);nma-netnm=\(nma_netnm);nma-phoneno=\(nma_phoneno);nma-adr-id=\(nma_adr_id);nma-adid=\(nma_adid);nma-idfv=\(nma_idfv);"
        
        
        // Build User-Agent string
        let originalUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS \(UIDevice.current.systemVersion) like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148;nma-plf=IOS;nma-bizplay20=Y;nma-app-ver=\(nma_app_ver);nma-plf-ver=\(nma_plf_ver);nma-model=\(nma_model);nma-app-id=\(nma_app_id);nma-app-cd=\(nma_app_cd);nma-dev-id=\(nma_dev_id);nma-netnm=\(nma_netnm);nma-phoneno=\(nma_phoneno);nma-adr-id=\(nma_adr_id);nma-adid=\(nma_adid);nma-idfv=\(nma_idfv);nma-lang=\(ShareConstant.language.rawValue);"
        
        return originalUserAgent
    }
}
