//
//  CalendarView.swift
//  CommonUI
//
//  Created by 박지윤 on 9/14/25.
//

import UIKit
import SnapKit

public final class CalendarView: UIView {
    // MARK: UI Components
    private let weekdayStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.backgroundColor = CommonUIAssets.LMOrange4
    }
    
    private let calendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = CommonUIAssets.LMOrange4
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.identifier)
        return collectionView
    }()

    // MARK: Properties
    public var tapDay: ((Date) -> Void)? // 날짜 문자열 (yyyy-MM-dd 형식)
    private var currentDate = Date()
    private let calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    private let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
    private var emotionData: [Int: String] = [:] // 날짜: 이모지 매핑
    private var selectedDate: Date? // 선택된 날짜

    // MARK: Initialization
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupCalendarView()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Configuration
    public func configureSubviews() {
        setupWeekdayLabels()
        addSubview(weekdayStackView)
        addSubview(calendarCollectionView)
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
    }

    private func setupCalendarView() {
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy년 M월"
    }

    private func formatDateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    private func setupWeekdayLabels() {
        for weekday in weekdays {
            let label = UILabel().then {
                $0.text = weekday
                $0.textAlignment = .center
                $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            }

            if weekday == "일" {
                label.textColor = .systemRed
            } else if weekday == "토" {
                label.textColor = .systemBlue
            } else {
                label.textColor = CommonUIAssets.LMGray3
            }

            weekdayStackView.addArrangedSubview(label)
        }
    }

    // MARK: Layout
    public func makeConstraints() {
        weekdayStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        calendarCollectionView.snp.makeConstraints {
            $0.top.equalTo(weekdayStackView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: Helper Methods
    private func getDaysInMonth() -> [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: currentDate),
              let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate)) else {
            return []
        }

        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let numberOfDays = range.count
        let numberOfEmptyDays = firstWeekday - 1

        var days: [Date?] = Array(repeating: nil, count: numberOfEmptyDays)

        for day in 1...numberOfDays {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth) {
                days.append(date)
            }
        }

        return days
    }
    
    // MARK: Public Methods
    public func setEmotionData(_ data: [Int: String]) {
        emotionData = data
        calendarCollectionView.reloadData()
    }

    public func setEmotion(for day: Int, emotion: String) {
        emotionData[day] = emotion
        calendarCollectionView.reloadData()
    }

    public func setSelectedDate(_ date: Date?) {
        selectedDate = date
        calendarCollectionView.reloadData()
    }
    
    public func updateMonth(year: Int, month: Int) {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        
        if let newDate = calendar.date(from: components) {
            currentDate = newDate
            calendarCollectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension CalendarView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getDaysInMonth().count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCell.identifier, for: indexPath) as! CalendarCell
        let days = getDaysInMonth()

        if let date = days[indexPath.item] {
            let day = calendar.component(.day, from: date)
            let isToday = calendar.isDateInToday(date)
            let isSunday = calendar.component(.weekday, from: date) == 1
            let emotion = emotionData[day]
            let isSelected = selectedDate != nil && calendar.isDate(date, inSameDayAs: selectedDate!)
            cell.configure(day: day, isToday: isToday, isSunday: isSunday, emotion: emotion, isSelected: isSelected)
        } else {
            cell.configure(day: nil, isToday: false, isSunday: false, emotion: nil, isSelected: false)
        }

        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension CalendarView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let days = getDaysInMonth()
        if let selectedDate = days[indexPath.item] {
            self.selectedDate = selectedDate
            calendarCollectionView.reloadData()
            tapDay?(selectedDate)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CalendarView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 7
        return CGSize(width: width, height: 70)
    }
    
}

// MARK: - CalendarCell
public class CalendarCell: UICollectionViewCell {
    public static let identifier = "CalendarCell"
    
    private let dayLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textColor = CommonUIAssets.LMGray1
    }
    
    private let emotionLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 15)
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 10
    }
    
    private let bottomBorderView = UIView().then {
        $0.backgroundColor = CommonUIAssets.LMGray5
    }
    
    // 선택된 날짜 배경을 위한 뷰
    private let selectionBackgroundView = UIView().then {
        $0.backgroundColor = CommonUIAssets.LMOrange3
        $0.layer.cornerRadius = 8
    }
    
    // 오늘 날짜 동그라미를 위한 뷰
    private let todayCircleView = UIView().then {
        $0.backgroundColor = CommonUIAssets.LMOrange1
        $0.layer.cornerRadius = 12
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(selectionBackgroundView)
        addSubview(todayCircleView)
        addSubview(stackView)
        addSubview(bottomBorderView)
        stackView.addArrangedSubview(dayLabel)
        stackView.addArrangedSubview(emotionLabel)

        // 선택된 날짜 배경 뷰 레이아웃
        selectionBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(5)
        }

        // 오늘 날짜 동그라미 뷰 레이아웃
        todayCircleView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(dayLabel)
            $0.width.height.equalTo(24)
        }

        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }

        bottomBorderView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }

        // 초기에는 숨김
        selectionBackgroundView.isHidden = true
        todayCircleView.isHidden = true
    }

    public func configure(day: Int?, isToday: Bool, isSunday: Bool, emotion: String?, isSelected: Bool = false) {
        if let day = day {
            dayLabel.text = "\(day)"
            
            // 선택된 날짜 배경 표시/숨김
            selectionBackgroundView.isHidden = !isSelected
            
            // 오늘 날짜 동그라미 표시/숨김
            todayCircleView.isHidden = !isToday

            // 날짜 색상 설정
            if isToday {
                // 오늘 날짜는 흰색 텍스트 (동그라미 배경 위에)
                dayLabel.textColor = .white
            } else if isSunday {
                dayLabel.textColor = .systemRed
            } else {
                dayLabel.textColor = CommonUIAssets.LMGray1
            }

            // 이모지 설정 - 간격 유지를 위해 항상 표시
            if let emotion = emotion, !emotion.isEmpty {
                emotionLabel.text = emotion
            } else {
                emotionLabel.text = " " // 공백으로 간격 유지
            }
            emotionLabel.isHidden = false // 항상 표시하여 간격 유지
        } else {
            dayLabel.text = ""
            emotionLabel.text = ""
            emotionLabel.isHidden = true
            selectionBackgroundView.isHidden = true
            todayCircleView.isHidden = true
        }
    }
}
