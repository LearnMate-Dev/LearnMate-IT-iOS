//
//  ChatUseCase.swift
//  Domain
//
//  Created by 박지윤 on 9/8/25.
//

import RxSwift

public protocol ChatUseCase {
}

public final class DefaultChatUseCase: ChatUseCase {
    let repository: ChatRepository

    public init(repository: ChatRepository) {
        self.repository = repository
    }
}
