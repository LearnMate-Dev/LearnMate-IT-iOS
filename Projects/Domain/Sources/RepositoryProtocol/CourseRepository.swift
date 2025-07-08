//
//  CourseRepository.swift
//  Domain
//
//  Created by 박지윤 on 7/8/25.
//

import RxSwift

public protocol CourseRepository {
    func getCourses() -> Single<CourseVO>
}
