//
//  UserDTO.swift
//  Data
//
//  Created by 박지윤 on 9/20/25.
//

import Foundation
import Domain

public struct UserDTO: Decodable {
    public let is_success: Bool
    public let code: String
    public let message: String
    public let data: UserDataDTO
}

public struct UserDataDTO: Decodable {
    public let userId: Int
    public let name: String
}

extension UserDataDTO {
    func toDomain() -> UserVO {
        return UserVO(userId: userId, name: name)
    }
}
