//
//  MyPageViewModel.swift
//  MyPage
//
//  Created by 박지윤 on 7/1/25.
//

import RxSwift
import Domain

public class MyPageViewModel {
    private let tokenUseCase: TokenUseCase
    private let disposeBag = DisposeBag()
    
    public var onLogoutSuccess: (() -> Void)?
    
    public init(tokenUseCase: TokenUseCase) {
        self.tokenUseCase = tokenUseCase
    }
    
    public func logout() {
        // 토큰 삭제
        tokenUseCase.clearAccessToken()
        print("🔓 로그아웃 완료")
        onLogoutSuccess?()
    }
}