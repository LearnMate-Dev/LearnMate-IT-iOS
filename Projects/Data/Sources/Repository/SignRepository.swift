//
//  SignRepository.swift
//  Data
//
//  Created by 박지윤 on 8/26/25.
//

import Domain
import RxSwift
import Alamofire

public class DefaultSignRepository: SignRepository {

    public init() { }

    public func postEmail(email: String) -> Completable {
        return request(endpoint: "/api/auth/email")
    }
    
    public func postConfirm(email: String, code: String) -> Completable {
        return request(endpoint: "/api/auth/email/confirm")
    }

    private func request(endpoint: String) -> Completable {
        return Completable.create { completable in
            let url = "\(NetworkConfiguration.baseUrl)\(endpoint)"
            var headers: HTTPHeaders = [:]
            let request = AF.request(url,
                                     method: .get,
                                     encoding: URLEncoding.queryString,
                                     headers: headers)
                .validate()
                .response { response in
                    if let error = response.error {
                        print("❌ API 응답 실패")
                        completable(.error(error))
                    } else {
                        print("✅ API 응답 성공")
                        completable(.completed)
                    }
                }

            return Disposables.create { request.cancel() }
        }
    }
}
