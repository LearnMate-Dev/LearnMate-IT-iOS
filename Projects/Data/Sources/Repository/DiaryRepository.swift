//
//  DiaryRepository.swift
//  Data
//
//  Created by 박지윤 on 9/15/25.
//

import Domain
import RxSwift
import Alamofire

public class DefaultDiaryRepository: DiaryRepository {
    private let tokenRepository: TokenRepository

    public init(tokenRepository: TokenRepository) {
        self.tokenRepository = tokenRepository
    }

    private func request<T: Decodable>(
        method: HTTPMethod = .get,
        parameters: [String: Any]? = nil,
        endpoint: String,
        encoding: ParameterEncoding = JSONEncoding.default,
        responseType: T.Type
    ) -> Single<T> {
        return Single.create { single in
            let url = "\(NetworkConfiguration.baseUrl)\(endpoint)"
            var headers: HTTPHeaders = [:]
            
            if let token = self.tokenRepository.getAccessToken() {
                print("🔑 사용할 토큰: \(token)")
                headers.add(name: "Authorization", value: "Bearer \(token)")
            } else {
                print("❌ 토큰이 없습니다!")
            }
            print("🌐 API 요청 URL: \(url)")
            print("🔑 Authorization 헤더: \(headers)")
            
            let request = AF.request(url,
                                     method: method,
                                     parameters: parameters,
                                     encoding: encoding,
                                     headers: headers)
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
