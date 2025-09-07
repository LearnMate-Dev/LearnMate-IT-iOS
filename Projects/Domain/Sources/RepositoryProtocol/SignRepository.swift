//
//  SignRepository.swift
//  Domain
//
//  Created by 박지윤 on 8/26/25.
//

import RxSwift

public protocol SignRepository {
    func postEmail(email: String) -> Single<DefaultVO>
    func postConfirm(email: String, code: String) -> Single<DefaultVO>
    func postSignUp(username: String, email: String, password: String) -> Single<DefaultVO>
}
