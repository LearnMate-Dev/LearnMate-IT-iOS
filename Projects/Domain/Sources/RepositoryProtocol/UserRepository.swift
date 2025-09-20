//
//  UserRepository.swift
//  Domain
//
//  Created by 박지윤 on 9/20/25.
//

import RxSwift

public protocol UserRepository {
    func getUser() -> Single<UserVO>
    func postLogout() -> Single<DefaultVO>
    func deleteUser() -> Single<DefaultVO>
}
