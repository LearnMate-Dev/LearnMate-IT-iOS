//
//  HomeProgressView.swift
//  CommonUI
//
//  Created by 박지윤 on 7/8/25.
//

import Domain
import UIKit
import SnapKit
import Then

open class HomeProgressView: UIView {
    var courseLabel = UILabel()
    var progressLabel = UILabel()
    let progressEntireView = UIView().then {
        $0.backgroundColor = CommonUIAssets.LMGray5
        $0.layer.cornerRadius = 5
    }
    var progressView = UIView()
    var buttonStackView = UIStackView()
    var restartButton = UIButton()
    var continueButton = UIButton()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initAttribute()
        initUI()
    }

    public func bind(course: CourseVO) {
        courseLabel.text = "한국어 훈련 \(course.courseLv ?? 1)단계"
        progressLabel.text = "진행률: " + "" + "%"
    }

    func initAttribute() {
        self.backgroundColor = CommonUIAssets.LMWhite
        self.layer.borderColor = CommonUIAssets.LMOrange1?.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 12

        courseLabel = courseLabel.then {
            $0.text = "한국어 훈련 1단계"
            $0.textColor = CommonUIAssets.LMBlack
            $0.font = .systemFont(ofSize: 18, weight: .semibold)
        }

        progressLabel = progressLabel.then {
            $0.text = "진행률: 60%"
            $0.textColor = CommonUIAssets.LMGray1
            $0.font = .systemFont(ofSize: 11, weight: .regular)
        }
    }

    func initUI() {
        [restartButton, continueButton]
            .forEach { buttonStackView.addSubview($0) }

        [courseLabel, progressLabel, progressEntireView, progressView, buttonStackView]
            .forEach { self.addSubview($0) }

        self.snp.makeConstraints {
            $0.height.equalTo(151)
            $0.width.equalTo(344)
        }

        courseLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(24)
        }

        progressLabel.snp.makeConstraints {
            $0.top.equalTo(courseLabel.snp.bottom).offset(14)
            $0.leading.equalTo(courseLabel.snp.leading)
        }

        progressEntireView.snp.makeConstraints {
            $0.top.equalTo(progressLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(6)
            $0.width.equalTo(300)
        }
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
