//
//  LoginUseCase.swift
//  Domain
//
//  Created by 박지윤 on 8/26/25.
//

import RxSwift

public protocol LoginUseCase {
    func postGoogleLogin() -> Single<GoogleLoginVO>
    func postAppleLogin(userName: String?, identityToken: String) -> Single<GoogleLoginVO>
}

public final class DefaultLoginUseCase: LoginUseCase {
    let repository: LoginRepository

    public init(repository: LoginRepository) {
        self.repository = repository
    }

    public func postGoogleLogin() -> Single<GoogleLoginVO> {
        return repository.postGoogleLogin()
    }

    public func postAppleLogin(userName: String?, identityToken: String) -> Single<GoogleLoginVO> {
        return repository.postAppleLogin(userName: userName, identityToken: identityToken)
    }
}
