//
//  HomeViewModel.swift
//  Home
//
//  Created by 박지윤 on 7/1/25.
//

import Domain
import RxSwift

protocol HomeViewModelProtocol {
    func getCourses()
}

public class HomeViewModel: HomeViewModelProtocol {
    private let disposeBag = DisposeBag()
    private let courseUseCase: CourseUseCase
    private let tokenUseCase: TokenUseCase
    
    let stepListSubject = PublishSubject<[StepVO]>()
    
    public init(courseUseCase: CourseUseCase, tokenUseCase: TokenUseCase) {
        self.courseUseCase = courseUseCase
        self.tokenUseCase = tokenUseCase
        getCourses()
    }
    
    func getCourses() {
        courseUseCase.getCourses()
            .subscribe(onSuccess: { [weak self] response in
                print("✅ 코스 정보: \(response)")
                // 첫 번째 코스의 stepList 전달
                if let firstCourse = response.list.first {
                    self?.stepListSubject.onNext(firstCourse.stepList)
                }
            }, onFailure: { error in
                print("❌ 코스 조회 실패: \(error)")
            }).disposed(by: disposeBag)
    }
}
