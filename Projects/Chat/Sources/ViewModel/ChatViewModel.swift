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
    func sendMessage(content: String)
}

public class ChatViewModel: ChatViewModelProtocol {
    private let disposeBag = DisposeBag()
    private let chatUseCase: ChatUseCase
    private let tokenUseCase: TokenUseCase

    let chatListSubject = PublishSubject<ChatRoomListVO>()
    let chatSubject = PublishSubject<ChatVO>()
    let messageSubject = PublishSubject<ChatMessageVO>()
    private var currentChatRoomId: Int = 0

    public init(chatUseCase: ChatUseCase,
                tokenUseCase: TokenUseCase) {
        self.chatUseCase = chatUseCase
        self.tokenUseCase = tokenUseCase
    }

    func getChatList() {
        chatUseCase.getChatList()
            .subscribe(onSuccess: { [weak self] chat in
                print("✅ 저장된 대화 불러오기 성공: \(chat)")
                self?.chatListSubject.onNext(chat)
            }, onFailure: { error in
                print("❌ 저장된 대화 불러오기 실패: \(error)")
            }).disposed(by: disposeBag)
    }

    func startTextChat() {
        chatUseCase.postChatStart()
            .subscribe(onSuccess: { [weak self] chat in
                print("✅ 텍스트 대화 시작 성공: \(chat)")
                self?.currentChatRoomId = chat.chatRoomId
                self?.chatSubject.onNext(chat)
            }, onFailure: { error in
                print("❌ 텍스트 대화 시작 실패: \(error)")
            }).disposed(by: disposeBag)
    }

    func sendMessage(content: String) {
        guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("⚠️ 빈 메시지는 전송할 수 없습니다")
            return 
        }

        chatUseCase.postChat(chatRoomId: currentChatRoomId, content: content)
            .subscribe(onSuccess: { [weak self] message in
                print("✅ 메시지 전송 성공: \(message)")
                self?.messageSubject.onNext(message)
            }, onFailure: { error in
                print("❌ 메시지 전송 실패: \(error)")
            }).disposed(by: disposeBag)
    }
}
