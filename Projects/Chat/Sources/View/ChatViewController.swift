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
                self?.updateRecommendTopics(chat.recommendSubjects)
            })
            .disposed(by: disposeBag)
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
