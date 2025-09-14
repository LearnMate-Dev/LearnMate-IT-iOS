//
//  CalendarView.swift
//  CommonUI
//
//  Created by 박지윤 on 9/14/25.
//

import UIKit
import FSCalendar

final class CalendarView: UIView {
//
//    // MARK: UI Components
//    let calendarView = FSCalendar().then {
//        $0.locale = Locale(identifier: "ko_KR")
//        $0.backgroundColor = CommonUIAssets.LMOrange4
//        $0.scrollEnabled = false
//        $0.scrollDirection = .horizontal
//
//        $0.headerHeight = 0
//        $0.appearance.headerDateFormat = "YYYY년 M월"
//        $0.appearance.headerTitleColor = CommonUIAssets.LMGray1
//        $0.appearance.headerTitleAlignment = .center
//        $0.appearance.headerTitleFont = UIFont.systemFont(ofSize: 20, weight: .semibold)
//        $0.appearance.headerMinimumDissolvedAlpha = 0.0
//
//        $0.appearance.weekdayTextColor = CommonUIAssets.LMGray3
//        $0.appearance.weekdayFont = UIFont.systemFont(ofSize: 17, weight: .semibold)
// 
//        $0.appearance.titleDefaultColor = CommonUIAssets.LMGray1
//        $0.appearance.titleSelectionColor = CommonUIAssets.LMGray1
//        $0.appearance.titleFont = UIFont.systemFont(ofSize: 16, weight: .regular)
//
//        $0.appearance.titleTodayColor = CommonUIAssets.LMOrange1
//        $0.appearance.todaySelectionColor = .clear
//        $0.appearance.todayColor = .clear
//        $0.appearance.selectionColor = .clear
//    }
//
//    // MARK: Properties
//    var tapDay: ((Int) -> Void)?
////    var emotionData: [DiaryCalendarDTO] = []
//
//    // MARK: Configuration
//    func configureSubviews() {
//        addSubview(calendarView)
//
//        setCalendarView()
//    }
//
//    // MARK: Layout
//    func makeConstraints() {
//        calendarView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//    }
//
//    func setCalendarView() {
////        calendarView.register(FSCalendarViewCell.self, forCellReuseIdentifier: FSCalendarViewCell.description())
//        calendarView.delegate = self
//        calendarView.dataSource = self
//    }
//
////    func setCalendarViewData(data: [DiaryCalendarDTO]) {
////        emotionData = data
////        calendarView.reloadData()
////    }
}

//extension CalendarView: FSCalendarDelegate, FSCalendarDataSource {
//    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
//        guard let cell = calendar.dequeueReusableCell(withIdentifier: CalendarViewCell.description(), for: date, at: position) as? CalendarViewCell else { return FSCalendarCell() }
//
//        cell.subviews.forEach { subview in
//            if subview is UIStackView {
//                subview.removeFromSuperview()
//            }
//        }
//
////        if let emotion = emotionData.first(where: {
////            Calendar.current.isDate(DateFormatter.localizedStringToDate($0.date) ?? Date(), inSameDayAs: date)
////        }) {
////            let emotionView = DiaryEmotionView(emotion: Emoticon.mapEmoticonImage(emotion.emotion))
////
////            cell.addSubview(emotionView)
////
////            emotionView.snp.makeConstraints {
////                $0.top.equalToSuperview().inset(38)
////                $0.centerX.equalToSuperview()
////            }
////        }
//
//        return cell
//    }
//
//    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "ko_KR")
//        dateFormatter.dateFormat = "M"
//        let string = dateFormatter.string(from: date)
//        let month = Int(string) ?? 0
//
//        tapDay?(month)
//    }
//
//    func getWeekday(from date: Date) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "ko_KR")
//        dateFormatter.dateFormat = "E"
//        return dateFormatter.string(from: date)
//    }
//}
