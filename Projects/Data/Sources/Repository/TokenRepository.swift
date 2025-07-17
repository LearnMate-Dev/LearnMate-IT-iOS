//
//  TokenRepository.swift
//  Data
//
//  Created by 박지윤 on 7/17/25.
//

import Domain
import Foundation

public class DefaultTokenRepository: TokenRepository {
    private let userDefaults = UserDefaults.standard
    private let accessTokenKey = "accessToken"
    
    public init() {
        // Initialization if needed
    }
    
    public func saveAccessToken(_ token: String) {
        userDefaults.set(token, forKey: accessTokenKey)
        print("✅ Access Token saved: \(token)")
    }
    
    public func getAccessToken() -> String? {
        return userDefaults.string(forKey: accessTokenKey)
    }
    
    public func clearAccessToken() {
        userDefaults.removeObject(forKey: accessTokenKey)
        print("🗑️ Access Token cleared")
    }
}
