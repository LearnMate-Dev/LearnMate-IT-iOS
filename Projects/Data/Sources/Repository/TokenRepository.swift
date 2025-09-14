//
//  TokenRepository.swift
//  Data
//
//  Created by 박지윤 on 7/17/25.
//

import Domain
import Foundation
import RxSwift
import Alamofire

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
    
    public func validateToken() -> Single<Bool> {
        guard let accessToken = getAccessToken(), !accessToken.isEmpty else {
            print("❌ 토큰이 없습니다")
            return Single.just(false)
        }
        
        // 토큰이 있으면 일단 유효하다고 가정 (실제 서버 검증은 나중에 구현)
        // TODO: 실제 서버 토큰 검증 API 구현 시 아래 주석 해제
        print("🔑 토큰 존재 확인, 자동 로그인 허용")
        return Single.just(true)
        
        /*
        return Single.create { single in
            let url = "\(NetworkConfiguration.baseUrl)/api/auth/validate"
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(accessToken)"
            ]
            
            print("🔍 토큰 검증 요청: \(url)")
            
            let request = AF.request(url,
                                   method: .get,
                                   headers: headers)
                .validate()
                .response { response in
                    switch response.result {
                    case .success:
                        print("✅ 토큰 검증 성공")
                        single(.success(true))
                    case .failure(let error):
                        print("❌ 토큰 검증 실패: \(error)")
                        // 토큰이 무효하면 저장된 토큰 삭제
                        self.clearAccessToken()
                        self.clearRefreshToken()
                        single(.success(false))
                    }
                }
            
            return Disposables.create { request.cancel() }
        }
        */
    }
}
