//
//  ChatAnalysisController.swift
//  Chat
//
//  Created by 박지윤 on 9/9/25.
//

import UIKit
import CommonUI
import Domain

public class ChatAnalysisController: BaseViewController {

    private let chatAnalysisView = ChatAnalysisView()
    let navigationBar = DefaultNavigationBar(leftImage: nil,
                                             rightImage: CommonUIAssets.IconClose ?? nil,
                                             title: "")

    private var chatDetail: ChatDetailVO

    public init(chatDetail: ChatDetailVO) {
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
}
