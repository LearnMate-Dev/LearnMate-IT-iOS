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
        $0.layer.cornerRadius = 3
    }
    var progressView = UIView()
    var buttonStackView = UIStackView()
    var restartButton = UIButton()
    var continueButton = UIButton()
    var nextButton = UIButton()
    var previousButton = UIButton()
    public var courseList: [CourseVO] = []
    public var currentCourseIndex: Int = 0
    public var onNextCourseTapped: (() -> Void)?
    public var onPreviousCourseTapped: (() -> Void)?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initAttribute()
        initUI()
        bindActions()
    }
    
    private func bindActions() {
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
    }
    
    @objc private func nextButtonTapped() {
        guard nextButton.isEnabled else { return }
        if currentCourseIndex < courseList.count - 1 {
            currentCourseIndex += 1
            updateCurrentCourse()
            onNextCourseTapped?()
        }
    }
    
    @objc private func previousButtonTapped() {
        guard previousButton.isEnabled else { return }
        if currentCourseIndex > 0 {
            currentCourseIndex -= 1
            updateCurrentCourse()
            onPreviousCourseTapped?()
        }
    }

    public func setCourseList(_ list: [CourseVO]) {
        self.courseList = list
        updateCurrentCourse()
    }
    
    private func updateCurrentCourse() {
        guard currentCourseIndex < courseList.count else { return }
        let currentCourse = courseList[currentCourseIndex]
        courseLabel.text = "한국어 훈련 \(currentCourse.courseLv)단계"
        progressLabel.text = "진행률 \(currentCourse.progress)%"
        updateProgress(progress: currentCourse.progress)
        updateButtonVisibility()
    }
    
    public func updateButtonVisibility() {
        guard currentCourseIndex < courseList.count else {
            nextButton.isEnabled = false
            previousButton.isEnabled = false
            updateButtonAppearance()
            return
        }
        
        let currentCourse = courseList[currentCourseIndex]
        let allStepsSolved = currentCourse.stepList.allSatisfy { $0.stepStatus == "SOLVED" }
        let hasNextCourse = currentCourseIndex < courseList.count - 1
        let hasPreviousCourse = currentCourseIndex > 0
        
        // nextButton: 모든 스텝이 완료되고 다음 코스가 있을 때만 활성화
        nextButton.isEnabled = allStepsSolved && hasNextCourse
        
        // previousButton: 이전 코스가 있을 때만 활성화
        previousButton.isEnabled = hasPreviousCourse
        
        updateButtonAppearance()
    }
    
    private func updateButtonAppearance() {
        // nextButton 스타일 업데이트
        nextButton.backgroundColor = nextButton.isEnabled ? CommonUIAssets.LMOrange1 : CommonUIAssets.LMGray5
        nextButton.tintColor = nextButton.isEnabled ? .white : CommonUIAssets.LMGray3
        
        // previousButton 스타일 업데이트
        previousButton.backgroundColor = previousButton.isEnabled ? CommonUIAssets.LMOrange1 : CommonUIAssets.LMGray5
        previousButton.tintColor = previousButton.isEnabled ? .white : CommonUIAssets.LMGray3
    }

    public func updateProgress(progress: Int) {
        let progressEntireWidth = 344 - 40
        let progressWidth = CGFloat(progress) / 100.0 * CGFloat(progressEntireWidth)

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
            $0.backgroundColor = CommonUIAssets.LMOrange1
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
        
        nextButton = nextButton.then {
            $0.setImage(CommonUIAssets.IconNext, for: .normal)
            $0.backgroundColor = CommonUIAssets.LMOrange1
            $0.layer.cornerRadius = 15
            $0.tintColor = .white
        }
        
        previousButton = previousButton.then {
            $0.setImage(CommonUIAssets.IconPrevious, for: .normal)
            $0.backgroundColor = CommonUIAssets.LMOrange1
            $0.layer.cornerRadius = 15
            $0.tintColor = .white
        }
    }

    func initUI() {
        [restartButton, continueButton]
            .forEach { buttonStackView.addArrangedSubview($0) }

        [courseLabel, progressLabel, progressEntireView, progressView, buttonStackView, nextButton, previousButton]
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
        
        nextButton.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(courseLabel)
        }
        
        previousButton.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.trailing.equalTo(nextButton.snp.leading).offset(-10)
            $0.centerY.equalTo(courseLabel)
        }
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
