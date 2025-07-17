//
//  CourseDTO.swift
//  Data
//
//  Created by 박지윤 on 7/8/25.
//

import Foundation
import Domain

public struct CourseResponseDTO: Decodable {
    public let is_success: Bool
    public let code: String
    public let message: String
    public let data: CourseDataDTO
}

public struct CourseDataDTO: Decodable {
    public let courseList: [CourseDTO]
}

public struct CourseDTO: Decodable {
    public let courseLv: Int
    public let courseDescription: String
    public let stepList: [StepDTO]
    public let progress: Int
    public let courseStatus: String
}

public struct StepDTO: Decodable {
    public let stepLv: Int
    public let stepTitle: String
    public let stepDescription: String
    public let stepStatus: String
}

extension CourseDTO {
    func toDomain() -> CourseVO {
        let stepVOList = stepList.map { step in
            StepVO(
                stepLv: step.stepLv,
                stepTitle: step.stepTitle,
                stepDescription: step.stepDescription,
                stepStatus: step.stepStatus
            )
        }

        return CourseVO(
            courseLv: courseLv,
            courseDescription: courseDescription,
            stepList: stepVOList,
            progress: progress,
            courseStatus: courseStatus
        )
    }
}

extension CourseResponseDTO {
    func toHome() -> HomeCourseVO {
        return .init(list: data.courseList.map { $0.toDomain() })
    }
}
