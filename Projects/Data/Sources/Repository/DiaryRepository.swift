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

    public func postDiary(content: String) -> Single<DiaryVO> {
        let parameter = ["content": content]

        return request(method: .post,
                       parameters: parameter,
                       endpoint: "/api/diaries",
                       responseType: DiaryResponseDTO.self
        )
        .map { dto in
            return dto.data.toDomain()
        }
    }

    public func getDiary(date: String) -> Single<DiaryVO> {
        let parameter = ["date": date]

        return request(parameters: parameter,
                       endpoint: "/api/diaries",
                       responseType: DiaryResponseDTO.self
        )
        .map { dto in
            return dto.data.toDomain()
        }
    }
    
    public func getDiaryDetail(diaryId: Int, date: String) -> Single<DiaryVO>  {
        let parameter = ["date": date]

        return request(parameters: parameter,
                       endpoint: "/api/diaries/\(diaryId)",
                       responseType: DiaryResponseDTO.self
        )
        .map { dto in
            return dto.data.toDomain()
        }
    }
    
    public func deleteDiaryDetail(diaryId: Int) -> Single<DefaultVO> {
        return request(method: .delete,
                       endpoint: "/api/diaries/\(diaryId)",
                       responseType: DefaultDTO.self
        )
        .map { dto in
            return dto.getMessage()
        }
    }
    
    public func getDiaryCalendar(year: Int, month: Int) -> Single<DiaryCalendarVO>  {
        let parameter = ["year": year,
                         "month": month]

        return request(parameters: parameter,
                       endpoint: "/api/diaries/calendar",
                       encoding: URLEncoding.default,
                       responseType: DiaryCalendarResponseDTO.self
        )
        .map { dto in
            return dto.data.toDomain()
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
