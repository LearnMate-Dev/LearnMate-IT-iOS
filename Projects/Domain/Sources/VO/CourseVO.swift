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
    public let courseLv: Int
    public let courseDescription: String
    public let stepList: [StepVO]
    public let progress: Int
    public let courseStatus: String

    public init(courseLv: Int, courseDescription: String, stepList: [StepVO], progress: Int, courseStatus: String) {
        self.courseLv = courseLv
        self.courseDescription = courseDescription
        self.stepList = stepList
        self.progress = progress
        self.courseStatus = courseStatus
    }
}
