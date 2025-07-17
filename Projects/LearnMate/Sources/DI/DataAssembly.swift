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
        container.register(CourseRepository.self) { _ in
            return DefaultCourseRepository()
        }

        container.register(LoginRepository.self) { _ in
            return DefaultLoginRepository()
        }
        
        container.register(TokenRepository.self) { _ in
            return DefaultTokenRepository()
        }
    }
}
