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
        let params: Parameters = [
            "course": course,
            "step": step
        ]

        return request(method: .post,
                       parameters: params,
                       endpoint: "/api/courses",
                       encoding: URLEncoding.default,
                       responseType: QuizResponseDTO.self
        )
        .map { dto in
            return dto.data.toDomain()
        }
    }

    public func patchStep(stepProgressId: Int) -> Single<DefaultVO> {
        return request(method: .patch,
                       endpoint: "/api/courses/\(stepProgressId)",
                       responseType: DefaultDTO.self
        )
        .map { dto in
            return dto.getMessage()
        }
    }

    public func deleteStep(stepProgressId: Int) -> Single<DefaultVO> {
        return request(method: .delete,
                       endpoint: "/api/courses/\(stepProgressId)",
                       responseType: DefaultDTO.self
        )
        .map { dto in
            return dto.getMessage()
        }
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
            print("📤 요청 파라미터: \(parameters ?? [:])")
            print("📤 요청 메서드: \(method)")
            print("📤 인코딩: \(encoding)")
            
            let request = AF.request(url,
                                     method: method,
                                     parameters: parameters,
                                     encoding: encoding,
                                     headers: headers)
                .responseDecodable(of: responseType) { response in
                    print("📊 HTTP 상태 코드: \(response.response?.statusCode ?? -1)")
                    if let data = response.data {
                        print("📊 응답 데이터: \(String(data: data, encoding: .utf8) ?? "데이터 파싱 실패")")
                    }
                    
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
