//
//  LoginVO.swift
//  Domain
//
//  Created by 박지윤 on 7/16/25.
//

public struct LoginVO {
    public let accessToken: String?
    public let refreshToken: String?

    public init(accessToken: String?,
                refreshToken: String?) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}

public struct GoogleLoginVO {
    public let accessToken: String?

    public init(accessToken: String?) {
        self.accessToken = accessToken
    }
}
