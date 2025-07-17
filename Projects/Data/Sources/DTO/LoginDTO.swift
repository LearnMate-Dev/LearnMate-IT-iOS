//
//  LoginDTO.swift
//  Data
//
//  Created by 박지윤 on 7/16/25.
//

import Foundation
import Domain

public struct LoginDTO: Decodable {
    public let accessToken: String
}

extension LoginDTO {
//    func toDomain() -> CourseVO {
//        return CourseVO(courseLv: 1,
//                        courseDescription: "courseDescription",
//                        stepLv: 1,
//                        stepTitle: "stepTitle",
//                        stepDescription: "stepDescription",
//                        stepStatus: "SOLVED")
//    }
}
