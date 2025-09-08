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
