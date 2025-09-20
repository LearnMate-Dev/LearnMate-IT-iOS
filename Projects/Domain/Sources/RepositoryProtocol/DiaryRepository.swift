//
//  DiaryRepository.swift
//  Domain
//
//  Created by 박지윤 on 9/15/25.
//

import RxSwift
import Foundation

public protocol DiaryRepository {
    func postDiary(content: String) -> Single<DiaryVO>
    func getDiary(date: Date) -> Single<DiaryVO>
    func getDiaryDetail(diaryId: Int, date: Date) -> Single<DiaryVO>
    func deleteDiaryDetail(diaryId: Int) -> Single<DefaultVO>
    func getDiaryCalendar(year: Int, month: Int) -> Single<DiaryCalendarVO>
}
