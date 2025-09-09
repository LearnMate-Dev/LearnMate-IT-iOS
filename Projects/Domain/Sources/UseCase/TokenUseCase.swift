//
//  TokenUseCase.swift
//  Domain
//
//  Created by 박지윤 on 7/17/25.
//

import RxSwift

public protocol TokenUseCase {
    func saveAccessToken(token: String)
    func getAccessToken() -> String?
    func clearAccessToken()
}

public final class DefaultTokenUseCase: TokenUseCase {
    private let repository: TokenRepository
    
    public init(repository: TokenRepository) {
        self.repository = repository
    }
    
    public func saveAccessToken(token: String) {
        repository.saveAccessToken(token: token)
    }
    
    public func getAccessToken() -> String? {
        return repository.getAccessToken()
    }
    
    public func clearAccessToken() {
        repository.clearAccessToken()
    }
}
