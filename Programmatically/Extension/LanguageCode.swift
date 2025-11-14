//
//  LanguageCode.swift
//  Programmatically
//
//  Created by Nin Sreynuth on 14/11/25.
//

import Foundation


enum LanguageCode: String {
    case Korean     = "ko"
    case English    = "en"
}
@MainActor
extension String {
    var localized: String {
        get {
            return common_loalized(language: ShareConstant.language.rawValue)
        }
    }

    private func common_loalized(language: String) -> String {
        
        let languageCode    = language
        let bundlePath      = Bundle.main.path(forResource: languageCode, ofType: ".lproj")
        
        let languageBudle   = Bundle(path: bundlePath ?? "")
        var translateString = languageBudle?.localizedString(forKey: self, value: "", table: nil)  ?? ""
        
        if translateString.count < 1 {
            translateString = NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: self, comment: self)
        }
        
        return translateString
    }
}
