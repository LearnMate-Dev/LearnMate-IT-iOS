//
//  SignViewModel.swift
//  Login
//
//  Created by 박지윤 on 8/26/25.
//

import Domain
import RxSwift

protocol SignViewModelProtocol {
    func postEmail(email: String)
    func postConfirm(email: String, code: String)
}

public class SignViewModel: SignViewModelProtocol {
    private let disposeBag = DisposeBag()
    private let signUseCase: SignUseCase
    public weak var signInViewCoordinator: SignInCoordinator?

    public init(signUseCase: SignUseCase) {
        self.signUseCase = signUseCase
    }

    func postEmail(email: String) {
        signUseCase.postEmail(email: email)
            .subscribe(
                onCompleted: {
                    print("이메일 전송 성공")
                },
                onError: { error in
                    print("이메일 전송 실패: \(error)")
                }
            ).disposed(by: disposeBag)
    }

    func postConfirm(email: String, code: String) {
        signUseCase.postConfirm(email: email, code: code)
            .subscribe(
                onCompleted: {
                    print("이메일 전송 성공")
                },
                onError: { error in
                    print("이메일 전송 실패: \(error)")
                }
            ).disposed(by: disposeBag)
    }
}
