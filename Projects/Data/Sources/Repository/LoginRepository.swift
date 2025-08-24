//
//  LoginRepository.swift
//  Data
//
//  Created by 박지윤 on 7/16/25.
//

import Domain
import RxSwift
import Alamofire
import Foundation

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
        let params: Parameters = [
            "userName": userName,
            "identityToken": identityToken
        ]

        return Single.create { single in
            let url = "\(NetworkConfiguration.baseUrl)/api/auth/apple/login"
            let request = AF.request(url,
                                     method: .post,
                                     parameters: params,
                                     encoding: JSONEncoding.default,
                                     headers: nil)
                .redirect(using: Redirector(behavior: .doNotFollow))
                .response { response in
                    if let error = response.error {
                        single(.failure(error))
                        return
                    }

                    guard let httpResponse = response.response else {
                        single(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                        return
                    }

                    if let location = httpResponse.allHeaderFields["Location"] as? String,
                       let components = URLComponents(string: location) {
                        let items = components.queryItems ?? []
                        let accessToken = items.first(where: { $0.name == "accessToken" })?.value
                        single(.success(LoginVO(accessToken: accessToken)))
                    } else {
                        let error = NSError(domain: "DefaultLoginRepository",
                                            code: -1,
                                            userInfo: [NSLocalizedDescriptionKey: "Missing Location header or invalid redirect URL"])
                        single(.failure(error))
                    }
                }

            return Disposables.create { request.cancel() }
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
