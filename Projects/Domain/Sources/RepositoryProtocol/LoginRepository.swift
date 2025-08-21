//
//  LoginRepository.swift
//  Domain
//
//  Created by 박지윤 on 7/16/25.
//

import RxSwift

public protocol LoginRepository {
    func postGoogleLogin() -> Single<LoginVO>
    func postAppleLogin(userName: String?, identityToken: String) -> Single<LoginVO>
}
