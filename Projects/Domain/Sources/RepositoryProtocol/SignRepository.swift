//
//  SignRepository.swift
//  Domain
//
//  Created by 박지윤 on 8/26/25.
//

import RxSwift

public protocol SignRepository {
    func postEmail(email: String) -> Completable
    func postConfirm(email: String, code: String) -> Completable
}
