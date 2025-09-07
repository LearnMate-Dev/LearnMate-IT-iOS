//
//  LoginDTO.swift
//  Data
//
//  Created by 박지윤 on 7/16/25.
//

import Foundation
import Domain

public struct LoginDTO: Decodable {
    public let is_success: Bool
    public let code: String
    public let message: String
    public let data: LoginDataDTO
}

public struct LoginDataDTO: Decodable {
    public let accessToken: String
    public let refreshToken: String
}

extension LoginDTO {
    func getMessage() -> LoginVO {
        return .init(accessToken: data.accessToken,
                     refreshToken: data.refreshToken)
    }
}

public struct GoogleLoginDTO: Decodable {
    public let accessToken: String
}

extension GoogleLoginDTO {
//    func toDomain() -> CourseVO {
//        return CourseVO(courseLv: 1,
//                        courseDescription: "courseDescription",
//                        stepLv: 1,
//                        stepTitle: "stepTitle",
//                        stepDescription: "stepDescription",
//                        stepStatus: "SOLVED")
//    }
}
