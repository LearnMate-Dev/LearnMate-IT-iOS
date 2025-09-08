//
//  ChatVO.swift
//  Domain
//
//  Created by 박지윤 on 9/9/25.
//

public struct ChatVO {
    public let chatRoomId: Int
    public let recommendSubjects: [String]
    
    public init(chatRoomId: Int, recommendSubjects: [String]) {
        self.chatRoomId = chatRoomId
        self.recommendSubjects = recommendSubjects
    }
} 
