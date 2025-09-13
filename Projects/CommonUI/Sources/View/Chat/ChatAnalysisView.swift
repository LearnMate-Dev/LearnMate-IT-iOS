//
//  ChatAnalysisView.swift
//  CommonUI
//
//  Created by 박지윤 on 9/9/25.
//

import UIKit
import SnapKit
import Then
import Domain

open class ChatAnalysisView: UIView {
    
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
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = CommonUIAssets.LMOrange4
        
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(analysisStackView)

        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        analysisStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }

    public func setupAnalysisData(_ messages: [ChatListVO]) {
        analysisStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for message in messages {
            let analysisView = createAnalysisItemView(from: message)
            analysisStackView.addArrangedSubview(analysisView)
        }
    }

    private func createAnalysisItemView(from message: ChatListVO) -> UIView {
        let containerView = UIView()
        
        // 메시지 뷰
        let author = message.author == 1 ? "HUMAN" : "AI"
        let messageView = createMessageBubble(message.content, author: author)
        containerView.addSubview(messageView)
        
        messageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        // comment가 있는 경우 피드백 뷰 추가 (사용자 메시지에만)
        if let comment = message.comment, !comment.isEmpty, message.author == 1 {
            let feedback = Feedback(
                text: comment,
                suggestion: nil
            )
            let feedbackView = createFeedbackBubble(feedback)
            containerView.addSubview(feedbackView)
            
            feedbackView.snp.makeConstraints {
                $0.top.equalTo(messageView.snp.bottom).offset(8)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
        } else {
            messageView.snp.makeConstraints {
                $0.bottom.equalToSuperview()
            }
        }
        
        return containerView
    }
    
    private func createMessageBubble(_ text: String, author: String) -> UIView {
        let containerView = UIView()
        
        let bubbleView = UIView().then {
            $0.layer.cornerRadius = 16
            $0.backgroundColor = author == "HUMAN" ? CommonUIAssets.LMBlue2 : UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        }
        
        let messageLabel = UILabel().then {
            $0.text = text
            $0.textColor = author == "HUMAN" ? .white : .black
            $0.font = .systemFont(ofSize: 16, weight: .regular)
            $0.numberOfLines = 0
        }
        
        containerView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
        
        // 메시지 정렬 (사용자는 오른쪽, AI는 왼쪽)
        if author == "HUMAN" {
            bubbleView.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.trailing.equalToSuperview()
                $0.width.lessThanOrEqualTo(250)
            }
        } else {
            bubbleView.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.leading.equalToSuperview()
                $0.width.lessThanOrEqualTo(250)
            }
        }
        
        messageLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }
        
        return containerView
    }
    
    private func createFeedbackBubble(_ feedback: Feedback) -> UIView {
        let containerView = UIView()
        
        let bubbleView = UIView().then {
            $0.layer.cornerRadius = 16
            $0.backgroundColor = UIColor(red: 0.9, green: 0.95, blue: 1.0, alpha: 1.0) // 연한 파란색
        }
        
        let feedbackLabel = UILabel().then {
            $0.text = feedback.text
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 14, weight: .regular)
            $0.numberOfLines = 0
        }
        
        containerView.addSubview(bubbleView)
        bubbleView.addSubview(feedbackLabel)
        
        // 피드백은 오른쪽 정렬
        bubbleView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.width.lessThanOrEqualTo(280)
        }
        
        feedbackLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }
        
        // 제안이 있는 경우 추가
        if let suggestion = feedback.suggestion {
            let suggestionLabel = UILabel().then {
                $0.text = suggestion
                $0.textColor = .black
                $0.font = .systemFont(ofSize: 13, weight: .regular)
                $0.numberOfLines = 0
            }
            
            bubbleView.addSubview(suggestionLabel)
            
            suggestionLabel.snp.makeConstraints {
                $0.leading.trailing.equalTo(feedbackLabel)
                $0.top.equalTo(feedbackLabel.snp.bottom).offset(8)
                $0.bottom.equalToSuperview().offset(-12)
            }
        }
        
        return containerView
    }
}

struct AnalysisItem {
    let message: String
    let author: String
    let feedback: Feedback?
}

struct Feedback {
    let text: String
    let suggestion: String?
}
