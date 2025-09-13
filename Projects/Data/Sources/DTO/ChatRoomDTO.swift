//
//  ChatRoomDTO.swift
//  Data
//
//  Created by 박지윤 on 9/11/25.
//

import Domain

public struct ChatRoomResponseDTO: Decodable {
    public let is_success: Bool
    public let code: String
    public let message: String
    public let data: [ChatRoomDataDTO]
}

public struct ChatRoomDataDTO: Decodable {
    public let chatRoomId: Int
    public let title: String
    public let createdAt: String
}

extension ChatRoomDataDTO {
    func toDomain() -> ChatRoomVO {
        return ChatRoomVO(chatRoomId: chatRoomId,
                          title: title,
                          createdAt: createdAt)
    }
}
