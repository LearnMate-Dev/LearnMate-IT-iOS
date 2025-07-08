//
//  CourseDTO.swift
//  Data
//
//  Created by 박지윤 on 7/8/25.
//

import Foundation

public struct HomeCourseDTO: Decodable {
    public let list: [CourseDTO]?
}

public struct CourseDTO: Decodable {
    public let courseInfoDTO: [CourseInfoDTO]?
}

public struct CourseInfoDTO: Decodable {
    public let courseLv: Int?
    public let courseDescription: String?
    public let stepList: [StepInfoDTO]?
}

public struct StepInfoDTO: Decodable {
    public let stepLv: Int?
    public let stepTitle: String?
    public let stepDescription: String?
    public let stepStatus: String?
}
