//
//  QuizRepository.swift
//  Data
//
//  Created by 박지윤 on 7/17/25.
//

import Domain
import RxSwift
import Alamofire

public class DefaultQuizRepository: QuizRepository {
    private let tokenRepository: TokenRepository
    
    public init(tokenRepository: TokenRepository) {
        self.tokenRepository = tokenRepository
    }
    
    public func startStep(course: Int, step: Int) -> Single<QuizVO> {
        return request(
            endpoint: "/api/courses",
            course: course,
            step: step,
            responseType: QuizResponseDTO.self
        )
        .map { dto in
            return dto.data.toDomain()
        }
    }
    
    private func request<T: Decodable>(endpoint: String, course: Int, step: Int, responseType: T.Type) -> Single<T> {
        return Single.create { single in
            let url = "\(NetworkConfiguration.baseUrl)\(endpoint)?course=\(course)&step=\(step)"
            var headers: HTTPHeaders = [:]
            if let token = self.tokenRepository.getAccessToken() {
                headers.add(name: "Authorization", value: "Bearer \(token)")
            } else {
                print("❌ 토큰이 없습니다!")
            }
            
            print("🌐 API 요청 URL: \(url)")
            print("🔑 Authorization 헤더: \(headers)")
            
            let request = AF.request(url,
                                     method: .post,
                                     parameters: nil,
                                     encoding: JSONEncoding.default,
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
