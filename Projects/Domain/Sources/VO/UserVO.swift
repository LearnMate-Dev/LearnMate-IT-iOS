//
//  UserVO.swift
//  Domain
//
//  Created by 박지윤 on 9/20/25.
//

public struct UserVO {
    public let userId: Int
    public let name: String

    public init(userId: Int,
                name: String) {
        self.userId = userId
        self.name = name
    }
}
