//
//  ChatDetailView.swift
//  CommonUI
//
//  Created by 박지윤 on 1/1/25.
//

import UIKit
import SnapKit
import Then
import Domain
import RxSwift
import RxRelay

open class ChatDetailView: UIView {

    let disposeBag = DisposeBag()

    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = true
        $0.alwaysBounceVertical = true
    }
    
    private let contentView = UIView()
    
    private let analysisStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.alignment = .fill
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initAttribute()
        setupUI()
        setupConstraints()
        bindEvents()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initAttribute() {

    }

    private func setupUI() {
        backgroundColor = CommonUIAssets.LMOrange4
        
        [scrollView].forEach { addSubview($0) }
        [contentView].forEach { scrollView.addSubview($0) }
        [analysisStackView].forEach { contentView.addSubview($0) }
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        analysisStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
    }

    private func bindEvents() {
        // 저장 버튼 제거로 인한 이벤트 바인딩 제거
    }

    public func setupDetailData(_ chatList: [ChatListVO]) {
        // 기존 뷰들 제거
        analysisStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 각 메시지를 UI로 변환
        for (index, chat) in chatList.enumerated() {
            let messageView = createMessageView(chat: chat, index: index)
            analysisStackView.addArrangedSubview(messageView)
        }
        
        // 마지막에 여백 추가
        let spacerView = UIView()
        spacerView.snp.makeConstraints { $0.height.equalTo(20) }
        analysisStackView.addArrangedSubview(spacerView)
    }
    
    private func createMessageView(chat: ChatListVO, index: Int) -> UIView {
        let containerView = UIView()
        
        // 말풍선 배경
        let bubbleView = UIView().then {
            $0.backgroundColor = chat.author == 0 ? UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0) : CommonUIAssets.LMBlue2
            $0.layer.cornerRadius = 16
        }
        
        // 메시지 내용
        let contentLabel = UILabel().then {
            $0.font = .systemFont(ofSize: 16, weight: .regular)
            $0.textColor = chat.author == 0 ? .black : .white
            $0.text = chat.content
            $0.numberOfLines = 0
        }
        
        containerView.addSubview(bubbleView)
        bubbleView.addSubview(contentLabel)
        
        // 메시지 정렬 (사용자는 오른쪽, AI는 왼쪽)
        if chat.author == 0 {
            // AI 메시지 (왼쪽 정렬)
            bubbleView.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.leading.equalToSuperview()
                $0.width.lessThanOrEqualTo(250)
            }
        } else {
            // 사용자 메시지 (오른쪽 정렬)
            bubbleView.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.trailing.equalToSuperview()
                $0.width.lessThanOrEqualTo(250)
            }
        }
        
        contentLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }
        
        // 사용자 메시지에 comment 추가
        if chat.author != 0, let comment = chat.comment, !comment.isEmpty {
            let commentView = createCommentView(comment: comment)
            containerView.addSubview(commentView)
            
            commentView.snp.makeConstraints {
                $0.top.equalTo(bubbleView.snp.bottom).offset(8)
                $0.trailing.equalToSuperview()
                $0.width.lessThanOrEqualTo(250)
                $0.bottom.equalToSuperview()
            }
            
            // bubbleView의 bottom constraint 수정
            bubbleView.snp.remakeConstraints {
                $0.top.equalToSuperview()
                $0.trailing.equalToSuperview()
                $0.width.lessThanOrEqualTo(250)
                $0.bottom.equalTo(commentView.snp.top).offset(-8)
            }
        }
        
        return containerView
    }
    
    private func createCommentView(comment: String) -> UIView {
        let commentContainer = UIView().then {
            $0.backgroundColor = UIColor.systemGray6
            $0.layer.cornerRadius = 12
        }
        
        let commentLabel = UILabel().then {
            $0.font = .systemFont(ofSize: 14, weight: .regular)
            $0.textColor = .darkGray
            $0.text = comment
            $0.numberOfLines = 0
        }
        
        commentContainer.addSubview(commentLabel)
        
        commentLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }
        
        return commentContainer
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "yyyy.MM.dd HH:mm"
            return displayFormatter.string(from: date)
        }
        
        return dateString
    }
}
