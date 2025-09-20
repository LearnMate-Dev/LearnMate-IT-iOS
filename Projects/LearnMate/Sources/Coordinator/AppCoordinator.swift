//
//  AppCoordinator.swift
//  LearnMate
//
//  Created by 박지윤 on 7/1/25.
//

import CommonUI
import Home
import UIKit
import Login
import RxSwift
import Domain

protocol AppCoordinator: Coordinator {
    // func showLoginFlow()
    func showTabbarFlow()
    func setTabBarCoordinator()
    func getChildCoordinator(_ type: CoordinatorType) -> Coordinator?
    func showHomeAfterLogin()
}

final class DefaultAppCoordinator: AppCoordinator{
    public struct Dependency {
        let navigationController: UINavigationController
        let injector: Injector
    }
    
    private let dependency: Dependency
    private let disposeBag = DisposeBag()
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var type: CoordinatorType = .app
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    init(dependency: Dependency) {
        self.dependency = dependency
        self.navigationController = dependency.navigationController
    }
    
    func start() {
        // 자동 로그인 확인
        checkAutoLogin()
    }
    
    private func checkAutoLogin() {
        let tokenRepository = dependency.injector.resolve(TokenRepository.self)
        
        // 먼저 토큰이 있는지 빠르게 확인
        guard let accessToken = tokenRepository.getAccessToken(), !accessToken.isEmpty else {
            print("❌ 저장된 토큰 없음, 로그인 화면으로 이동")
            showLoginFlow()
            return
        }
        
        print("🔑 저장된 토큰 발견, 토큰 검증 시작")
        
        let tokenValidationUseCase = dependency.injector.resolve(TokenValidationUseCase.self)
        
        tokenValidationUseCase.validateToken()
            .subscribe(onSuccess: { [weak self] isValid in
                guard let self = self else { return }
                
                if isValid {
                    print("✅ 토큰 검증 성공, 자동 로그인 완료")
                    DispatchQueue.main.async {
                        self.showTabbarFlow()
                    }
                } else {
                    print("❌ 토큰 무효, 로그인 화면으로 이동")
                    DispatchQueue.main.async {
                        self.showLoginFlow()
                    }
                }
            }, onFailure: { [weak self] error in
                guard let self = self else { return }
                print("❌ 토큰 검증 네트워크 에러: \(error), 로그인 화면으로 이동")
                DispatchQueue.main.async {
                    self.showLoginFlow()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func showLoginFlow() {
        let loginViewController = dependency.injector.resolve(LoginViewController.self)
        loginViewController.onPresentLmLogin = { [weak self] in
            guard let self else { return }
            let signInViewController = self.dependency.injector.resolve(SignInViewController.self)
            signInViewController.onPresentSignUp = { [weak self] in
                guard let self else { return }
                let signUpViewController = self.dependency.injector.resolve(SignUpViewController.self)
                self.navigationController.pushViewController(signUpViewController, animated: true)
            }
            signInViewController.onLoginSuccess = { [weak self] in
                guard let self else { return }
                self.showHomeAfterLogin()
            }
            self.navigationController.pushViewController(signInViewController, animated: true)
        }
        self.navigationController.pushViewController(loginViewController, animated: true)
    }

    /// 탭바 컨트롤러 플로우
    func showTabbarFlow() {
        // 네비게이션 바 숨기기
        navigationController.setNavigationBarHidden(true, animated: false)
        
        if getChildCoordinator(.tabbar) == nil { setTabBarCoordinator() }
        let tabBarCoordinator = getChildCoordinator(.tabbar) as! TabBarCoordinator
        tabBarCoordinator.start()
    }

    /// 로그인 성공 후 홈으로 이동
    func showHomeAfterLogin() {
        // 로그인 관련 뷰컨트롤러들을 모두 제거하고 탭바로 이동
        navigationController.viewControllers.removeAll()
        showTabbarFlow()
    }

    /// 탭바 컨트롤러 세팅, 자식 코디네이터로 등록
    func setTabBarCoordinator() {
        let dependency = DefaultTabBarController.Dependency.init(
            navigationController: navigationController,
            injector: dependency.injector,
            finishDelegate: self)
        let tabBarCoordinator = DefaultTabBarController(dependency: dependency)
        childCoordinators.append(tabBarCoordinator)
    }

    func setNavigationBar() {
        navigationController.setNavigationBarHidden(true, animated: true)
    }

    /// 앱 코디네이터의 자식 코디네이터 get
    func getChildCoordinator(_ type: CoordinatorType) -> Coordinator? {
        var childCoordinator: Coordinator? = nil
        switch type {
        case .tabbar:
            childCoordinator = childCoordinators.first(where: {$0 is TabBarCoordinator})
        default:
            break
        }
        return childCoordinator
    }
}

/// 자식 코디네이터가 종료되었을 때 실행할 메서드
extension DefaultAppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
        
        // TabBarCoordinator가 종료되면 로그인 화면으로 이동
        if childCoordinator is TabBarCoordinator {
            showLoginFlow()
        }
    }
}
