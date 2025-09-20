//
//  MyPageViewModel.swift
//  MyPage
//
//  Created by 박지윤 on 7/1/25.
//

import RxSwift
import Domain

protocol MyPageViewModelProtocol {
    func getUser()
    func logout()
    func deleteUser()
}

public class MyPageViewModel {
    private let disposeBag = DisposeBag()
    private let userUseCase: UserUseCase
    private let tokenUseCase: TokenUseCase

    // Subject for success/failure handling
    public let userSubject = PublishSubject<UserVO>()
    public let userErrorSubject = PublishSubject<Error>()
    
    public let logoutSuccessSubject = PublishSubject<Void>()
    public let logoutErrorSubject = PublishSubject<Error>()
    
    public let deleteUserSuccessSubject = PublishSubject<Void>()
    public let deleteUserErrorSubject = PublishSubject<Error>()

    public init(userUseCase: UserUseCase, tokenUseCase: TokenUseCase) {
        self.userUseCase = userUseCase
        self.tokenUseCase = tokenUseCase
    }

    public func getUser() {
        userUseCase.getUser()
            .subscribe(onSuccess: { [weak self] user in
                print("✅ getUser 성공: \(user)")
                self?.userSubject.onNext(user)
            }, onFailure: { [weak self] error in
                print("❌ getUser 실패: \(error)")
                self?.userErrorSubject.onNext(error)
            }).disposed(by: disposeBag)
    }

    public func logout() {
        userUseCase.postLogout()
            .subscribe(onSuccess: { [weak self] _ in
                print("✅ logout 성공")
                self?.logoutSuccessSubject.onNext(())
            }, onFailure: { [weak self] error in
                print("❌ logout 실패: \(error)")
                self?.logoutErrorSubject.onNext(error)
            }).disposed(by: disposeBag)
    }

    public func deleteUser() {
        userUseCase.deleteUser()
            .subscribe(onSuccess: { [weak self] _ in
                print("✅ deleteUser 성공")
                self?.deleteUserSuccessSubject.onNext(())
            }, onFailure: { [weak self] error in
                print("❌ deleteUser 실패: \(error)")
                self?.deleteUserErrorSubject.onNext(error)
            }).disposed(by: disposeBag)
    }
    
    public func clearTokens() {
        tokenUseCase.clearAccessToken()
        print("🔑 토큰 삭제 완료")
    }
}
