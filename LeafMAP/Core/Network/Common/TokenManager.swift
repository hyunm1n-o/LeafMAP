//
//  TokenManager.swift
//  LeafMAP
//
//  Created by 오현민 on 11/23/25.
//

import Foundation

final class TokenManager {
    static let shared = TokenManager()
    
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    
    private init() {}
    
    // MARK: - Access Token
    func saveAccessToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: accessTokenKey)
    }
    
    func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: accessTokenKey)
    }
    
    // MARK: - Refresh Token
    func saveRefreshToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: refreshTokenKey)
    }
    
    func getRefreshToken() -> String? {
        return UserDefaults.standard.string(forKey: refreshTokenKey)
    }
    
    // MARK: - Clear Tokens
    func clearTokens() {
        UserDefaults.standard.removeObject(forKey: accessTokenKey)
        UserDefaults.standard.removeObject(forKey: refreshTokenKey)
    }
    
    // MARK: - Check Token Exists
    func hasAccessToken() -> Bool {
        return getAccessToken() != nil && !getAccessToken()!.isEmpty
    }
    
    func hasRefreshToken() -> Bool {
        return getRefreshToken() != nil && !getRefreshToken()!.isEmpty
    }
}

