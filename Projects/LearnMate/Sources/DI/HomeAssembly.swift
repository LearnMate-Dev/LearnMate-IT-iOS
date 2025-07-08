//
//  HomeAssembly.swift
//  LearnMate
//
//  Created by 박지윤 on 7/2/25.
//

import Swinject
import Home
import Domain

/// Assembly: Swinject의 DI 등록을 위한 프로토콜
public struct HomeAssembly: Assembly {
    /// assemble(container:): 어떤 객체를 어떻게 등록할지 정의
    public func assemble(container: Container) {
        /// HomeViewModel을 DI 컨테이너에 등록
        container.register(HomeViewModel.self) { resolver in
            let useCase = resolver.resolve(CourseUseCase.self)!
            return HomeViewModel(courseUseCase: useCase)
        }

        /// ViewModel을 DI 통해 주입받아 Controller를 생성함
        container.register(HomeViewController.self) { resolver in
            let homeViewModel = resolver.resolve(HomeViewModel.self)!
            return HomeViewController(homeViewModel: homeViewModel)
        }
    }
}
