//
//  TokenRepository.swift
//  Domain
//
//  Created by 박지윤 on 7/17/25.
//

import RxSwift

public protocol TokenRepository {
    func saveAccessToken(_ token: String)
    func getAccessToken() -> String?
    func clearAccessToken()
}
