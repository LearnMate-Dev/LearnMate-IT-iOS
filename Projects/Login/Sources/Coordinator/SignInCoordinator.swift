//
//  SignInCoordinator.swift
//  Login
//
//  Created by 박지윤 on 8/26/25.
//

import CommonUI
import UIKit

public protocol SignInCoordinator: Coordinator {
    func showSignInFlow()
}

public class DefaultSignInCoordinator: SignInCoordinator {
    public struct Dependency {
        let signInViewController: SignInViewController
        let navigationController: UINavigationController
        weak var finishDelegate: CoordinatorFinishDelegate?

        public init(signInViewController: SignInViewController,
                    navigationController: UINavigationController,
                    finishDelegate: CoordinatorFinishDelegate? = nil) {
            self.signInViewController = signInViewController
            self.navigationController = navigationController
            self.finishDelegate = finishDelegate
        }
    }

    let dependency: Dependency
    public var childCoordinators: [Coordinator] = []
    public var navigationController: UINavigationController
    public var type: CoordinatorType = .signIn
    public var finishDelegate: CoordinatorFinishDelegate?

    public init(dependency: Dependency) {
        self.dependency = dependency
        self.navigationController = dependency.navigationController
        self.finishDelegate = dependency.finishDelegate
        dependency.signInViewController.viewModel.signInViewCoordinator = self
    }
    
    public func start() {
        setNavigationBar()
        showSignInFlow()
    }
    
    func setNavigationBar() {
    }
    
    public func showSignInFlow() {
        navigationController.pushViewController(dependency.signInViewController, animated: true)
    }
}
