//
//  TokenValidationUseCase.swift
//  Domain
//
//  Created by 박지윤 on 9/15/25.
//

import RxSwift

public protocol TokenValidationUseCase {
    func validateToken() -> Single<Bool>
}

public final class DefaultTokenValidationUseCase: TokenValidationUseCase {
    private let repository: TokenRepository
    
    public init(repository: TokenRepository) {
        self.repository = repository
    }
    
    public func validateToken() -> Single<Bool> {
        return repository.validateToken()
    }
}
