//
//  QuizView.swift
//  CommonUI
//
//  Created by 박지윤 on 7/13/25.
//

import Domain
import UIKit
import SnapKit
import RxSwift
import Then

open class QuizView: UIView {
    var situationView = UIView()
    var situationLabel = UILabel()
    var questionView = UIView()
    var questionLabel = UILabel()

    public enum ChatType {
        case situation
        case question
    }

    public init(text: String, type: ChatType) {
        super.init(frame: .zero)
        initAttribute(type: type)
        initUI(type: type)
        bindDatas(text: text, type: type)
    }

    public func bind(course: CourseVO) {
    }

    func bindDatas(text: String, type: ChatType) {
        switch type {
        case .situation:
            situationLabel.text = text
        case .question:
            questionLabel.text = text
        }
    }

    func initAttribute(type: ChatType) {
        switch type {
        case .situation:
            situationView = situationView.then {
                $0.backgroundColor = CommonUIAssets.LMGray6
                $0.layer.cornerRadius = 12
            }

            situationLabel = situationLabel.then {
                $0.textColor = CommonUIAssets.LMGray1
                $0.textAlignment = .center
                $0.font = .systemFont(ofSize: 13, weight: .regular)
                $0.numberOfLines = 0
                $0.setContentHuggingPriority(.required, for: .vertical)
                $0.setContentCompressionResistancePriority(.required, for: .vertical)
            }
        case .question:
            questionView = questionView.then {
                $0.backgroundColor = CommonUIAssets.LMBlue2
                $0.layer.cornerRadius = 12
            }

            questionLabel = questionLabel.then {
                $0.textColor = CommonUIAssets.LMGray1
                $0.font = .systemFont(ofSize: 14, weight: .regular)
                $0.numberOfLines = 0
                $0.setContentHuggingPriority(.required, for: .vertical)
                $0.setContentCompressionResistancePriority(.required, for: .vertical)
            }
        }
    }

    func initUI(type: ChatType) {
        switch type {
        case .situation:
            self.addSubview(situationView)
            situationView.addSubview(situationLabel)

            situationView.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.centerX.equalToSuperview()
                $0.width.lessThanOrEqualToSuperview().multipliedBy(0.8)
            }

            situationLabel.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview().inset(20)
                $0.verticalEdges.equalToSuperview().inset(14)
            }
        case .question:
            self.addSubview(questionView)
            questionView.addSubview(questionLabel)

            questionView.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.leading.equalToSuperview().inset(20)
                $0.width.lessThanOrEqualToSuperview().multipliedBy(0.7)
            }
            
            questionLabel.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview().inset(16)
                $0.verticalEdges.equalToSuperview().inset(12)
            }
        }
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

