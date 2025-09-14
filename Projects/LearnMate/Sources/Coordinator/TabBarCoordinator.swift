//
//  TabBarCoordinator.swift
//  LearnMate
//
//  Created by 박지윤 on 7/1/25.
//

import CommonUI
import Login
import Home
import UIKit
import Chat

protocol TabBarCoordinator: Coordinator {
    var tabBarController: UITabBarController { get }
}

final class DefaultTabBarController: TabBarCoordinator {
    public struct Dependency {
        let navigationController: UINavigationController
        let injector: Injector
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
        self.tabBarController.tabBar.tintColor = CommonUIAssets.LMOrange1
        self.navigationController.pushViewController(self.tabBarController, animated: true)
    }

    /// 각 탭바 아이템 설정
    private func configureTabBarItem(of page: TabBarPage) -> UITabBarItem {
        switch page {
        case .home:
            return UITabBarItem(title: page.tabIconName(),
                                image: CommonUIAssets.tabIconHome?.original,
                                selectedImage: CommonUIAssets.tabIconHomeSelected?.original)
        case .chat:
            return UITabBarItem(title: page.tabIconName(),
                                image: CommonUIAssets.tabIconChat?.original,
                                selectedImage: CommonUIAssets.tabIconChatSelected?.original)
        case .diary:
            return UITabBarItem(title: page.tabIconName(),
                                image: CommonUIAssets.tabIconDiary?.original,
                                selectedImage: CommonUIAssets.tabIconDiarySelected?.original)
//        case .stats:
//            return UITabBarItem(title: page.tabIconName(),
//                                image: CommonUIAssets.tabIconStats?.original,
//                                selectedImage: CommonUIAssets.tabIconStatsSelected?.original)
        case .myPage:
            return UITabBarItem(title: page.tabIconName(),
                                image: CommonUIAssets.tabIconMypage?.original,
                                selectedImage: CommonUIAssets.tabIconMypageSelected?.original)
        }
    }
    
    /// 각 탭 flow 시작
    private func startTabCoordinator(of page: TabBarPage, to tabNavigationController: UINavigationController) {
        switch page {
        case .home:
            let homeViewController = dependency.injector.resolve(HomeViewController.self)
            tabNavigationController.pushViewController(homeViewController, animated: true)
        case .chat:
            let chatMainViewController = dependency.injector.resolve(ChatMainViewController.self)
            tabNavigationController.pushViewController(chatMainViewController, animated: true)
        default:
            let viewController = UIViewController()
            viewController.view.backgroundColor = .black
            tabNavigationController.pushViewController(viewController, animated: true)
        }
    }
}

enum TabBarPage: String, CaseIterable {
    case home, chat, diary, myPage
    
    init?(index: Int) {
        switch index {
        case 0: self = .home
        case 1: self = .chat
        case 2: self = .diary
//        case 3: self = .stats
        case 3: self = .myPage
        default: return nil
        }
    }

    func pageOrderNumber() -> Int {
        switch self {
        case .home: return 0
        case .chat: return 1
        case .diary: return 2
//        case .stats: return 3
        case .myPage: return 3
        }
    }

    func tabIconName() -> String {
        switch self {
        case .home: return "홈"
        case .chat: return "대화"
        case .diary: return "일기"
//        case .stats: return "통계"
        case .myPage: return "마이페이지"
        }
    }
}
