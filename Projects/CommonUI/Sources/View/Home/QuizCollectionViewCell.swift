//
//  QuizCollectionViewCell.swift
//  CommonUI
//
//  Created by 박지윤 on 7/12/25.
//

import UIKit
import RxSwift
import RxCocoa
import Domain

final class HomeQuizCell: UICollectionViewCell {
    static let identifier = "HomeQuizCell"
    var quizTitleLabel = UILabel()
    var quizSubtitleLabel = UILabel()
    var startButton = UIButton()

    var disposeBag = DisposeBag()
    let onStartButtonTapped = PublishSubject<Void>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initAttribute()
        initUI()
        bindActions()
        quizTitleLabel.text = "처음 보는 사람과 인사하기"
        quizSubtitleLabel.text = "인사와 대화의 첫걸음을 배워요"
    }

    private func initAttribute() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = CommonUIAssets.LMOrange1?.cgColor

        quizTitleLabel = quizTitleLabel.then {
            $0.textColor = CommonUIAssets.LMBlack
            $0.font = .systemFont(ofSize: 15, weight: .regular)
        }

        quizSubtitleLabel = quizSubtitleLabel.then {
            $0.textColor = CommonUIAssets.LMGray3
            $0.font = .systemFont(ofSize: 12, weight: .regular)
        }

        startButton = startButton.then {
            var config = UIButton.Configuration.plain()
            config.image = CommonUIAssets.IconPlay
            config.imagePlacement = .trailing
            config.imagePadding = 8
            config.baseForegroundColor = CommonUIAssets.LMGray1
            config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10)

            let title = "시작하기"
            let attributedTitle = AttributedString(title, attributes: AttributeContainer([
                .font: UIFont.systemFont(ofSize: 12, weight: .regular)
            ]))
            config.attributedTitle = attributedTitle

            $0.configuration = config
            $0.layer.borderWidth = 1
            $0.layer.borderColor = CommonUIAssets.LMOrange1?.cgColor
            $0.layer.cornerRadius = 10
        }
    }

    private func initUI() {
        [quizTitleLabel, quizSubtitleLabel, startButton]
            .forEach { contentView.addSubview($0) }
        
        contentView.snp.makeConstraints {
            $0.height.equalTo(83)
            $0.width.horizontalEdges.equalToSuperview()
        }
        
        quizTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(20)
        }
        
        quizSubtitleLabel.snp.makeConstraints {
            $0.top.equalTo(quizTitleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(20)
        }
        
        startButton.snp.makeConstraints {
            $0.height.equalTo(35)
            $0.width.equalTo(90)
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with step: StepVO) {
        quizTitleLabel.text = step.stepTitle
        quizSubtitleLabel.text = step.stepDescription
        
        // stepStatus에 따라 버튼 텍스트 변경
        let buttonTitle = step.stepStatus == "SOLVED" ? "완료" : "시작하기"
        updateButtonTitle(buttonTitle)
    }
    
    private func updateButtonTitle(_ title: String) {
        var config = startButton.configuration ?? UIButton.Configuration.plain()
        
        if title == "완료" {
            config.image = nil
            var background = UIBackgroundConfiguration.clear()
            background.backgroundColor = CommonUIAssets.LMOrange3
            background.cornerRadius = 10
            config.background = background
            let attributedTitle = AttributedString(title, attributes: AttributeContainer([
                .font: UIFont.systemFont(ofSize: 12, weight: .regular),
                .foregroundColor: CommonUIAssets.LMGray3 ?? UIColor.black
            ]))
            config.attributedTitle = attributedTitle
            config.baseForegroundColor = .white
            startButton.layer.borderWidth = 0
            startButton.layer.borderColor = UIColor.clear.cgColor
            startButton.isEnabled = false
            startButton.isUserInteractionEnabled = false
        } else {
            config.image = CommonUIAssets.IconPlay
            var background = UIBackgroundConfiguration.clear()
            background.cornerRadius = 10
            config.background = background
            let attributedTitle = AttributedString(title, attributes: AttributeContainer([
                .font: UIFont.systemFont(ofSize: 12, weight: .regular),
                .foregroundColor: CommonUIAssets.LMGray3 ?? .gray
            ]))
            config.attributedTitle = attributedTitle
            config.baseForegroundColor = CommonUIAssets.LMGray3
            startButton.layer.borderWidth = 1
            startButton.layer.borderColor = CommonUIAssets.LMOrange1?.cgColor
            startButton.isEnabled = true
            startButton.isUserInteractionEnabled = true
        }
        
        startButton.configuration = config
    }

    public func bindActions() {
        startButton.rx.tap
            .bind(to: onStartButtonTapped)
            .disposed(by: disposeBag)
    }
}
