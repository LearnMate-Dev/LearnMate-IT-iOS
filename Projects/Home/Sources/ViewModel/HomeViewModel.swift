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
    public init(courseUseCase: CourseUseCase) {
        self.courseUseCase = courseUseCase
        getCourses()
    }
    
    func getCourses() {
        courseUseCase.getCourses()
            .subscribe(onSuccess: { response in
                print(response)
            }, onFailure: { _ in
                
            }).disposed(by: disposeBag)
    }
}
