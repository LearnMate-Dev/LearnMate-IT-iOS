//
//  ChatDetailViewController.swift
//  Chat
//
//  Created by 박지윤 on 1/1/25.
//

import UIKit
import CommonUI
import Domain
import RxSwift

public class ChatDetailViewController: BaseViewController {

    let viewModel: ChatViewModel
    private let chatDetailView = ChatDetailView()
    let navigationBar = DefaultNavigationBar(leftImage: CommonUIAssets.IconBack ?? nil,
                                             rightImage: nil,
                                             title: "")

    private var chatRoom: ChatRoomVO
    private var chatDetail: ChatDetailVO?

    public init(chatViewModel: ChatViewModel, chatRoom: ChatRoomVO) {
        self.viewModel = chatViewModel
        self.chatRoom = chatRoom
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.setupViewProperty(title: chatRoom.title)
        setupActions()
        bindData()
        loadChatDetail()
    }

    public override func setupViewProperty() {
        view.backgroundColor = CommonUIAssets.LMOrange4
    }

    public override func setupHierarchy() {
        [navigationBar, chatDetailView]
            .forEach { view.addSubview($0) }
    }

    public override func setupLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.centerX.equalToSuperview()
        }

        chatDetailView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    private func setupActions() {
        // LeftButton 액션 (뒤로 가기)
//        navigationBar.leftButton.removeTarget(navigationBar, action: #selector(DefaultNavigationBar.leftButtonTapped), for: .touchUpInside)
//        navigationBar.leftButton.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
    }
    
    private func bindData() {
        viewModel.chatDetailSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (chatDetail: ChatDetailVO) in
                self?.updateChatDetail(chatDetail)
            })
            .disposed(by: disposeBag)
    }

    private func loadChatDetail() {
        viewModel.getChatDetail(chatRoomId: chatRoom.chatRoomId)
    }
    
    @objc private func handleBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    public func updateChatDetail(_ chatDetail: ChatDetailVO) {
        self.chatDetail = chatDetail
        chatDetailView.setupDetailData(chatDetail.chatList)
    }
}
