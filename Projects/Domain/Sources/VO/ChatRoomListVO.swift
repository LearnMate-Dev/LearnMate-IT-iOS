//
//  ChatRoomListVO.swift
//  Domain
//
//  Created by 박지윤 on 9/11/25.
//

public struct ChatRoomListVO {
    public let chatRoomList: [ChatRoomVO]

    public init(chatRoomList: [ChatRoomVO]) {
        self.chatRoomList = chatRoomList
    }
}

public struct ChatRoomVO {
    public let chatRoomId: Int
    public let title: String
    public let createdAt: String

    public init(chatRoomId: Int, title: String, createdAt: String) {
        self.chatRoomId = chatRoomId
        self.title = title
        self.createdAt = createdAt
    }
}
