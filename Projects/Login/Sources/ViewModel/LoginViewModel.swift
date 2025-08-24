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
    func postAppleLogin(userName: String?, identityToken: String)
}

public class LoginViewModel: LoginViewModelProtocol {
    private let disposeBag = DisposeBag()
    private let loginUseCase: LoginUseCase
    public init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }

    func postGoogleLogin() {
        loginUseCase.postGoogleLogin()
            .subscribe(onSuccess: { response in
                print(response)
            }, onFailure: { _ in

            }).disposed(by: disposeBag)
    }

    func postAppleLogin(userName: String?, identityToken: String) {
        loginUseCase.postAppleLogin(userName: userName, identityToken: identityToken)
            .subscribe(onSuccess: { response in
                print("Apple Login Response: \(response)")
            }, onFailure: { error in
                print("Apple Login Error: \(error)")
            }).disposed(by: disposeBag)
    }
}
