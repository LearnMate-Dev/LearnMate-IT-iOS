//
//  DiaryViewModel.swift
//  Diary
//
//  Created by 박지윤 on 7/1/25.
//

import Domain
import RxSwift

protocol DiaryViewModelProtocol {
}

public class DiaryViewModel: DiaryViewModelProtocol {
    private let disposeBag = DisposeBag()
    private let diaryUseCase: DiaryUseCase
    private let tokenUseCase: TokenUseCase

    let chatListSubject = PublishSubject<ChatRoomListVO>()
    let chatSubject = PublishSubject<ChatVO>()
    let messageSubject = PublishSubject<ChatMessageVO>()
    let analysisResultSubject = PublishSubject<ChatDetailVO>()
    let chatDetailSubject = PublishSubject<ChatDetailVO>()
    private var currentChatRoomId: Int = 0

    public init(diaryUseCase: DiaryUseCase,
                tokenUseCase: TokenUseCase) {
        self.diaryUseCase = diaryUseCase
        self.tokenUseCase = tokenUseCase
    }
}
