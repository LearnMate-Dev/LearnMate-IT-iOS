//
//  TabBarCoordinator.swift
//  LearnMate
//
//  Created by 박지윤 on 7/1/25.
//

import CommonUI
import Home
import UIKit

protocol TabBarCoordinator: Coordinator {
    var tabBarController: UITabBarController { get }
}

final class DefaultTabBarController: TabBarCoordinator {
    public struct Dependency {
        let navigationController: UINavigationController
        let homeViewController: HomeViewController
        weak var finishDelegate: CoordinatorFinishDelegate?
    }
    
    private let dependency: Dependency
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var tabBarController = UITabBarController()
    var type: CoordinatorType = .tabbar
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    init(dependency: Dependency) {
        self.dependency = dependency
        self.navigationController = dependency.navigationController
    }
    
    /// 탭바 flow 시작
    func start() {
        let pages: [TabBarPage] = TabBarPage.allCases
        let controllers: [UINavigationController] = pages.map({
            self.createTabNavigationController(of: $0)
        })
        self.configureTabbarController(with: controllers)
    }
    
    /// 각 탭바에 들어갈 네비게이션 컨트롤러 생성
    private func createTabNavigationController(of page: TabBarPage) -> UINavigationController {
        let tabNavigationController = UINavigationController()
        tabNavigationController.setNavigationBarHidden(false, animated: false)
        tabNavigationController.tabBarItem = self.configureTabBarItem(of: page)
        self.startTabCoordinator(of: page, to: tabNavigationController)
        return tabNavigationController
    }
    
    /// 각 탭바에 들어갈 네비게이션 컨트롤러 설정
    private func configureTabbarController(with tabViewControllers: [UIViewController]) {
        self.tabBarController.setViewControllers(tabViewControllers, animated: true)
        self.tabBarController.selectedIndex = TabBarPage.home.pageOrderNumber()
        self.tabBarController.view.backgroundColor = .white
        self.tabBarController.tabBar.backgroundColor = .white
        self.tabBarController.tabBar.tintColor = .black
        self.navigationController.pushViewController(self.tabBarController, animated: true)
    }

    /// 각 탭바 아이템 설정
    private func configureTabBarItem(of page: TabBarPage) -> UITabBarItem {
        return UITabBarItem(title: page.rawValue, image: nil, tag: page.pageOrderNumber())
    }
    
    /// 각 탭 flow 시작
    private func startTabCoordinator(of page: TabBarPage, to tabNavigationController: UINavigationController) {
        switch page {
        case .home:
            // 추후 homeCoordinator 로 변경
            let homeViewController = dependency.homeViewController
            tabNavigationController.pushViewController(homeViewController, animated: true)
        default:
            let viewController = UIViewController()
            viewController.view.backgroundColor = .black
            tabNavigationController.pushViewController(viewController, animated: true)
        }
    }
}

enum TabBarPage: String, CaseIterable {
    case home, chat, diary, stats, myPage
    
    init?(index: Int) {
        switch index {
        case 0: self = .home
        case 1: self = .chat
        case 2: self = .diary
        case 3: self = .stats
        case 4: self = .myPage
        default: return nil
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .home: return 0
        case .chat: return 1
        case .diary: return 2
        case .stats: return 3
        case .myPage: return 4
        }
    }
    
    func tabIconName() -> String {
        return self.rawValue
    }
}
