//
//  QuizCollectionViewCell.swift
//  CommonUI
//
//  Created by 박지윤 on 7/12/25.
//

import UIKit
import Domain

final class HomeQuizCell: UICollectionViewCell {
    static let identifier = "HomeQuizCell"
    var quizTitleLabel = UILabel()
    var quizSubtitleLabel = UILabel()
    var startButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initAttribute()
        initUI()
        quizTitleLabel.text = "처음 보는 사람과 인사하기"
        quizSubtitleLabel.text = "인사와 대화의 첫걸음을 배워요"
    }

    private func initAttribute() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
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
            $0.setTitle("시작하기", for: .normal)
            $0.setTitleColor(CommonUIAssets.LMGray1, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 11, weight: .regular)
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
            $0.height.equalTo(30)
            $0.width.equalTo(80)
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with course: CourseVO) {
        quizTitleLabel.text = "처음 보는 사람과 인사하기"
        quizSubtitleLabel.text = "인사와 대화의 첫걸음을 배워요"
    }
}
