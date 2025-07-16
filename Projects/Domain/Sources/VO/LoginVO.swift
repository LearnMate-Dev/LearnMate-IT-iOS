//
//  LoginVO.swift
//  Domain
//
//  Created by 박지윤 on 7/16/25.
//

//public struct LoginVO {
//    public let list: [CourseVO]
//
//    public init(list: [CourseVO]) {
//            self.list = list
//    }
//}

public struct LoginVO {
    public let accessToken: String?

    public init(accessToken: String?) {
        self.accessToken = accessToken
    }
}
