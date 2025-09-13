//
//  ChatDetailVO.swift
//  Domain
//
//  Created by 박지윤 on 9/11/25.
//

public struct ChatDetailVO {
    public let chatRoom: ChatRoomVO
    public let chatList: [ChatListVO]

    public init(chatRoom: ChatRoomVO, chatList: [ChatListVO]) {
        self.chatRoom = chatRoom
        self.chatList = chatList
    }
}

public struct ChatListVO {
    public let chatId: Int
    public let author: Int
    public let content: String
    public let comment: String
    public let createdAt: String

    public init(chatId: Int,
                author: Int,
                content: String,
                comment: String,
                createdAt: String) {
        self.chatId = chatId
        self.author = author
        self.content = content
        self.comment = comment
        self.createdAt = createdAt
    }
}
