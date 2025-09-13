//
//  ChatDetailDTO.swift
//  Data
//
//  Created by 박지윤 on 9/11/25.
//

import Domain

public struct ChatDetailResponseDTO: Decodable {
    public let is_success: Bool
    public let code: String
    public let message: String
    public let data: ChatDetailDataDTO
}

public struct ChatDetailDataDTO: Decodable {
    public let chatRoom: ChatRoomDataDTO
    public let chatList: [ChatListDTO]
}

public struct ChatListDTO: Decodable {
    public let chatId: Int
    public let author: Int
    public let content: String
    public let comment: String?
    public let createdAt: String
}

extension ChatDetailDataDTO {
    func toDomain() -> ChatDetailVO {
        let chatRoomVO = ChatRoomVO(chatRoomId: chatRoom.chatRoomId,
                                    title: chatRoom.title,
                                    createdAt: chatRoom.createdAt)

        let chatListVO = chatList.map { chat in
            ChatListVO(chatId: chat.chatId,
                       author: chat.author,
                       content: chat.content,
                       comment: chat.comment,
                       createdAt: chat.createdAt)
        }

        return ChatDetailVO(chatRoom: chatRoomVO, chatList: chatListVO)
    }
}
