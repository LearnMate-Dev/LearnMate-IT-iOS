//
//  DiaryView.swift
//  CommonUI
//
//  Created by 박지윤 on 7/1/25.
//

import UIKit
import SnapKit
import Then
import RxSwift

open class DiaryView: UIView {
    
    // MARK: UI Components
    private(set) var previousButton = UIButton().then {
        $0.setImage(CommonUIAssets.IconPrevious, for: .normal)
    }

    private(set) var monthLabel = UILabel().then {
        $0.text = ""
        $0.textColor = CommonUIAssets.LMGray1
        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    }

    private(set) var nextButton = UIButton().then {
        $0.setImage(CommonUIAssets.IconNext, for: .normal)
    }

    private(set) var addButton = UIButton().then {
        $0.setImage(CommonUIAssets.IconAdd, for: .normal)
    }

    public var calendarView = CalendarView()
    public let diaryTodayView = DiaryTodayView()

    // MARK: Properties
    private var currentYear: Int
    private var currentMonth: Int

    public var onAddButtonTapped: (() -> Void)?
    public var tapPrevious: ((Int, Int) -> Void)?
    public var tapNext: ((Int, Int) -> Void)?
    let disposeBag = DisposeBag()

    public override init(frame: CGRect) {
        // 현재 날짜로 초기화
        let today = Date()
        let calendar = Calendar.current
        self.currentYear = calendar.component(.year, from: today)
        self.currentMonth = calendar.component(.month, from: today)
        
        super.init(frame: frame)
        configureSubviews()
        makeConstraints()
        bindEvents()
        calendarView.configureSubviews()
        calendarView.makeConstraints()
        setupSampleEmotionData()
        updateMonthButtonTitle()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSampleEmotionData() {
        // 샘플 이모지 데이터 설정 (이미지와 동일하게)
        let sampleEmotions: [Int: String] = [
            1: "😢",  // 우는 얼굴
            7: "😐",  // 무표정한 얼굴
            12: "🥳", // 파티 모자
            13: "😡"  // 화난 얼굴
        ]
        calendarView.setEmotionData(sampleEmotions)
    }
    
    // MARK: Configuration
    func configureSubviews() {
        addButtonEvent()

        addSubview(previousButton)
        addSubview(monthLabel)
        addSubview(nextButton)
        addSubview(addButton)
        addSubview(calendarView)
        addSubview(diaryTodayView)

        backgroundColor = CommonUIAssets.LMOrange4
    }

    // MARK: Layout
    func makeConstraints() {
        monthLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaInsets).inset(13)
            $0.centerX.equalToSuperview()
        }

        previousButton.snp.makeConstraints {
            $0.centerY.equalTo(monthLabel)
            $0.trailing.equalTo(monthLabel.snp.leading).offset(-10)
            $0.height.width.equalTo(monthLabel.snp.height)
        }

        nextButton.snp.makeConstraints {
            $0.centerY.equalTo(monthLabel)
            $0.leading.equalTo(monthLabel.snp.trailing).offset(10)
            $0.height.width.equalTo(monthLabel.snp.height)
        }

        addButton.snp.makeConstraints {
            $0.centerY.equalTo(monthLabel)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.width.equalTo(monthLabel.snp.height)
        }

        calendarView.snp.makeConstraints {
            $0.top.equalTo(monthLabel.snp.bottom).offset(17)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(410)
        }

        diaryTodayView.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(3)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(20)
            $0.height.equalTo(141)
        }
    }

    func bindEvents() {
        addButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.onAddButtonTapped?()
            })
            .disposed(by: disposeBag)
    }

    // MARK: Event
    private func addButtonEvent() {
        previousButton.addTarget(self, action: #selector(handlePreviousButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
    }

    @objc private func handlePreviousButton() {
        if currentMonth == 1 {
            currentYear -= 1
            currentMonth = 12
        } else {
            currentMonth -= 1
        }
        updateMonthButtonTitle()
        
        // 캘린더 월 업데이트
        calendarView.updateMonth(year: currentYear, month: currentMonth)

        tapPrevious?(currentYear, currentMonth)
    }

    @objc private func handleNextButton() {
        if currentMonth == 12 {
            currentYear += 1
            currentMonth = 1
        } else {
            currentMonth += 1
        }
        updateMonthButtonTitle()
        
        // 캘린더 월 업데이트
        calendarView.updateMonth(year: currentYear, month: currentMonth)

        tapNext?(currentYear, currentMonth)
    }

    private func updateMonthButtonTitle() {
        let monthText = "\(currentYear)년 \(currentMonth)월"
        monthLabel.text = monthText
    }
}
