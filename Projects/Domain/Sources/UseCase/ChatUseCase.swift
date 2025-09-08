//
//  ChatUseCase.swift
//  Domain
//
//  Created by 박지윤 on 9/8/25.
//

import RxSwift

public protocol ChatUseCase {
    func startTextChat() -> Single<ChatVO>
}

public final class DefaultChatUseCase: ChatUseCase {
    private let repository: ChatRepository

    public init(repository: ChatRepository) {
        self.repository = repository
    }

    public func startTextChat() -> Single<ChatVO> {
        return repository.startTextChat()
    }
}
