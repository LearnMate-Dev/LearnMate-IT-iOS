//
//  ChatViewModel.swift
//  Chat
//
//  Created by 박지윤 on 7/1/25.
//

import Domain
import RxSwift

protocol ChatViewModelProtocol {
    func startTextChat()
}

public class ChatViewModel: ChatViewModelProtocol {
    private let disposeBag = DisposeBag()
    private let chatUseCase: ChatUseCase
    private let tokenUseCase: TokenUseCase

    let chatSubject = PublishSubject<ChatVO>()

    public init(chatUseCase: ChatUseCase,
                tokenUseCase: TokenUseCase) {
        self.chatUseCase = chatUseCase
        self.tokenUseCase = tokenUseCase
    }

    func startTextChat() {
        chatUseCase.postChat()
            .subscribe(onSuccess: { [weak self] chat in
                print("✅ 텍스트 대화 시작 성공: \(chat)")
                self?.chatSubject.onNext(chat)
            }, onFailure: { error in
                print("❌ 텍스트 대화 시작 실패: \(error)")
            }).disposed(by: disposeBag)
    }
}
