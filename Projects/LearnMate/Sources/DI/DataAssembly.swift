//
//  DataAssembly.swift
//  LearnMate
//
//  Created by 박지윤 on 7/2/25.
//

import Swinject
import Domain
import Data

public struct DataAssembly: Assembly {
    public func assemble(container: Container) {
        container.register(CourseRepository.self) { resolver in
            let tokenRepository = resolver.resolve(TokenRepository.self)!
            return DefaultCourseRepository(tokenRepository: tokenRepository)
        }

        container.register(LoginRepository.self) { _ in
            return DefaultLoginRepository()
        }
        
        container.register(TokenRepository.self) { _ in
            return DefaultTokenRepository()
        }
        
        container.register(QuizRepository.self) { resolver in
            let tokenRepository = resolver.resolve(TokenRepository.self)!
            return DefaultQuizRepository(tokenRepository: tokenRepository)
        }

        container.register(SignRepository.self) { _  in
            return DefaultSignRepository()
        }

        container.register(ChatRepository.self) { resolver in
            let tokenRepository = resolver.resolve(TokenRepository.self)!
            return DefaultChatRepository(tokenRepository: tokenRepository)
        }
    }
}
