//
//  LoginUseCase.swift
//  Domain
//
//  Created by 박지윤 on 7/16/25.
//

import RxSwift

public protocol LoginUseCase {
    func postGoogleLogin() -> Single<LoginVO>
}

public final class DefaultLoginUseCase: LoginUseCase {
    let repository: LoginRepository
    
    public init(repository: LoginRepository) {
        self.repository = repository
    }

    public func postGoogleLogin() -> Single<LoginVO> {
        return repository.postGoogleLogin()
    }
}
