//
//  AuthPlugin.swift
//  LeafMAP
//
//  Created by 오현민 on 11/23/25.
//

import Foundation
import Moya
import UIKit
import Kingfisher

// 모든 API 요청에 Authorization 헤더를 추가하는 Moya 플러그인
final class AuthPlugin: PluginType {

    static let shared = AuthPlugin()
    private init() {}

    // MARK: - 요청 준비
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        
        // 토큰이 있으면 Authorization 헤더 추가
        if let token = TokenManager.shared.getAccessToken(), !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }

    // MARK: - 응답 처리
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        switch result {
        case .success(let response):
            // 401 에러인 경우 토큰 만료로 간주하고 자동 로그아웃
            if response.statusCode == 401 {
                print("⚠️ 401 Unauthorized - 토큰 만료로 인한 자동 로그아웃")
                DispatchQueue.main.async {
                    self.forceLogout()
                }
            }
            return result
        case .failure:
            return result
        }
    }

    // MARK: - 강제 로그아웃 (필요 시 사용)
    func forceLogout() {
        TokenManager.shared.clearTokens()
        UserDefaults.standard.removeObject(forKey: "loginMethod")
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache {
            print("🗑️ Kingfisher 디스크 캐시 초기화 완료")
        }

        let loginVC = MainLoginViewController()
        let nav = UINavigationController(rootViewController: loginVC)
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            window.rootViewController = nav
            window.makeKeyAndVisible()
            UIView.transition(with: window,
                              duration: 0.1,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }
}



