//
//  CourseVO.swift
//  Domain
//
//  Created by 박지윤 on 7/8/25.
//

public struct HomeCourseVO {
    public let list: [CourseVO]
}

public struct CourseVO {
    public let courseLv: Int?
    public let courseDescription: String?
    public let stepLv: Int?
    public let stepTitle: String?
    public let stepDescription: String?
    public let stepStatus: String?
}
