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

protocol AppCoordinator: Coordinator {
    // func showLoginFlow()
    func showTabbarFlow()
    func setTabBarCoordinator()
    func getChildCoordinator(_ type: CoordinatorType) -> Coordinator?
}

final class DefaultAppCoordinator: AppCoordinator{
    public struct Dependency {
        let navigationController: UINavigationController
        let injector: Injector
    }
    
    private let dependency: Dependency
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var type: CoordinatorType = .app
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    init(dependency: Dependency) {
        self.dependency = dependency
        self.navigationController = dependency.navigationController
    }
    
    func start() {
        let loginViewController = dependency.injector.resolve(LoginViewController.self)
        loginViewController.onPresentLmLogin = { [weak self] in
            guard let self else { return }
            let signInViewController = self.dependency.injector.resolve(SignInViewController.self)
            self.navigationController.pushViewController(signInViewController, animated: true)
        }
        self.navigationController.pushViewController(loginViewController, animated: true)
//        setNavigationBar()
//        setTabBarCoordinator()
//        showTabbarFlow()
    }

    /// 탭바 컨트롤러 플로우
    func showTabbarFlow() {
        if getChildCoordinator(.tabbar) == nil { setTabBarCoordinator() }
        let tabBarCoordinator = getChildCoordinator(.tabbar) as! TabBarCoordinator
        tabBarCoordinator.start()
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
        
    }
}
