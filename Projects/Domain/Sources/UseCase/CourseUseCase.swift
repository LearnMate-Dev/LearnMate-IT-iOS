//
//  CourseUseCase.swift
//  Domain
//
//  Created by 박지윤 on 7/8/25.
//

import RxSwift

public protocol CourseUseCase {
    func getCourses() -> Single<HomeCourseVO>
}

public final class DefaultCourseUseCase: CourseUseCase {
    let repository: CourseRepository
    
    public init(repository: CourseRepository) {
        self.repository = repository
    }

    public func getCourses() -> Single<HomeCourseVO> {
        return repository.getCourses()
    }
}
