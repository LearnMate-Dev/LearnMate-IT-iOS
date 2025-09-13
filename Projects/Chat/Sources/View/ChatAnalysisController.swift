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
                                             rightImage: nil,
                                             title: "대화 분석",
                                             isRightButtonHidden: true)

    private var messages: [ChatListVO] = []
    
    public init(messages: [ChatListVO]) {
        self.messages = messages
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        chatAnalysisView.setupAnalysisData(messages)
    }
    
    public override func setupViewProperty() {
        view.backgroundColor = CommonUIAssets.LMOrange4
    }
    
    public override func setupHierarchy() {
        view.addSubview(chatAnalysisView)
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
