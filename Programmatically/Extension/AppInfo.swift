//
//  AppInfo.swift
//  Programmatically
//
//  Created by Nin Sreynuth on 13/11/25.
//

import Foundation

struct AppInfo {
    static func getAppVersion(replaceDotBySymbol symbol: String = ".") -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        return version.replacingOccurrences(of: ".", with: symbol)
    }
}
