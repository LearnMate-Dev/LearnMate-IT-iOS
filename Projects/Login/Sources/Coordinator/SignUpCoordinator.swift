//
//  SignUpCoordinator.swift
//  Login
//
//  Created by 박지윤 on 8/27/25.
//

import CommonUI
import UIKit

public protocol SignUpCoordinator: Coordinator {
    func showSignUpFlow()
}

public class DefaultSignUpCoordinator: SignUpCoordinator {
    public struct Dependency {
        let signUpViewController: SignUpViewController
        let navigationController: UINavigationController
        weak var finishDelegate: CoordinatorFinishDelegate?

        public init(signUpViewController: SignUpViewController,
                    navigationController: UINavigationController,
                    finishDelegate: CoordinatorFinishDelegate? = nil) {
            self.signUpViewController = signUpViewController
            self.navigationController = navigationController
            self.finishDelegate = finishDelegate
        }
    }

    let dependency: Dependency
    public var childCoordinators: [Coordinator] = []
    public var navigationController: UINavigationController
    public var type: CoordinatorType = .signUp
    public var finishDelegate: CoordinatorFinishDelegate?

    public init(dependency: Dependency) {
        self.dependency = dependency
        self.navigationController = dependency.navigationController
        self.finishDelegate = dependency.finishDelegate
        dependency.signUpViewController.viewModel.signUpViewCoordinator = self
    }
    
    public func start() {
        setNavigationBar()
        showSignUpFlow()
    }
    
    func setNavigationBar() {
    }
    
    public func showSignUpFlow() {
        navigationController.pushViewController(dependency.signUpViewController, animated: true)
    }
}
