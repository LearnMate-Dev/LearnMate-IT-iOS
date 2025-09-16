//
//  DiaryUseCase.swift
//  Domain
//
//  Created by 박지윤 on 9/15/25.
//

import RxSwift

public protocol DiaryUseCase {
    func postDiary(content: String) -> Single<DiaryVO>
    func getDiary(date: String) -> Single<DiaryVO>
    func getDiaryDetail(diaryId: Int, date: String) -> Single<DiaryVO>
    func deleteDiaryDetail(diaryId: Int) -> Single<DefaultVO>
    func getDiaryCalendar(year: Int, month: Int) -> Single<DiaryCalendarVO>
}

public final class DefaultDiaryUseCase: DiaryUseCase {
    private let repository: DiaryRepository

    public init(repository: DiaryRepository) {
        self.repository = repository
    }

    public func postDiary(content: String) -> Single<DiaryVO> {
        repository.postDiary(content: content)
    }
    
    public func getDiary(date: String) -> Single<DiaryVO> {
        repository.getDiary(date: date)
    }
    
    public func getDiaryDetail(diaryId: Int, date: String) -> Single<DiaryVO> {
        repository.getDiaryDetail(diaryId: diaryId, date: date)
    }
    
    public func deleteDiaryDetail(diaryId: Int) -> Single<DefaultVO> {
        repository.deleteDiaryDetail(diaryId: diaryId)
    }
    
    public func getDiaryCalendar(year: Int, month: Int) -> Single<DiaryCalendarVO> {
        repository.getDiaryCalendar(year: year, month: month)
    }
}
