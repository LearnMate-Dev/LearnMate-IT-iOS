//
//  DiaryAssembly.swift
//  LearnMate
//
//  Created by 박지윤 on 7/2/25.
//

import Swinject
import Diary
import Domain

public struct DiaryAssembly: Assembly {
    public func assemble(container: Container) {
        container.register(DiaryViewModel.self) { resolver in
            let diaryUseCase = resolver.resolve(DiaryUseCase.self)!
            let tokenUseCase = resolver.resolve(TokenUseCase.self)!
            return DiaryViewModel(diaryUseCase: diaryUseCase,
                                 tokenUseCase: tokenUseCase)
        }

        container.register(DiaryViewController.self) { resolver in
            let diaryViewModel = resolver.resolve(DiaryViewModel.self)!
            return DiaryViewController(diaryViewModel: diaryViewModel)
        }
    }
}
