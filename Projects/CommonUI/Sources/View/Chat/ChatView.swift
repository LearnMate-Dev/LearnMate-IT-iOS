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

    let recommendStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 11
    }

    let recommendTopics = [
        "오늘 기분은 어땠어?",
        "최근에 재미있었던 일은 뭐였어?",
        "요즘 가장 자주 하는 생각은 뭐야?"
    ]

    lazy var recommendViews: [UIView] = recommendTopics.map { topic in
        let view = UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 10
            $0.layer.borderWidth = 1
            $0.layer.borderColor = CommonUIAssets.LMGray5?.cgColor
        }
        
        let label = UILabel().then {
            $0.text = topic
            $0.textColor = CommonUIAssets.LMGray3
            $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        return view
    }

    let chatTextField = UITextField().then {
        $0.placeholder = "메세지를 입력하세요..."
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = CommonUIAssets.LMGray5?.cgColor
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        $0.leftViewMode = .always
    }

    let sendButton = UIButton().then {
        $0.setImage(CommonUIAssets.IconSend, for: .normal)
        $0.backgroundColor = CommonUIAssets.LMBlue2
        $0.layer.cornerRadius = 22
    }

    let disposeBag = DisposeBag()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initAttribute()
        initUI()
        bindEvents()
    }

    func bindEvents() {
    }

    func initAttribute() {
        self.backgroundColor = CommonUIAssets.LMOrange4

    }

    func initUI() {
        [titleLabel, subtitleLabel, endButton, recommendTitleLabel, recommendStackView, chatTextField, sendButton].forEach { self.addSubview($0) }
        
        recommendViews.forEach { recommendStackView.addArrangedSubview($0) }

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

        recommendViews.forEach { $0.snp.makeConstraints { $0.height.equalTo(40) } }

        chatTextField.snp.makeConstraints {
            $0.centerY.equalTo(sendButton)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(44)
            $0.trailing.equalTo(sendButton.snp.leading).offset(-20)
        }

        sendButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-30)
            $0.height.width.equalTo(44)
            $0.trailing.equalToSuperview().inset(20)
        }
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
