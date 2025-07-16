//
//  LoginViewModel.swift
//  Login
//
//  Created by 박지윤 on 7/16/25.
//

import Domain
import RxSwift

protocol LoginViewModelProtocol {
    func postGoogleLogin()
}

public class LoginViewModel: LoginViewModelProtocol {
    private let disposeBag = DisposeBag()
    private let courseUseCase: CourseUseCase
    public init(courseUseCase: CourseUseCase) {
        self.courseUseCase = courseUseCase
        getCourses()
    }
    
    func postGoogleLogin() {
        courseUseCase.getCourses()
            .subscribe(onSuccess: { response in
                print(response)
            }, onFailure: { _ in
                
            }).disposed(by: disposeBag)
    }
}
