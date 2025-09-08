//
//  ChatRepository.swift
//  Domain
//
//  Created by 박지윤 on 9/8/25.
//

import RxSwift

public protocol ChatRepository {
    func startTextChat() -> Single<ChatVO>
}
