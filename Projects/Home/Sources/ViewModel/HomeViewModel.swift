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
    func startStep(course: Int, step: Int)
    func patchStep(stepProgressId: Int)
}

public class HomeViewModel: HomeViewModelProtocol {
    private let disposeBag = DisposeBag()
    private let courseUseCase: CourseUseCase
    private let tokenUseCase: TokenUseCase
    private let quizUseCase: QuizUseCase
    
    let stepListSubject = PublishSubject<[StepVO]>()
    let courseSubject = PublishSubject<CourseVO>()
    let quizSubject = PublishSubject<QuizVO>()
    let patchStepSuccessSubject = PublishSubject<Void>()
    
    public init(courseUseCase: CourseUseCase, tokenUseCase: TokenUseCase, quizUseCase: QuizUseCase) {
        self.courseUseCase = courseUseCase
        self.tokenUseCase = tokenUseCase
        self.quizUseCase = quizUseCase
        getCourses()
    }
    
    func getCourses() {
        courseUseCase.getCourses()
            .subscribe(onSuccess: { [weak self] response in
                print("✅ 코스 정보: \(response)")
                if let firstCourse = response.list.first {
                    self?.stepListSubject.onNext(firstCourse.stepList)
                    self?.courseSubject.onNext(firstCourse)
                }
            }, onFailure: { error in
                print("❌ 코스 조회 실패: \(error)")
            }).disposed(by: disposeBag)
    }
    
    func startStep(course: Int, step: Int) {
        print(course)
        print(step)
        print("ddddd")
        quizUseCase.startStep(course: course, step: step)
            .subscribe(onSuccess: { [weak self] quiz in
                print("✅ 퀴즈 시작 성공: \(quiz)")
                self?.quizSubject.onNext(quiz)
            }, onFailure: { error in
                print("❌ 퀴즈 시작 실패: \(error)")
            }).disposed(by: disposeBag)
    }

    func patchStep(stepProgressId: Int) {
        quizUseCase.patchStep(stepProgressId: stepProgressId)
            .subscribe(onSuccess: { [weak self] result in
                print("✅ 퀴즈 완료 성공: \(result)")
                self?.patchStepSuccessSubject.onNext(())
            }, onFailure: { error in
                print("❌ 퀴즈 완료 실패: \(error)")
            }).disposed(by: disposeBag)
    }
}
