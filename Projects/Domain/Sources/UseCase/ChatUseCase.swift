//
//  ChatUseCase.swift
//  Domain
//
//  Created by 박지윤 on 9/8/25.
//

import RxSwift

public protocol ChatUseCase {
    func postChatStart() -> Single<ChatVO>
    func postChat(chatRoomId: Int, content: String) -> Single<ChatMessageVO>
}

public final class DefaultChatUseCase: ChatUseCase {
    private let repository: ChatRepository

    public init(repository: ChatRepository) {
        self.repository = repository
    }

    public func postChatStart() -> Single<ChatVO> {
        return repository.postChatStart()
    }

    public func postChat(chatRoomId: Int, content: String) -> Single<ChatMessageVO> {
        return repository.postChat(chatRoomId: chatRoomId, content: content)
    }
}
