//
//  DiaryUseCase.swift
//  Domain
//
//  Created by 박지윤 on 9/15/25.
//

import RxSwift

public protocol DiaryUseCase {
}

public final class DefaultDiaryUseCase: DiaryUseCase {
    private let repository: DiaryRepository

    public init(repository: DiaryRepository) {
        self.repository = repository
    }
}
