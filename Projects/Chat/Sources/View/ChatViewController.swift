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
    
    private let loadingView = ChatAnalysisLoadingView()

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
        view.addSubview(loadingView)
    }

    public override func setupDelegate() {
    }

    public override func setupLayout() {
        chatView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // 초기에는 로딩 화면 숨김
        loadingView.isHidden = true
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
        
        chatView.onEndButtonTapped = { [weak self] in
            self?.showAnalysisLoading()
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
    
    private func showAnalysisLoading() {
        print("🔄 대화 분석 시작")
        
        // 로딩 화면 표시
        loadingView.isHidden = false
        loadingView.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            self.loadingView.alpha = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.hideAnalysisLoading()
        }
    }
    
    private func hideAnalysisLoading() {
        print("✅ 대화 분석 완료")
        
        UIView.animate(withDuration: 0.3, animations: {
            self.loadingView.alpha = 0
        }) { _ in
            self.loadingView.isHidden = true
            // 여기서 분석 결과 화면으로 이동하거나 다른 액션 수행
            self.navigateToAnalysisResult()
        }
    }
    
    private func navigateToAnalysisResult() {
        print("📊 분석 결과 화면으로 이동")
        
        let analysisController = ChatAnalysisController(messages: messages)
        analysisController.modalPresentationStyle = .fullScreen
        
        present(analysisController, animated: true)
    }

    private func updateRecommendTopics(_ topics: [String]) {
        print("🔄 추천 주제 업데이트: \(topics)")
        
        guard !topics.isEmpty else {
            print("⚠️ 추천 주제가 비어있습니다")
            return
        }

        chatView.recommendTexts = topics
        
        print("✅ 추천 주제 업데이트 완료: \(topics.count)개")
    }
}
