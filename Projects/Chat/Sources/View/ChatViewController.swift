//
//  ChatViewController.swift
//  Chat
//
//  Created by 박지윤 on 7/1/25.
//

import UIKit
import CommonUI
import RxSwift
import Domain

public class ChatViewController: BaseViewController {
    let viewModel: ChatViewModel
    let chatView = ChatView()

    private var messages: [ChatMessageVO] = []

    public init(chatViewModel: ChatViewModel) {
        self.viewModel = chatViewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViewProperty()
        setupHierarchy()
        setupLayout()
        bindData()
        bindActions()
        setupTextFieldActions()
        viewModel.startTextChat()
    }

    public override func setupViewProperty() {
        view.backgroundColor = CommonUIAssets.LMOrange4
    }

    public override func setupHierarchy() {
        view.addSubview(chatView)
    }

    public override func setupDelegate() {
    }

    public override func setupLayout() {
        chatView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func bindData() {
        viewModel.chatSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (chat: ChatVO) in
                print("📨 ChatVO 수신: \(chat)")
                self?.updateRecommendTopics(chat.recommendSubjects)
            })
            .disposed(by: disposeBag)
            
        viewModel.messageSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (message: ChatMessageVO) in
                print("📨 메시지 수신: \(message)")
                self?.addMessageToUI(message)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindActions() {
        chatView.onSendButtonTapped = { [weak self] message in
            self?.sendMessage(message)
        }
    }
    
    private func setupTextFieldActions() {
        chatView.chatTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    @objc private func textFieldDidChange() {
        let text = chatView.chatTextField.text ?? ""
        chatView.sendButton.isEnabled = !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func sendMessage(_ text: String) {
        // 첫 번째 메시지 전송 시 추천 섹션 숨기기
        if messages.isEmpty {
            chatView.hideRecommendSection()
        }
        
        // 사용자 메시지 UI에 추가
        let userMessage = ChatMessageVO(chatId: 0, author: "HUMAN", content: text)
        addMessageToUI(userMessage)
        
        // API 호출
        viewModel.sendMessage(content: text)
        
        // 텍스트 필드 초기화 및 버튼 비활성화
        chatView.chatTextField.text = ""
        chatView.sendButton.isEnabled = false
    }
    
    private func addMessageToUI(_ message: ChatMessageVO) {
        messages.append(message)
        chatView.addMessageToUI(message)
    }

    private func updateRecommendTopics(_ topics: [String]) {
        print("🔄 추천 주제 업데이트: \(topics)")
        
        guard !topics.isEmpty else {
            print("⚠️ 추천 주제가 비어있습니다")
            return
        }

        // ChatView의 recommendTexts 프로퍼티로 간단하게 업데이트
        chatView.recommendTexts = topics
        
        print("✅ 추천 주제 업데이트 완료: \(topics.count)개")
    }
}
