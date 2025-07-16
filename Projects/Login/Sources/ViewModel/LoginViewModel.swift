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
    private let loginUseCase: LoginUseCase
    public init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
        postGoogleLogin()
    }
    
    func postGoogleLogin() {
        loginUseCase.postGoogleLogin()
            .subscribe(onSuccess: { response in
                print(response)
            }, onFailure: { _ in
                
            }).disposed(by: disposeBag)
    }
}
