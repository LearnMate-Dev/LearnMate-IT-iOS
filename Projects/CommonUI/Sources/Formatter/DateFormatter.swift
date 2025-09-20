//
//  DateFormatter.swift
//  CommonUI
//
//  Created by 박지윤 on 9/16/25.
//

import Foundation

extension Date {
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

    func toDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }

    func getToday() -> String {
        let today = Date()

        return today.toDateString()
    }

    func getAddingDay(_ daysOffset: Int) -> String {
        let day = Calendar.current.date(byAdding: .day, value: daysOffset, to: self) ?? self

        return day.toDateString()
    }
}

extension String {
    func convertDateString(fromFormat: String, toFormat: String) -> String? {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = fromFormat
        guard let date = dateFormatter.date(from: self) else {
            return nil
        }

        dateFormatter.dateFormat = toFormat
        return dateFormatter.string(from: date)
    }

    func toDate(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }

    func previousMonth(format: String) -> String? {
        guard let currentDate = self.toDate(format: format) else { return nil }

        let calendar = Calendar.current
        if let previousMonthDate = calendar.date(byAdding: .month, value: -1, to: currentDate) {
            return previousMonthDate.toString(format: format)
        }
        return nil
    }

    func nextMonth(format: String) -> String? {
        guard let currentDate = self.toDate(format: format) else { return nil }

        let calendar = Calendar.current
        if let nextMonthDate = calendar.date(byAdding: .month, value: 1, to: currentDate) {
            return nextMonthDate.toString(format: format)
        }
        return nil
    }
}

extension DateFormatter {
    static func localizedStringToDate(_ dateString: String, format: String = "yyyy-MM-dd") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.date(from: dateString)
    }
}
