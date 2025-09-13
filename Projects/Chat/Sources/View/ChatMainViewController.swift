//
//  ChatMainViewController.swift
//  Chat
//
//  Created by 박지윤 on 9/10/25.
//

import UIKit
import CommonUI
import RxSwift
import Domain

public class ChatMainViewController: BaseViewController {
    let viewModel: ChatViewModel
    public var onPresentNewChat: (() -> Void)?

    let chatLabel = UILabel().then {
        $0.text = "대화"
        $0.textColor = CommonUIAssets.LMBlack
        $0.font = UIFont.systemFont(ofSize: 30, weight: .bold)
    }

    let chatMainView = ChatMainView()

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
        viewModel.getChatList()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViewProperty()
        setupHierarchy()
        setupLayout()
        bindData()
        bindEvents()
    }

    public override func setupViewProperty() {
        view.backgroundColor = CommonUIAssets.LMOrange4
    }

    public override func setupHierarchy() {
        [chatLabel, chatMainView].forEach { view.addSubview($0) }
    }

    public override func setupDelegate() {
    }

    public override func setupLayout() {
        chatLabel.snp.makeConstraints {
            $0.height.equalTo(34)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.equalToSuperview().inset(20)
        }

        chatMainView.snp.makeConstraints {
            $0.top.equalTo(chatLabel.snp.bottom).offset(10)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }

    private func bindData() {
        viewModel.chatListSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] chatRoomList in
                self?.chatMainView.updateChatList(chatRoomList)
            })
            .disposed(by: disposeBag)
    }

    private func bindEvents() {
        chatMainView.newChatButtonTapped
            .bind { [weak self] in
                self?.presentNewChatView()
            }
            .disposed(by: disposeBag)
    }

    private func presentNewChatView() {
        let chatViewController = ChatViewController(chatViewModel: viewModel)
        chatViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(chatViewController, animated: true)
    }
}
