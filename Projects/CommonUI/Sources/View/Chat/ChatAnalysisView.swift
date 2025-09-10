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
    
    private let titleLabel = UILabel().then {
        $0.text = "대화 분석"
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        $0.textAlignment = .center
    }
    
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
        
        [scrollView].forEach { addSubview($0) }
        [contentView].forEach { scrollView.addSubview($0) }
        [titleLabel, analysisStackView].forEach { contentView.addSubview($0) }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        analysisStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
    
    public func setupAnalysisData(_ messages: [ChatMessageVO]) {
        // 기존 뷰들 제거
        analysisStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 샘플 분석 데이터 (실제로는 API에서 받아온 데이터 사용)
        let analysisData = createSampleAnalysisData()
        
        for item in analysisData {
            let analysisView = createAnalysisItemView(item)
            analysisStackView.addArrangedSubview(analysisView)
        }
    }
    
    private func createSampleAnalysisData() -> [AnalysisItem] {
        return [
            AnalysisItem(
                message: "오늘 힘든 일 없었어?",
                author: "HUMAN",
                feedback: Feedback(
                    type: .positive,
                    icon: "✓",
                    text: "좋은 표현이에요! �� 상대방의 하루를 살펴보려는 따뜻한 표현이에요.",
                    suggestion: nil
                )
            ),
            AnalysisItem(
                message: "오늘 배운 수업이 어려워서 조금 힘들었어",
                author: "AI",
                feedback: nil
            ),
            AnalysisItem(
                message: "그런 일로 왜 그래?",
                author: "HUMAN",
                feedback: Feedback(
                    type: .negative,
                    icon: "!",
                    text: "고치면 더 좋은 표현이에요 이 말은 상대방의 감정을 가볍게 여기는 것 처럼 들릴 수 있어요.",
                    suggestion: "이렇게 말하는 건 어떨까요? \"그랬구나. 속상했겠다. 괜찮아?\" 공감하는 말로 시작하면 상대방이 더 편안해질 수 있어요."
                )
            ),
            AnalysisItem(
                message: "내 맘대로 되지 않아서 그랬던 것 같아",
                author: "AI",
                feedback: nil
            )
        ]
    }
    
    private func createAnalysisItemView(_ item: AnalysisItem) -> UIView {
        let containerView = UIView()
        
        // 메시지 뷰
        let messageView = createMessageBubble(item.message, author: item.author)
        containerView.addSubview(messageView)
        
        messageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        // 피드백이 있는 경우 피드백 뷰 추가
        if let feedback = item.feedback {
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
            $0.backgroundColor = feedback.type == .positive ?
                UIColor(red: 0.8, green: 1.0, blue: 0.8, alpha: 1.0) : // 연두색
                UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0)   // 연한 빨간색
        }
        
        let iconLabel = UILabel().then {
            $0.text = feedback.icon
            $0.textColor = feedback.type == .positive ? .green : .red
            $0.font = .systemFont(ofSize: 16, weight: .bold)
        }
        
        let feedbackLabel = UILabel().then {
            $0.text = feedback.text
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 14, weight: .regular)
            $0.numberOfLines = 0
        }
        
        containerView.addSubview(bubbleView)
        bubbleView.addSubview(iconLabel)
        bubbleView.addSubview(feedbackLabel)
        
        // 피드백은 오른쪽 정렬
        bubbleView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.width.lessThanOrEqualTo(280)
        }
        
        iconLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.top.equalToSuperview().offset(12)
        }
        
        feedbackLabel.snp.makeConstraints {
            $0.leading.equalTo(iconLabel.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-12)
            $0.top.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-12)
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
                $0.leading.equalTo(feedbackLabel.snp.leading)
                $0.trailing.equalTo(feedbackLabel.snp.trailing)
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
    enum FeedbackType {
        case positive
        case negative
    }
    
    let type: FeedbackType
    let icon: String
    let text: String
    let suggestion: String?
}
