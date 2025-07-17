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
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 3
    }
    var progressView = UIView()
    var buttonStackView = UIStackView()
    var restartButton = UIButton()
    var continueButton = UIButton()
    var courseList: CourseVO?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initAttribute()
        initUI()
    }

    public func setCourseList(_ list: CourseVO) {
        self.courseList = list
        courseLabel.text = "한국어 훈련 \(courseList?.courseLv ?? 0)단계"
        progressLabel.text = "진행률 \(courseList?.progress ?? 0)%"
        updateProgress(progress: courseList?.progress ?? 0)
    }

    public func updateProgress(progress: Int) {
        let progressEntireWidth = 344 - 40
        let progressWidth = Int(CGFloat(progress)) / 100 * progressEntireWidth

        progressView.snp.updateConstraints { make in
            make.width.equalTo(progressWidth)
        }

        if progress >= 100 {
            progressView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        } else {
            progressView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        }
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
            $0.textColor = CommonUIAssets.LMGray1
            $0.font = .systemFont(ofSize: 12, weight: .regular)
        }

        progressView = progressView.then {
            $0.backgroundColor = .red
            $0.layer.cornerRadius = 3
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            // TODO: 100% 달성 시 모든 corner에 적용
        }

        buttonStackView = buttonStackView.then {
            $0.distribution = .fillEqually
            $0.spacing = 14
        }

        restartButton = restartButton.then {
            $0.setTitle("다시 시작하기", for: .normal)
            $0.setTitleColor(CommonUIAssets.LMGray1, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
            $0.backgroundColor = .clear
            $0.layer.borderColor = CommonUIAssets.LMOrange1?.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 10
        }

        continueButton = continueButton.then {
            $0.setTitle("이어하기", for: .normal)
            $0.setTitleColor(CommonUIAssets.LMGray1, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
            $0.backgroundColor = CommonUIAssets.LMOrange1
            $0.layer.cornerRadius = 10
        }
    }

    func initUI() {
        [restartButton, continueButton]
            .forEach { buttonStackView.addArrangedSubview($0) }

        [courseLabel, progressLabel, progressEntireView, progressView, buttonStackView]
            .forEach { self.addSubview($0) }

        self.snp.makeConstraints {
            $0.height.equalTo(160)
            $0.width.equalTo(344)
        }

        courseLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(24)
        }

        progressLabel.snp.makeConstraints {
            $0.top.equalTo(courseLabel.snp.bottom).offset(12)
            $0.leading.equalTo(courseLabel.snp.leading)
        }

        progressEntireView.snp.makeConstraints {
            $0.top.equalTo(progressLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(6)
            $0.width.equalToSuperview().inset(20)
        }

        progressView.snp.makeConstraints {
            $0.top.equalTo(progressLabel.snp.bottom).offset(10)
            $0.height.equalTo(6)
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(100)
        }

        buttonStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(38)
        }
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
