//
//  ChatView.swift
//  CommonUI
//
//  Created by 박지윤 on 7/1/25.
//

import Domain
import UIKit
import SnapKit
import RxSwift
import Then
import RxRelay

open class ChatView: UIView {

    public var onSendButtonTapped: ((String) -> Void)?
    public var onEndButtonTapped: (() -> Void)?
    let disposeBag = DisposeBag()

    let titleLabel = UILabel().then {
        $0.text = "AI와 텍스트로 대화하세요"
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
    }

    let subtitleLabel = UILabel().then {
        $0.text = "메세지를 입력하고 전송해보세요"
        $0.textColor = CommonUIAssets.LMGray3
        $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
    }

    let recommendTitleLabel = UILabel().then {
        $0.text = "AI 추천 대화 주제"
        $0.textColor = CommonUIAssets.LMGray1
        $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
    }

    let endButton = UIButton().then {
        $0.setTitle("대화 종료하기", for: .normal)
        $0.setTitleColor(CommonUIAssets.LMGray1, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        $0.backgroundColor = CommonUIAssets.LMRed
        $0.layer.cornerRadius = 10
    }

    public let recommendStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 11
    }

    // 채팅 관련 UI 요소들 추가
    let chatScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = true
        $0.alwaysBounceVertical = true
    }
    
    let chatStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.alignment = .fill
    }

    // 추천 뷰와 라벨을 배열로 관리
    private let recommendViews: [UIView] = (0..<3).map { _ in
        UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 10
            $0.layer.borderWidth = 1
            $0.layer.borderColor = CommonUIAssets.LMGray5?.cgColor
        }
    }
    
    private let recommendLabels: [UILabel] = (0..<3).map { _ in
        UILabel().then {
            $0.textColor = CommonUIAssets.LMGray3
            $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
    }
    
    // 외부에서 접근할 수 있도록 public 프로퍼티 제공
    public var recommendTexts: [String] {
        get { recommendLabels.map { $0.text ?? "" } }
        set {
            for (index, text) in newValue.enumerated() {
                if index < recommendLabels.count {
                    recommendLabels[index].text = text
                    updateRecommendViewHeight(at: index)
                }
            }
        }
    }

    public let chatTextField = UITextField().then {
        $0.placeholder = "메세지를 입력하세요..."
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = CommonUIAssets.LMGray5?.cgColor
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        $0.leftViewMode = .always
    }

    public let sendButton = UIButton().then {
        $0.setImage(CommonUIAssets.IconSend, for: .normal)
        $0.backgroundColor = CommonUIAssets.LMBlue2
        $0.layer.cornerRadius = 22
        $0.isEnabled = false
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initAttribute()
        initUI()
        bindEvents()
    }

    func bindEvents() {
        sendButton.rx.tap
            .withLatestFrom(chatTextField.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] text in
                self?.onSendButtonTapped?(text)
                self?.chatTextField.text = ""
            })
            .disposed(by: disposeBag)
            
        endButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.onEndButtonTapped?()
            })
            .disposed(by: disposeBag)
    }

    func initAttribute() {
        self.backgroundColor = CommonUIAssets.LMOrange4
    }

    func initUI() {
        [titleLabel, subtitleLabel, endButton, recommendTitleLabel, recommendStackView, chatScrollView, chatTextField, sendButton].forEach { self.addSubview($0) }
        
        // 채팅 스택뷰를 스크롤뷰에 추가
        chatScrollView.addSubview(chatStackView)
        
        // 추천 뷰들을 StackView에 추가하고 각각에 라벨 추가
        for (index, (view, label)) in zip(recommendViews, recommendLabels).enumerated() {
            recommendStackView.addArrangedSubview(view)
            view.addSubview(label)
            
            // 초기 뷰 높이 설정 (최소 높이)
            view.snp.makeConstraints { $0.height.equalTo(40) }
            
            // 라벨 레이아웃 설정
            label.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.leading.trailing.equalToSuperview().inset(16)
            }
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(20)
        }

        endButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.height.equalTo(30)
            $0.width.equalTo(82)
            $0.trailing.equalToSuperview().inset(20)
        }

        recommendTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-95)
        }

        recommendStackView.snp.makeConstraints {
            $0.width.equalTo(280)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(recommendTitleLabel.snp.bottom).offset(18)
        }

        // 채팅 스크롤뷰 레이아웃 (초기에는 추천 섹션 아래에 위치)
        chatScrollView.snp.makeConstraints {
            $0.top.equalTo(recommendStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(chatTextField.snp.top).offset(-20)
        }
        
        // 채팅 스택뷰 레이아웃
        chatStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        chatTextField.snp.makeConstraints {
            $0.centerY.equalTo(sendButton)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(44)
            $0.trailing.equalTo(sendButton.snp.leading).offset(-20)
        }

        sendButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
            $0.height.width.equalTo(44)
            $0.trailing.equalToSuperview().inset(20)
        }
    }

    // 추천 섹션 숨기기 메서드
    public func hideRecommendSection() {
        UIView.animate(withDuration: 0.3) {
            self.recommendTitleLabel.alpha = 0
            self.recommendStackView.alpha = 0
        } completion: { _ in
            self.recommendTitleLabel.isHidden = true
            self.recommendStackView.isHidden = true
            
            // 채팅 영역을 위로 확장
            self.chatScrollView.snp.remakeConstraints {
                $0.top.equalTo(self.subtitleLabel.snp.bottom).offset(20)
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.bottom.equalTo(self.chatTextField.snp.top).offset(-20)
            }
            
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
    }
    
    // endButton 숨기기 메서드
    public func hideEndButton() {
        endButton.isHidden = true
    }
    
    // endButton 보이기 메서드
    public func showEndButton() {
        endButton.isHidden = false
    }
    
    // subtitleLabel 텍스트 변경 메서드
    public func updateSubtitleText(_ text: String) {
        subtitleLabel.text = text
    }
    
    // 메시지 추가 메서드
    public func addMessageToUI(_ message: ChatMessageVO) {
        let messageView = createMessageView(message)
        chatStackView.addArrangedSubview(messageView)
        
        // 스크롤을 맨 아래로
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let bottomOffset = CGPoint(
                x: 0,
                y: self.chatScrollView.contentSize.height - self.chatScrollView.bounds.height
            )
            if bottomOffset.y > 0 {
                self.chatScrollView.setContentOffset(bottomOffset, animated: true)
            }
        }
    }
    
    // 메시지 뷰 생성 메서드
    private func createMessageView(_ message: ChatMessageVO) -> UIView {
        let containerView = UIView()
        
        let bubbleView = UIView().then {
            $0.layer.cornerRadius = 16
            $0.backgroundColor = message.author == "HUMAN" ? CommonUIAssets.LMBlue2 : UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        }
        
        let messageLabel = UILabel().then {
            $0.text = message.content
            $0.textColor = message.author == "HUMAN" ? .white : .black
            $0.font = .systemFont(ofSize: 16, weight: .regular)
            $0.numberOfLines = 0
        }
        
        containerView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
        
        // 메시지 정렬 (사용자는 오른쪽, AI는 왼쪽)
        if message.author == "HUMAN" {
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

    // 추천 뷰 높이를 동적으로 업데이트하는 메서드
    private func updateRecommendViewHeight(at index: Int) {
        guard index < recommendLabels.count && index < recommendViews.count else { return }
        
        let label = recommendLabels[index]
        let view = recommendViews[index]
        
        // 라벨의 intrinsic content size를 계산
        let maxWidth: CGFloat = 280 - 32 // recommendStackView width - label insets (16 * 2)
        let size = label.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.infinity))
        
        // 최소 높이 40, 최대 높이 100으로 제한
        let calculatedHeight = max(40, min(100, size.height + 16)) // 16은 상하 패딩
        
        // 기존 높이 constraint 업데이트
        view.snp.updateConstraints { make in
            make.height.equalTo(calculatedHeight)
        }
        
        // 애니메이션과 함께 레이아웃 업데이트
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
