//
//  CourseVO.swift
//  Domain
//
//  Created by 박지윤 on 7/8/25.
//

public struct HomeCourseVO {
    public let list: [CourseVO]

    public init(list: [CourseVO]) {
            self.list = list
    }
}

public struct CourseVO {
    public let courseLv: Int?
    public let courseDescription: String?
    public let stepLv: Int?
    public let stepTitle: String?
    public let stepDescription: String?
    public let stepStatus: String?

    public init(courseLv: Int?, courseDescription: String?, stepLv: Int?, stepTitle: String?, stepDescription: String?, stepStatus: String?) {
        self.courseLv = courseLv
        self.courseDescription = courseDescription
        self.stepLv = stepLv
        self.stepTitle = stepTitle
        self.stepDescription = stepDescription
        self.stepStatus = stepStatus
    }
}
