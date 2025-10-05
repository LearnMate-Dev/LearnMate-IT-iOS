//
//  MyPageAssembly.swift
//  LearnMate
//
//  Created by 박지윤 on 1/7/25.
//

import MyPage
import Domain
import Swinject

public struct MyPageAssembly: Assembly {
    public func assemble(container: Container) {
        container.register(MyPageViewModel.self) { resolver in
            let userUseCase = resolver.resolve(UserUseCase.self)!
            let tokenUseCase = resolver.resolve(TokenUseCase.self)!
            return MyPageViewModel(userUseCase: userUseCase, tokenUseCase: tokenUseCase)
        }
        
        container.register(MyPageViewController.self) { resolver in
            let viewModel = resolver.resolve(MyPageViewModel.self)!
            return MyPageViewController(myPageViewModel: viewModel)
        }
    }
}
