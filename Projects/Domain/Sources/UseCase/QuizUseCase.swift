//
//  QuizUseCase.swift
//  Domain
//
//  Created by 박지윤 on 7/17/25.
//

import RxSwift

public protocol QuizUseCase {
    func startStep(course: Int, step: Int) -> Single<QuizVO>
    func patchStep(stepProgressId: Int) -> Single<DefaultVO>
}

public final class DefaultQuizUseCase: QuizUseCase {
    private let repository: QuizRepository
    
    public init(repository: QuizRepository) {
        self.repository = repository
    }
    
    public func startStep(course: Int, step: Int) -> Single<QuizVO> {
        return repository.startStep(course: course, step: step)
    }

    public func patchStep(stepProgressId: Int) -> Single<DefaultVO> {
        return repository.patchStep(stepProgressId: stepProgressId)
    }
}
