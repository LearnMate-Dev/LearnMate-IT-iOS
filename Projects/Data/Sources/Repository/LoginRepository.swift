//
//  LoginRepository.swift
//  Data
//
//  Created by 박지윤 on 7/16/25.
//

import Domain
import RxSwift
import Alamofire

public class DefaultLoginRepository: LoginRepository {
    public init() {}

    public func postGoogleLogin() -> Single<LoginVO> {
        return request(
            endpoint: "/oauth2/authorization/google",
            responseType: LoginDTO.self
        )
        .map { dto in
            return LoginVO(accessToken: "")
        }
    }

    public func postAppleLogin(userName: String?, identityToken: String) -> Single<LoginVO> {
        print("⚠️ postAppleLogin")
        print("⚠️ \(userName)")
        print("⚠️ \(identityToken)")

        let params: Parameters = [
            "userName": userName,
            "identityToken": identityToken
        ]

        return request(
            endpoint: "/api/auth/apple/login",
            parameters: params,
            encoding: JSONEncoding.default,
            responseType: LoginDTO.self
        )
        .map { dto in
            return LoginVO(accessToken: "")
        }
    }

    private func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .post,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.queryString,
        headers: HTTPHeaders? = nil,
        responseType: T.Type
    ) -> Single<T> {
        return Single.create { single in
            let url = "\(NetworkConfiguration.baseUrl)\(endpoint)"
            let request = AF.request(url,
                                     method: method,
                                     parameters: parameters,
                                     encoding: encoding,
                                     headers: headers)
                .validate()
                .responseDecodable(of: responseType) { response in
                    switch response.result {
                    case .success(let value):
                        single(.success(value))
                    case .failure(let error):
                        single(.failure(error))
                    }
                }
            
            return Disposables.create { request.cancel() }
        }
    }
}
