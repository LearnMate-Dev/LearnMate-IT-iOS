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
            endpoint: NetworkConfiguration.baseUrl,
            id: 4,
            responseType: LoginDTO.self
        )
        .map { dto in
            return LoginVO(accessToken: "")
        }
    }

    private func request<T: Decodable>(endpoint: String, id: Int, responseType: T.Type) -> Single<T> {
            return Single.create { single in
                let url = "\(NetworkConfiguration.baseUrl)\(endpoint)"
                let parameters: Parameters = [
                    "id": id
                ]

                let request = AF.request(url,
                                         method: .get,
                                         parameters: parameters,
                                         encoding: URLEncoding.queryString)
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
