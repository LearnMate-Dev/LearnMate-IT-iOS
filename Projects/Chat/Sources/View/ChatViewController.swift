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

    let navigationBar = DefaultNavigationBar(leftImage: CommonUIAssets.IconBack ?? nil,
                                             rightImage: nil,
                                             title: nil)

    private var messages: [ChatMessageVO] = []
    private var hasStartedConversation = false
    
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
        
        // 초기에 endButton 숨기기
        chatView.hideEndButton()
    }

    public override func setupViewProperty() {
        view.backgroundColor = CommonUIAssets.LMOrange4
    }

    public override func setupHierarchy() {
        [navigationBar, chatView, loadingView]
            .forEach { view.addSubview($0) }
    }

    public override func setupDelegate() {
    }

    public override func setupLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.centerX.equalToSuperview()
        }

        chatView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        navigationBar.isHidden = false
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
        
        viewModel.analysisResultSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] analysisResult in
                self?.presentAnalysisController(with: analysisResult)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindActions() {
        chatView.onSendButtonTapped = { [weak self] message in
            self?.sendMessage(message)
        }
        
        chatView.onEndButtonTapped = { [weak self] in
            self?.showAnalysisLoading()
            self?.viewModel.postChatAnalysis()
        }
        
        // DefaultNavigationBar의 기본 타겟 제거 후 우리의 커스텀 액션 추가
        navigationBar.leftButton.removeTarget(navigationBar, action: #selector(DefaultNavigationBar.leftButtonTapped), for: .touchUpInside)
        navigationBar.leftButton.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
    }
    
    private func setupTextFieldActions() {
        chatView.chatTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    @objc private func textFieldDidChange() {
        let text = chatView.chatTextField.text ?? ""
        chatView.sendButton.isEnabled = !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func sendMessage(_ text: String) {
        // 첫 번째 메시지 전송 시 추천 섹션 숨기기 및 endButton 보이기
        if messages.isEmpty {
            hasStartedConversation = true
            chatView.hideRecommendSection()
            chatView.showEndButton()
            chatView.updateSubtitleText("대화를 종료하면 분석 결과를 제공해요")
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
        navigationBar.isHidden = true
        
        UIView.animate(withDuration: 0.3) {
            self.loadingView.alpha = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.hideAnalysisLoading()
        }
    }

    private func hideAnalysisLoading() {
        UIView.animate(withDuration: 0.3, animations: {
            self.loadingView.alpha = 0
        }) { _ in
            self.loadingView.isHidden = true
        }
    }
    
    private func navigateToAnalysisResult() {
        print("📊 분석 결과 화면으로 이동")
        
        // 임시 ChatDetailVO 생성 (빈 데이터로)
        let emptyChatDetail = ChatDetailVO(
            chatRoom: ChatRoomVO(chatRoomId: 0, title: "대화 분석", createdAt: ""),
            chatList: []
        )
        let analysisController = ChatAnalysisViewController(chatViewModel: viewModel,
                                                        chatDetail: emptyChatDetail)
        analysisController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        
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

    private func presentAnalysisController(with analysisResult: ChatDetailVO) {
        let analysisController = ChatAnalysisViewController(chatViewModel: viewModel,
                                                        chatDetail: analysisResult)
        analysisController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(analysisController, animated: true)
    }
    
    @objc private func handleBackButtonTapped() {
        if hasStartedConversation {
            showEndConversationAlert()
        } else {
            // 대화가 시작되지 않았다면 바로 뒤로 가기
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func showEndConversationAlert() {
        let lmAlert = LMAlert(title: "대화를 종료하시겠습니까?")
        
        lmAlert.setCancelAction {
            // 아니요 버튼 - 아무것도 하지 않음
        }
        
        lmAlert.setConfirmAction { [weak self] in
            self?.endConversationAndGoBack()
        }
        
        lmAlert.show(in: view)
    }
    
    private func endConversationAndGoBack() {
        // 대화방 삭제 API 호출
        viewModel.deleteChat()
        
        // 이전 화면으로 이동
        navigationController?.popViewController(animated: true)
    }
}
