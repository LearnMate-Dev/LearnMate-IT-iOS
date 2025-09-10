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
    private var messages: [ChatMessageVO] = []
    
    public init(messages: [ChatMessageVO]) {
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
        chatAnalysisView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
