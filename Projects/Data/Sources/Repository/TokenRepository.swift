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
    private let accessToken = "accessToken"
    private let refreshToken = "refreshToken"
    
    public init() {
        // Initialization if needed
    }
    
    public func saveAccessToken(token: String) {
        userDefaults.set(token, forKey: accessToken)
        print("✅ Access Token saved: \(token)")
    }
    
    public func getAccessToken() -> String? {
        return userDefaults.string(forKey: accessToken)
    }
    
    public func clearAccessToken() {
        userDefaults.removeObject(forKey: accessToken)
        print("🗑️ Access Token cleared")
    }

    public func saveRefreshToken(token: String) {
        userDefaults.set(token, forKey: refreshToken)
        print("✅ Refresh Token saved: \(token)")
    }
    
    public func getRefreshToken() -> String? {
        return userDefaults.string(forKey: refreshToken)
    }
    
    public func clearRefreshToken() {
        userDefaults.removeObject(forKey: refreshToken)
        print("🗑️ Refresh Token cleared")
    }
}
