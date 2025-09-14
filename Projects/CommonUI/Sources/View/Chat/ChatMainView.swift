//
//  ChatMainView.swift
//  CommonUI
//
//  Created by 박지윤 on 7/2/25.
//

import UIKit
import SnapKit
import Then
import Domain
import RxRelay
import RxSwift

public class ChatMainView: UIView {

    public let newChatButtonTapped = PublishRelay<Void>()
    public let chatCellTapped = PublishRelay<ChatRoomVO>()
    let disposeBag = DisposeBag()

    private let emptyStateContainer = UIView()

    private let emptyIconImageView = UIImageView().then {
        $0.image = CommonUIAssets.IconMessage
        $0.contentMode = .scaleAspectFit
    }

    private let emptyMessageLabel = UILabel().then {
        $0.text = "저장된 대화가 없어요\n새로운 대화를 시작해보세요"
        $0.textColor = CommonUIAssets.LMGray3
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }

    private let chatListContainer = UIView()

    private let chatListTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
    }

    private var newChatButton = LMButton(textColor: CommonUIAssets.LMBlack,
                                         bgColor: CommonUIAssets.LMOrange1)

    private var isShowingEmptyState = true
    private var chatRoomList: [ChatRoomVO] = []
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initAttribute()
        setupUI()
        setupTableView()
        bindEvents()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initAttribute() {
        newChatButton = newChatButton.then {
            $0.setTitle("새 대화 시작하기", for: .normal)
            $0.setImage(CommonUIAssets.IconEdit?
                .resize(to: CGSize(width: 20, height: 20)), for: .normal)
            $0.semanticContentAttribute = .forceLeftToRight
            $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 6)
        }
    }

    private func setupUI() {
        backgroundColor = .clear

        [emptyStateContainer, chatListContainer, newChatButton].forEach { addSubview($0) }

        [emptyIconImageView, emptyMessageLabel].forEach { emptyStateContainer.addSubview($0) }
        [chatListTableView].forEach { chatListContainer.addSubview($0) }

        setupConstraints()
        showEmptyState()
    }

    private func setupConstraints() {
        emptyStateContainer.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-50)
            $0.leading.trailing.equalToSuperview().inset(40)
        }

        emptyIconImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(60)
        }

        emptyMessageLabel.snp.makeConstraints {
            $0.top.equalTo(emptyIconImageView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        chatListContainer.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(newChatButton.snp.top).offset(-20)
        }

        chatListTableView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        newChatButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
        }
    }

    private func bindEvents() {
        newChatButton.rx.tap
            .bind(to: newChatButtonTapped)
            .disposed(by: disposeBag)
    }

    private func setupTableView() {
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        chatListTableView.register(ChatListCell.self, forCellReuseIdentifier: "ChatListCell")
    }

    public func showEmptyState() {
        isShowingEmptyState = true
        emptyStateContainer.isHidden = false
        chatListContainer.isHidden = true
    }

    public func showChatList() {
        isShowingEmptyState = false
        emptyStateContainer.isHidden = true
        chatListContainer.isHidden = false
        chatListTableView.reloadData()
    }

    public func updateChatList(_ chatRoomListVO: ChatRoomListVO) {
        self.chatRoomList = chatRoomListVO.chatRoomList
        
        if chatRoomListVO.chatRoomList.isEmpty {
            showEmptyState()
        } else {
            showChatList()
        }
    }
}

extension ChatMainView: UITableViewDataSource, UITableViewDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return chatRoomList.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListCell", for: indexPath) as! ChatListCell
        
        let chatRoom = chatRoomList[indexPath.section]
        cell.configure(title: chatRoom.title, date: chatRoom.createdAt)
        
        return cell
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 5
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chatRoom = chatRoomList[indexPath.section]
        chatCellTapped.accept(chatRoom)
    }
}
