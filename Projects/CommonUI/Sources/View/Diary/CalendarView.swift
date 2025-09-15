//
//  CalendarView.swift
//  CommonUI
//
//  Created by 박지윤 on 9/14/25.
//

import UIKit
import SnapKit
import Then

final class CalendarView: UIView {
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
    var tapDay: ((Int) -> Void)?
    private var currentDate = Date()
    private let calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    private let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
    private var emotionData: [Int: String] = [:] // 날짜: 이모지 매핑

    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCalendarView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Configuration
    func configureSubviews() {
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
    
    private func setupWeekdayLabels() {
        for weekday in weekdays {
            let label = UILabel()
            label.text = weekday
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            
            // 일요일은 빨간색, 토요일은 파란색, 나머지는 회색
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
    func makeConstraints() {
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
    func setEmotionData(_ data: [Int: String]) {
        emotionData = data
        calendarCollectionView.reloadData()
    }
    
    func setEmotion(for day: Int, emotion: String) {
        emotionData[day] = emotion
        calendarCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension CalendarView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getDaysInMonth().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCell.identifier, for: indexPath) as! CalendarCell
        let days = getDaysInMonth()
        
        if let date = days[indexPath.item] {
            let day = calendar.component(.day, from: date)
            let isToday = calendar.isDateInToday(date)
            let isSunday = calendar.component(.weekday, from: date) == 1
            let emotion = emotionData[day]
            cell.configure(day: day, isToday: isToday, isSunday: isSunday, emotion: emotion)
        } else {
            cell.configure(day: nil, isToday: false, isSunday: false, emotion: nil)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CalendarView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let days = getDaysInMonth()
        if let date = days[indexPath.item] {
            let month = calendar.component(.month, from: date)
            tapDay?(month)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CalendarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 7
        return CGSize(width: width, height: 70)
    }
    
}

// MARK: - CalendarCell
class CalendarCell: UICollectionViewCell {
    static let identifier = "CalendarCell"

    private let dayLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textColor = CommonUIAssets.LMGray1
    }

    private let emotionLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 15)
    }

    private let customView = UIView()

    private let bottomBorderView = UIView().then {
        $0.backgroundColor = CommonUIAssets.LMGray5
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(customView)
        [dayLabel, emotionLabel].forEach { customView.addSubview($0) }
        addSubview(bottomBorderView)

        customView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(12)
            $0.horizontalEdges.equalToSuperview()
        }

        dayLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }

        emotionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        bottomBorderView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    func configure(day: Int?, isToday: Bool, isSunday: Bool, emotion: String?) {
        if let day = day {
            dayLabel.text = "\(day)"
            
            // 날짜 색상 설정
            if isToday {
                dayLabel.textColor = CommonUIAssets.LMOrange1
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
        }
    }
}

