//
//  DiaryViewModel.swift
//  Diary
//
//  Created by 박지윤 on 7/1/25.
//

import Domain
import RxSwift
import Foundation

protocol DiaryViewModelProtocol {
    func postDiary(content: String)
    func getDiary(date: Date)
    func getDiaryDetail(diaryId: Int, date: Date)
    func deleteDiaryDetail(diaryId: Int)
    func getDiaryCalendar(year: Int, month: Int)
}

public class DiaryViewModel: DiaryViewModelProtocol {
    private let disposeBag = DisposeBag()
    private let diaryUseCase: DiaryUseCase
    private let tokenUseCase: TokenUseCase
    
    public var onDiaryPostSuccess: ((DiaryVO) -> Void)?
    public var onDiaryPostFailure: ((Error) -> Void)?
    
    // 캘린더 데이터 Subject
    public let diaryCalendarSubject = PublishSubject<DiaryCalendarVO>()
    public let diaryCalendarErrorSubject = PublishSubject<Error>()
    
    // 특정 날짜 일기 데이터 Subject
    public let diarySubject = PublishSubject<DiaryVO>()
    public let diaryErrorSubject = PublishSubject<Error>()
    public let diaryEmptySubject = PublishSubject<Date>() // 일기가 없을 때 날짜 전달

    public init(diaryUseCase: DiaryUseCase,
                tokenUseCase: TokenUseCase) {
        self.diaryUseCase = diaryUseCase
        self.tokenUseCase = tokenUseCase
    }

    func postDiary(content: String) {
        diaryUseCase.postDiary(content: content)
            .subscribe(onSuccess: { [weak self] data in
                print("✅ postDiary 성공: \(data)")
                self?.onDiaryPostSuccess?(data)
            }, onFailure: { [weak self] error in
                print("❌ postDiary 실패: \(error)")
                self?.onDiaryPostFailure?(error)
            }).disposed(by: disposeBag)
    }
    
    func getDiary(date: Date) {
        diaryUseCase.getDiary(date: date)
            .subscribe(onSuccess: { [weak self] data in
                print("✅ getDiary 성공: \(data)")
                self?.diarySubject.onNext(data)
            }, onFailure: { [weak self] error in
                print("❌ getDiary 실패: \(error)")
                // 에러 시 해당 날짜에 일기가 없다고 처리
                self?.diaryEmptySubject.onNext(date)
            }).disposed(by: disposeBag)
    }
    
    func getDiaryDetail(diaryId: Int, date: Date) {
        diaryUseCase.getDiaryDetail(diaryId: diaryId, date: date)
            .subscribe(onSuccess: { data in
                print("✅ getDiaryDetail 성공: \(data)")
            }, onFailure: { error in
                print("❌ getDiaryDetail 실패: \(error)")
            }).disposed(by: disposeBag)
    }
    
    func deleteDiaryDetail(diaryId: Int) {
        diaryUseCase.deleteDiaryDetail(diaryId: diaryId)
            .subscribe(onSuccess: { result in
                print("✅ deleteDiaryDetail 성공: \(result)")
            }, onFailure: { error in
                print("❌ deleteDiaryDetail 실패: \(error)")
            }).disposed(by: disposeBag)
    }
    
    func getDiaryCalendar(year: Int, month: Int) {
        diaryUseCase.getDiaryCalendar(year: year, month: month)
            .subscribe(onSuccess: { [weak self] data in
                print("✅ getDiaryCalendar 성공: \(data)")
                self?.diaryCalendarSubject.onNext(data)
            }, onFailure: { [weak self] error in
                print("❌ getDiaryCalendar 실패: \(error)")
                self?.diaryCalendarErrorSubject.onNext(error)
            }).disposed(by: disposeBag)
    }
}
