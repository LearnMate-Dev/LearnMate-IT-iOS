//
//  DefaultDTO.swift
//  Data
//
//  Created by 박지윤 on 8/28/25.
//

import Foundation
import Domain

public struct DefaultDTO: Decodable {
    public let is_success: Bool
    public let code: String
    public let message: String
}

extension DefaultDTO {
    func getMessage() -> DefaultVO {
        return .init(message: message)
    }
}
