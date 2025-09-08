//
//  ChatViewController.swift
//  Chat
//
//  Created by 박지윤 on 7/1/25.
//

import UIKit
import CommonUI

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
}
