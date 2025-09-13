//
//  ChatRepository.swift
//  Data
//
//  Created by 박지윤 on 9/9/25.
//

import Domain
import RxSwift
import Alamofire

public class DefaultChatRepository: ChatRepository {
    private let tokenRepository: TokenRepository

    public init(tokenRepository: TokenRepository) {
        self.tokenRepository = tokenRepository
    }

    /// 텍스트 대화 시작하기
    public func postChatStart() -> Single<ChatVO> {
        return request(method: .post,
                       endpoint: "/api/chats/text",
                       responseType: ChatDataDTO.self
        )
        .map { dto in
            return dto.toDomain()
        }
    }

    /// 텍스트 대화하기
    public func postChat(chatRoomId: Int, content: String) -> Single<ChatMessageVO> {
        let parameter = ["content": content]

        return request(method: .post,
                       parameters: parameter,
                       endpoint: "/api/chats/text/\(chatRoomId)",
                       responseType: ChatMessageDataDTO.self
        )
        .map { dto in
            return dto.toDomain()
        }
    }

    /// 저장된 대화 내역 리스트 조회하기
    public func getChatList() -> Single<[ChatRoomVO]> {
        return request(endpoint: "/api/chats/",
                       responseType: [ChatRoomDataDTO].self
        )
        .map { dtoList in
            dtoList.map { $0.toDomain() }
        }
    }

    /// 저장된 대화 내역 상세 조회하기
    public func getChatDetail(chatRoomId: Int) -> Single<ChatDetailVO> {
        return request(endpoint: "/api/chats/\(chatRoomId)",
                       encoding: URLEncoding.default,
                       responseType: ChatDetailDataDTO.self
        )
        .map { dto in
            return dto.toDomain()
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
            
            let request = AF.request(url,
                                     method: .get,
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
