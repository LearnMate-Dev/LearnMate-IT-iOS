//
//  SignUseCase.swift
//  Domain
//
//  Created by 박지윤 on 8/26/25.
//

import RxSwift

public protocol SignUseCase {
    func postEmail(email: String) -> Single<DefaultVO>
    func postConfirm(email: String, code: String) -> Single<DefaultVO>
    func postSignUp(username: String, email: String, password: String) -> Single<DefaultVO>
}

public final class DefaultSignUseCase: SignUseCase {
    let repository: SignRepository

    public init(repository: SignRepository) {
        self.repository = repository
    }

    public func postEmail(email: String) -> Single<DefaultVO> {
        return repository.postEmail(email: email)
    }

    public func postConfirm(email: String, code: String) -> Single<DefaultVO> {
        return repository.postConfirm(email: email, code: code)
    }

    public func postSignUp(username: String, email: String, password: String) -> Single<DefaultVO> {
        return repository.postSignUp(username: username, email: email, password: password)
    }
}
