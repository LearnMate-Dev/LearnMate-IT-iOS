//
//  DiaryView.swift
//  CommonUI
//
//  Created by 박지윤 on 7/1/25.
//

import UIKit
import SnapKit
import Then

open class DiaryView: UIView {
    
    // MARK: UI Components
    private(set) var previousButton = UIButton().then {
        $0.setImage(CommonUIAssets.IconPrevious, for: .normal)
    }

    private(set) var monthLabel = UILabel().then {
        $0.text = "2025년 09월"
        $0.textColor = CommonUIAssets.LMGray1
        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    }

    private(set) var nextButton = UIButton().then {
        $0.setImage(CommonUIAssets.IconNext, for: .normal)
    }

    private(set) var addButton = UIButton().then {
        $0.setImage(CommonUIAssets.IconAdd, for: .normal)
    }

//    private(set) var calendarView = FSCalendarView()
    let diaryTodayView = DiaryTodayView()

    // MARK: Properties
    private var currentYear = 2025
    private var currentMonth = 09

    var tapAdd: (() -> Void)?
    var tapPrevious: ((Int, Int) -> Void)?
    var tapNext: ((Int, Int) -> Void)?

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
            $0.height.equalTo(550)
        }

        diaryTodayView.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(3)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(20)
        }
    }

    // MARK: Event
    private func addButtonEvent() {
        addButton.addTarget(self, action: #selector(handleDiaryAddButton), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(handlePreviousButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
    }

    @objc
    private func handleDiaryAddButton() {
        tapAdd?()
    }

    @objc private func handlePreviousButton() {
        if currentMonth == 1 {
            currentYear -= 1
            currentMonth = 12
        } else {
            currentMonth -= 1
        }
        updateMonthButtonTitle()

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

        tapNext?(currentYear, currentMonth)
    }

    private func updateMonthButtonTitle() {
        let monthText = "\(currentYear)년 \(currentMonth)월"
        monthLabel.text = monthText
    }
}
