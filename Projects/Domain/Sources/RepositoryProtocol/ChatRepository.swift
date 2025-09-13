//
//  ChatRepository.swift
//  Domain
//
//  Created by 박지윤 on 9/8/25.
//

import RxSwift

public protocol ChatRepository {
    func postChatStart() -> Single<ChatVO>
    func postChat(chatRoomId: Int, content: String) -> Single<ChatMessageVO>
    func deleteChat(chatRoomId: Int) -> Single<DefaultVO>
    func postChatAnalysis(chatRoomId: Int) -> Single<ChatDetailVO>
    func getChatList() -> Single<ChatRoomListVO>
    func getChatDetail(chatRoomId: Int) -> Single<ChatDetailVO>
}
