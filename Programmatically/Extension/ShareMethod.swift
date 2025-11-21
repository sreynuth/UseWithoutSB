//
//  ShareMethod.swift
//  Programmatically
//
//  Created by Nin Sreynuth on 13/11/25.
//

import Foundation


final class ShareMethod : Sendable {
    static let shared = ShareMethod()
    private init() {}
    
     func convertToDictionary(jsonString: String) -> Dictionary<String, Any>? {
        guard let data = jsonString.data(using: .utf8) else { return nil }
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
        } catch {
            print("Cannon convert to Dictionary ::::> \(error.localizedDescription)")
            return nil
        }
    }
}
