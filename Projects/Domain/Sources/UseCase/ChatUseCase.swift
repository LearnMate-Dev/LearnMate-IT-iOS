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
    func deleteChat(chatRoomId: Int) -> Single<DefaultVO>
    func postChatAnalysis(chatRoomId: Int) -> Single<ChatDetailVO>
    func getChatList() -> Single<[ChatRoomVO]>
    func getChatDetail(chatRoomId: Int) -> Single<ChatDetailVO>
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

    public func deleteChat(chatRoomId: Int) -> Single<DefaultVO> {
        return repository.deleteChat(chatRoomId: chatRoomId)
    }

    public func postChatAnalysis(chatRoomId: Int) -> Single<ChatDetailVO> {
        return repository.postChatAnalysis(chatRoomId: chatRoomId)
    }
    
    public func getChatList() -> Single<[ChatRoomVO]> {
        return repository.getChatList()
    }

    public func getChatDetail(chatRoomId: Int) -> Single<ChatDetailVO> {
        return repository.getChatDetail(chatRoomId: chatRoomId)
    }
}
