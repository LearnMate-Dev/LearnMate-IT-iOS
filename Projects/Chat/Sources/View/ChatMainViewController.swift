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
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViewProperty()
        setupHierarchy()
        setupLayout()
        bindData()
        bindActions()
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
    }

    private func bindActions() {
    }
}
