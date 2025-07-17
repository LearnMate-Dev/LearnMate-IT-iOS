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
    public init(courseUseCase: CourseUseCase, tokenUseCase: TokenUseCase) {
        self.courseUseCase = courseUseCase
        self.tokenUseCase = tokenUseCase
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
