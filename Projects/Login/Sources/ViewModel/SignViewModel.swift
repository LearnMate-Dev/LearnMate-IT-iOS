//
//  SignViewModel.swift
//  Login
//
//  Created by 박지윤 on 8/26/25.
//

import Domain
import RxSwift
import RxRelay

protocol SignViewModelProtocol {
    func postSignIn(email: String, password: String)
    func postEmail(email: String)
    func postConfirm(email: String, code: String)
    func postSignUp(username: String, email: String, password: String)
}

public class SignViewModel: SignViewModelProtocol {
    private let disposeBag = DisposeBag()
    private let signUseCase: SignUseCase
    public weak var signInViewCoordinator: SignInCoordinator?
    public weak var signUpViewCoordinator: SignUpCoordinator?
    public var onEmailSuccess: (() -> Void)?
    public var onConfirmSuccess: (() -> Void)?
    public var onConfirmFailure: (() -> Void)?
    public let emailVerified = BehaviorRelay<Bool>(value: false)

    public init(signUseCase: SignUseCase) {
        self.signUseCase = signUseCase
    }

    func postSignIn(email: String, password: String) {
        signUseCase.postSignIn(email: email, password: password)
            .subscribe(onSuccess: { [weak self] response in
                print("로그인 성공: \(response)")
            }, onFailure: { error in
                print("로그인 실패: \(error)")
            })
            .disposed(by: disposeBag)
    }

    func postEmail(email: String) {
        signUseCase.postEmail(email: email)
            .subscribe(onSuccess: { [weak self] response in
                print("이메일 전송 성공: \(response.message)")
                self?.onEmailSuccess?()
            }, onFailure: { error in
                print("이메일 전송 실패: \(error)")
            })
            .disposed(by: disposeBag)
    }

    func postConfirm(email: String, code: String) {
        signUseCase.postConfirm(email: email, code: code)
            .subscribe(onSuccess: { [weak self] response in
                guard let self = self else { return }
                print("이메일 인증 성공: \(response.message)")
                self.onConfirmSuccess?()
                self.emailVerified.accept(true)
            }, onFailure: { [weak self] error in
                guard let self = self else { return }
                print("이메일 인증 실패: \(error)")
                self.onConfirmFailure?()
            })
            .disposed(by: disposeBag)
    }

    func postSignUp(username: String, email: String, password: String) {
        signUseCase.postSignUp(username: username, email: email, password: password)
            .subscribe(onSuccess: { [weak self] response in
                guard let self = self else { return }
                print("회원가입 성공: \(response.message)")
            }, onFailure: { [weak self] error in
                guard let self = self else { return }
                print("회원가입 실패: \(error)")
            })
            .disposed(by: disposeBag)
    }
}
