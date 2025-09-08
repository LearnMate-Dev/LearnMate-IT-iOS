//
//  ChatAssembly.swift
//  LearnMate
//
//  Created by 박지윤 on 7/2/25.
//

import Swinject
import Chat
import Domain

public struct ChatAssembly: Assembly {
    public func assemble(container: Container) {
        container.register(ChatViewModel.self) { resolver in
            let chatUseCase = resolver.resolve(ChatUseCase.self)!
            let tokenUseCase = resolver.resolve(TokenUseCase.self)!
            return ChatViewModel(chatUseCase: chatUseCase,
                                 tokenUseCase: tokenUseCase)
        }

        container.register(ChatViewController.self) { resolver in
            let chatViewModel = resolver.resolve(ChatViewModel.self)!
            return ChatViewController(chatViewModel: chatViewModel)
        }
    }
}
