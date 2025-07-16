//
//  LoginAssembly.swift
//  LearnMate
//
//  Created by 박지윤 on 7/16/25.
//

import Swinject
import Login
import Domain

/// Assembly: Swinject의 DI 등록을 위한 프로토콜
public struct LoginAssembly: Assembly {
    /// assemble(container:): 어떤 객체를 어떻게 등록할지 정의
    public func assemble(container: Container) {
        /// HomeViewModel을 DI 컨테이너에 등록
        container.register(LoginViewModel.self) { resolver in
            let useCase = resolver.resolve(LoginUseCase.self)!
            return LoginViewModel(loginUseCase: useCase)
        }

        /// ViewModel을 DI 통해 주입받아 Controller를 생성함
        container.register(LoginViewController.self) { resolver in
            let loginViewModel = resolver.resolve(LoginViewModel.self)!
            return LoginViewController(loginViewModel: loginViewModel)
        }
    }
}
