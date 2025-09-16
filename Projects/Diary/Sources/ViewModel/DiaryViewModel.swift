//
//  DiaryViewModel.swift
//  Diary
//
//  Created by 박지윤 on 7/1/25.
//

import Domain
import RxSwift

protocol DiaryViewModelProtocol {
    func postDiary(content: String)
    func getDiary(date: String)
    func getDiaryDetail(diaryId: Int, date: String)
    func deleteDiaryDetail(diaryId: Int)
    func getDiaryCalendar(year: Int, month: Int)
}

public class DiaryViewModel: DiaryViewModelProtocol {
    private let disposeBag = DisposeBag()
    private let diaryUseCase: DiaryUseCase
    private let tokenUseCase: TokenUseCase
    
    public var onDiaryPostSuccess: ((DiaryVO) -> Void)?
    public var onDiaryPostFailure: ((Error) -> Void)?

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
    
    func getDiary(date: String) {
        diaryUseCase.getDiary(date: date)
            .subscribe(onSuccess: { data in
                print("✅ getDiary 성공: \(data)")
            }, onFailure: { error in
                print("❌ getDiary 실패: \(error)")
            }).disposed(by: disposeBag)
    }
    
    func getDiaryDetail(diaryId: Int, date: String) {
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
            .subscribe(onSuccess: { data in
                print("✅ getDiaryCalendar 성공: \(data)")
            }, onFailure: { error in
                print("❌ getDiaryCalendar 실패: \(error)")
            }).disposed(by: disposeBag)
    }
}
