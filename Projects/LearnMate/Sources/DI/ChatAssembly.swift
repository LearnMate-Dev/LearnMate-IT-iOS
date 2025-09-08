//
//  ChatAssembly.swift
//  LearnMate
//
//  Created by 박지윤 on 7/2/25.
//

import Swinject
import Chat
import Domain

/// Assembly: Swinject의 DI 등록을 위한 프로토콜
public struct ChatAssembly: Assembly {
    /// assemble(container:): 어떤 객체를 어떻게 등록할지 정의
    public func assemble(container: Container) {
        /// HomeViewModel을 DI 컨테이너에 등록
        container.register(ChatViewModel.self) { resolver in
            let chatUseCase = resolver.resolve(ChatUseCase.self)!
            let tokenUseCase = resolver.resolve(TokenUseCase.self)!
            return ChatViewModel(chatUseCase: chatUseCase,
                                 tokenUseCase: tokenUseCase)
        }

        /// ViewModel을 DI 통해 주입받아 Controller를 생성함
        container.register(ChatViewController.self) { resolver in
            let chatViewModel = resolver.resolve(ChatViewModel.self)!
            return ChatViewController(chatViewModel: chatViewModel)
        }
    }
}
