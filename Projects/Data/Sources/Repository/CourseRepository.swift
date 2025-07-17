//
//  CourseRepository.swift
//  Data
//
//  Created by 박지윤 on 7/8/25.
//

import Domain
import RxSwift
import Alamofire

public class DefaultCourseRepository: CourseRepository {
    private let tokenRepository: TokenRepository
    
    public init(tokenRepository: TokenRepository) {
        self.tokenRepository = tokenRepository
    }

    public func getCourses() -> Single<HomeCourseVO> {
        return request(
            endpoint: "/api/courses",
            responseType: CourseResponseDTO.self
        )
        .map { dto in
            return dto.toHome()
        }
    }

    private func request<T: Decodable>(endpoint: String, responseType: T.Type) -> Single<T> {
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
                                     method: .get,
                                     encoding: URLEncoding.queryString,
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
