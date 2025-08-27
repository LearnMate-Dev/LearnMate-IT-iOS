//
//  Coordinator.swift
//  CommonUI
//
//  Created by 박지윤 on 7/1/25.
//

import UIKit

public enum CoordinatorType {
    case app
    case tabbar
    case home
    case chat
    case diary
    case stats
    case myPage
    case signIn
    case signUp
}

public protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    var type: CoordinatorType { get }
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    func start()
    func finish()
}

extension Coordinator {
    public func finish() {
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

public protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}
