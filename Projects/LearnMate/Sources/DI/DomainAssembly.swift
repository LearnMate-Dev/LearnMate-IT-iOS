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
        
        container.register(TokenValidationUseCase.self) { resolver in
            let repository = resolver.resolve(TokenRepository.self)!
            return DefaultTokenValidationUseCase(repository: repository)
        }
        
        container.register(QuizUseCase.self) { resolver in
            let repository = resolver.resolve(QuizRepository.self)!
            return DefaultQuizUseCase(repository: repository)
        }
        
        container.register(SignUseCase.self) { resolver in
            let repository = resolver.resolve(SignRepository.self)!
            return DefaultSignUseCase(repository: repository)
        }

        container.register(ChatUseCase.self) { resolver in
            let repository = resolver.resolve(ChatRepository.self)!
            return DefaultChatUseCase(repository: repository)
        }

        container.register(DiaryUseCase.self) { resolver in
            let repository = resolver.resolve(DiaryRepository.self)!
            return DefaultDiaryUseCase(repository: repository)
        }

        container.register(UserUseCase.self) { resolver in
            let repository = resolver.resolve(UserRepository.self)!
            return DefaultUserUseCase(repository: repository)
        }
    }
}
