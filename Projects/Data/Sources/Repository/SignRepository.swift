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

    public func postEmail(email: String) -> Single<DefaultVO> {
        let params = ["email": email]
        return request(endpoint: "/api/auth/email",
                       parameters: params,
                       responseType: DefaultDTO.self)
        .map { dto in
            return dto.getMessage()
        }
    }

    public func postConfirm(email: String, code: String) -> Single<DefaultVO> {
        let params = ["email": email, "code": code]
        return request(endpoint: "/api/auth/email/confirm",
                       parameters: params,
                       responseType: DefaultDTO.self)
        .map { dto in
            return dto.getMessage()
        }
    }

    private func request<T: Decodable>(
        endpoint: String,
        parameters: [String: Any]? = nil,
        responseType: T.Type
    ) -> Single<T> {
        return Single.create { single in
            let url = "\(NetworkConfiguration.baseUrl)\(endpoint)"
            let headers: HTTPHeaders = [:]
            let request = AF.request(
                url,
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: headers
            )
            .validate()
            .responseDecodable(of: responseType) { response in
                switch response.result {
                case .success(let value):
                    print("✅ API 응답 성공: \(value)")
                    single(.success(value))
                case .failure(let error):
                    print("❌ API 응답 실패: \(error)")
                    single(.failure(error))
                }
            }
            return Disposables.create { request.cancel() }
        }
    }
}
