//
//  SceneDelegate.swift
//  LearnMate
//
//  Created by 박지윤 on 7/1/25.
//

import UIKit
import Swinject
import Domain

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let injector: Injector = DependencyInjector(container: Container())
    private var appCoordinator: DefaultAppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let navigationController = UINavigationController()
        window = .init(windowScene: scene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        /// AppCoordinator 실행
        appCoordinator = DefaultAppCoordinator(dependency: .init(navigationController: navigationController, injector: injector))
        
        injector.assemble([DataAssembly(),
                           DomainAssembly(),
                           LoginAssembly(),
                           HomeAssembly()])
        appCoordinator?.start()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }

        print("📡 Received URL: \(url.absoluteString)")

        if url.scheme == "com.learnmate.app",
           url.host == "oauth2",
           url.path == "/callback" {
            if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
               let token = components.queryItems?.first(where: { $0.name == "accessToken" })?.value {
                print("✅ Access Token from SceneDelegate:", token)

                let tokenRepository = injector.resolve(TokenRepository.self)
                tokenRepository.saveAccessToken(token)
            }
        }
    }
}
