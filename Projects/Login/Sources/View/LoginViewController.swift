//
//  LoginViewController.swift
//  Login
//
//  Created by 박지윤 on 7/16/25.
//

import CommonUI
import UIKit
import SnapKit
import RxSwift
import SafariServices
import AuthenticationServices

public class LoginViewController: BaseViewController, SFSafariViewControllerDelegate, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    let viewModel: LoginViewModel
    let loginView = LoginView()

    public init(loginViewModel: LoginViewModel) {
        self.viewModel = loginViewModel
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        bindLoginEvents()
        bindTransition()
    }

    private func bindActions() {
        
    }

    private func bindLoginEvents() {
        loginView.googleLoginTapped
            .bind { [weak self] in
                self?.presentGoogleLogin()
            }
            .disposed(by: disposeBag)

        loginView.appleLoginTapped
            .bind { [weak self] in
                self?.presentAppleLogin()
            }
            .disposed(by: disposeBag)
    }

    private func presentGoogleLogin() {
        guard let url = URL(string: "https://dev-learnmate.store/oauth2/authorization/google") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    private func presentAppleLogin() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    // MARK: - ASAuthorizationControllerDelegate
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userID = appleIDCredential.user
            let email = appleIDCredential.email
            let fullName = appleIDCredential.fullName

            if let tokenData = appleIDCredential.identityToken,
               let tokenString = String(data: tokenData, encoding: .utf8) {
                print("1️⃣ Identity Token: \(tokenString)")
            } else {
                print("Failed to decode identity token")
            }

            print("2️⃣ UserID: \(userID)")
            print("3️⃣ Email: \(email ?? "Not provided")")
            print("4️⃣ Full Name: \(fullName?.description ?? "Not provided")")

            viewModel.postAppleLogin(userID: userID, email: email)
        }
    }

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple Login Error: \(error.localizedDescription)")
    }

    // MARK: - ASAuthorizationControllerPresentationContextProviding
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }

    private func bindTransition() {
//        homeQuizView.onStartButtonTapped = { [weak self] indexPath in
//            let quizViewController = QuizViewController()
//            quizViewController.hidesBottomBarWhenPushed = true
//            self?.navigationController?.pushViewController(quizViewController, animated: true)
//        }
    }

    public override func setupViewProperty() {
        view.backgroundColor = CommonUIAssets.LMOrange4
    }

    public override func setupHierarchy() {
        view.addSubview(loginView)
    }

    public override func setupDelegate() {
    }

    public override func setupLayout() {
        loginView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
