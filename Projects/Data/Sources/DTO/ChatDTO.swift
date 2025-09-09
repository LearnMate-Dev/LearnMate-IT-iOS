//
//  ChatDTO.swift
//  Data
//
//  Created by 박지윤 on 9/9/25.
//

import Domain

public struct ChatResponseDTO: Decodable {
    public let is_success: Bool
    public let code: String
    public let message: String
    public let data: ChatDataDTO
}

public struct ChatDataDTO: Decodable {
    public let chatRoomId: Int
    public let recommendSubjects: [String]
}

extension ChatDataDTO {
    func toDomain() -> ChatVO {
        return ChatVO(
            chatRoomId: chatRoomId,
            recommendSubjects: recommendSubjects
        )
    }
}

public struct ChatMessageResponseDTO: Decodable {
    public let is_success: Bool
    public let code: String
    public let message: String
    public let data: ChatMessageDataDTO
}

public struct ChatMessageDataDTO: Decodable {
    public let chatId: Int
    public let author: String
    public let content: String
}

public struct ChatMessageRequestDTO: Encodable {
    public let content: String
}

extension ChatMessageDataDTO {
    func toDomain() -> ChatMessageVO {
        return ChatMessageVO(
            chatId: chatId,
            author: author,
            content: content
        )
    }
}
