//
//  ChatAnalysisViewController.swift
//  Chat
//
//  Created by 박지윤 on 9/9/25.
//

import UIKit
import CommonUI
import Domain
import RxSwift

public class ChatAnalysisViewController: BaseViewController {
    let viewModel: ChatViewModel
    private let chatAnalysisView = ChatAnalysisView()
    let navigationBar = DefaultNavigationBar(leftImage: nil,
                                             rightImage: CommonUIAssets.IconClose ?? nil,
                                             title: "")

    private var chatDetail: ChatDetailVO

    public init(chatViewModel: ChatViewModel, chatDetail: ChatDetailVO) {
        self.viewModel = chatViewModel
        self.chatDetail = chatDetail
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.setupViewProperty(title: chatDetail.chatRoom.title)
        chatAnalysisView.setupAnalysisData(chatDetail.chatList)
        setupActions()
    }

    public override func setupViewProperty() {
        view.backgroundColor = CommonUIAssets.LMOrange4
    }

    public override func setupHierarchy() {
        [navigationBar, chatAnalysisView]
            .forEach { view.addSubview($0) }
    }

    public override func setupLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.centerX.equalToSuperview()
        }

        chatAnalysisView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    private func setupActions() {
        // DefaultNavigationBar의 기본 타겟 제거 후 우리의 커스텀 액션 추가
        navigationBar.rightButton.removeTarget(navigationBar, action: #selector(DefaultNavigationBar.rightButtonTapped), for: .touchUpInside)
        navigationBar.rightButton.addTarget(self, action: #selector(handleRightButtonTapped), for: .touchUpInside)
        
        // SaveButton 액션 설정
        chatAnalysisView.onSaveButtonTapped.subscribe(onNext: { [weak self] in
            self?.handleSaveButtonTapped()
        }).disposed(by: disposeBag)
    }
    
    @objc private func handleRightButtonTapped() {
        showExitConfirmationAlert()
    }
    
    private func handleSaveButtonTapped() {
        // 저장 버튼 클릭 시 루트 뷰컨트롤러로 이동
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func showExitConfirmationAlert() {
        let lmAlert = LMAlert(title: "저장하지 않은 대화는 사라집니다.\n그래도 나가시겠습니까?")
        
        lmAlert.setCancelAction {
            // 아니요 버튼 - 아무것도 하지 않음
        }
        
        lmAlert.setConfirmAction { [weak self] in
            self?.deleteChatAndExit()
        }
        
        lmAlert.show(in: view)
    }
    
    private func deleteChatAndExit() {
        // 대화방 삭제 API 호출
        viewModel.deleteChat()

        // 루트 뷰컨트롤러로 이동
        navigationController?.popToRootViewController(animated: true)
    }
}
