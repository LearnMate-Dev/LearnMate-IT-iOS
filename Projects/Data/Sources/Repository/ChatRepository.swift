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

    public func startTextChat() -> Single<ChatVO> {
        return Single.create { single in
            let url = "\(NetworkConfiguration.baseUrl)/api/chats/text"
            var headers: HTTPHeaders = [:]
            
            if let token = self.tokenRepository.getAccessToken() {
                headers.add(name: "Authorization", value: "Bearer \(token)")
            }
            
            print("[텍스트 대화 시작 POST] URL: \(url)")
            print("[텍스트 대화 시작 POST] 헤더: \(headers)")

            let request = AF.request(url,
                                     method: .post,
                                     encoding: JSONEncoding.default,
                                     headers: headers)
                .validate()
                .responseDecodable(of: ChatResponseDTO.self) { response in
                    switch response.result {
                    case .success(let value):
                        print("[텍스트 대화 시작 POST] 성공: \(value)")
                        single(.success(value.data.toDomain()))
                    case .failure(let error):
                        print("[텍스트 대화 시작 POST] 실패: \(error)")
                        single(.failure(error))
                    }
                }
            return Disposables.create { request.cancel() }
        }
    }
}
