//
//  AnswerView.swift
//  CommonUI
//
//  Created by 박지윤 on 7/15/25.
//

import Domain
import UIKit
import SnapKit
import RxSwift
import Then

open class AnswerView: UIView {
    var correctView = UIView()
    var correctLabel = UILabel()
    var wrongView = UIView()
    var wrongLabel = UILabel()

    public enum AnswerType {
        case correct
        case wrong
    }

    public init(text: String, type: AnswerType) {
        super.init(frame: .zero)
        initAttribute(type: type)
        initUI(type: type)
        bindDatas(text: text, type: type)
    }

    public func bind(course: CourseVO) {
    }

    public func bindDatas(text: String, type: AnswerType) {
        switch type {
        case .correct:
            correctLabel.text = text
        case .wrong:
            wrongLabel.text = text
        }
    }

    func initAttribute(type: AnswerType) {
        switch type {
        case .correct:
            correctView = correctView.then {
                $0.backgroundColor = CommonUIAssets.LMGreen
                $0.layer.cornerRadius = 12
            }

            correctLabel = correctLabel.then {
                $0.textColor = CommonUIAssets.LMGray1
                $0.textAlignment = .left
                $0.font = .systemFont(ofSize: 13, weight: .regular)
                $0.numberOfLines = 0
                $0.setContentHuggingPriority(.required, for: .vertical)
                $0.setContentCompressionResistancePriority(.required, for: .vertical)
            }
        case .wrong:
            wrongView = wrongView.then {
                $0.backgroundColor = CommonUIAssets.LMRed
                $0.layer.cornerRadius = 12
            }

            wrongLabel = wrongLabel.then {
                $0.textColor = CommonUIAssets.LMGray1
                $0.textAlignment = .left
                $0.font = .systemFont(ofSize: 14, weight: .regular)
                $0.numberOfLines = 0
                $0.setContentHuggingPriority(.required, for: .vertical)
                $0.setContentCompressionResistancePriority(.required, for: .vertical)
            }
        }
    }

    func initUI(type: AnswerType) {
        switch type {
        case .correct:
            self.addSubview(correctView)
            correctView.addSubview(correctLabel)

            correctView.snp.makeConstraints {
                $0.verticalEdges.equalToSuperview()
                $0.leading.equalToSuperview().inset(20)
            }

            correctLabel.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview().inset(16)
                $0.verticalEdges.equalToSuperview().inset(12)
            }
        case .wrong:
            self.addSubview(wrongView)
            wrongView.addSubview(wrongLabel)

            wrongView.snp.makeConstraints {
                $0.verticalEdges.equalToSuperview()
                $0.leading.equalToSuperview().inset(20)
            }

            wrongLabel.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview().inset(16)
                $0.verticalEdges.equalToSuperview().inset(12)
            }
        }
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
