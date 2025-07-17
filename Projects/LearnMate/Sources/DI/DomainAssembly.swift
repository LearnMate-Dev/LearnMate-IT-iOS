//
//  DomainAssembly.swift
//  LearnMate
//
//  Created by 박지윤 on 7/2/25.
//

import Domain
import Swinject

public struct DomainAssembly: Assembly {
    public func assemble(container: Container) {
        container.register(CourseUseCase.self) { resolver in
            let repository = resolver.resolve(CourseRepository.self)!
            return DefaultCourseUseCase(repository: repository)
        }

        container.register(LoginUseCase.self) { resolver in
            let repository = resolver.resolve(LoginRepository.self)!
            return DefaultLoginUseCase(repository: repository)
        }
        
        container.register(TokenUseCase.self) { resolver in
            let repository = resolver.resolve(TokenRepository.self)!
            return DefaultTokenUseCase(repository: repository)
        }
    }
}
