//
//  UserUseCase.swift
//  Domain
//
//  Created by 박지윤 on 9/20/25.
//

import RxSwift

public protocol UserUseCase {
    func getUser() -> Single<UserVO>
    func postLogout() -> Single<DefaultVO>
    func deleteUser() -> Single<DefaultVO>
}

public final class DefaultUserUseCase: UserUseCase {
    private let repository: UserRepository

    public init(repository: UserRepository) {
        self.repository = repository
    }

    public func getUser() -> Single<UserVO> {
        return repository.getUser()
    }

    public func postLogout() -> Single<DefaultVO> {
        return repository.postLogout()
    }

    public func deleteUser() -> Single<DefaultVO> {
        return repository.deleteUser()
    }
}
