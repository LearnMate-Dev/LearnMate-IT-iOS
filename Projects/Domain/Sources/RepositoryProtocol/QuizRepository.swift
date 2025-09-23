//
//  QuizRepository.swift
//  Domain
//
//  Created by 박지윤 on 7/17/25.
//

import RxSwift

public protocol QuizRepository {
    func startStep(course: Int, step: Int) -> Single<QuizVO>
    func patchStep(stepProgressId: Int) -> Single<DefaultVO>
    func deleteStep(stepProgressId: Int) -> Single<DefaultVO>
}
