//
//  SignInViewController.swift
//  Login
//
//  Created by 박지윤 on 8/25/25.
//

import CommonUI
import UIKit
import SnapKit
import RxSwift

public class SignInViewController: BaseViewController {
    let viewModel: SignViewModel

    let navigationBar = DefaultNavigationBar(leftImage: CommonUIAssets.IconBack ?? nil,
                                             rightImage: nil,
                                             title: nil)

    let signInView = SignInView()
    public var onPresentSignUp: (() -> Void)?
    public var onLoginSuccess: (() -> Void)?

    public init(signViewModel: SignViewModel) {
        self.viewModel = signViewModel
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        bindActions()
        bindTransition()
        setupTapGesture()
    }

    private func bindActions() {
        signInView.signInTapped
            .bind { [weak self] in
                guard let self = self else { return }

                let email = self.signInView.idTextField.currentText()
                let password = self.signInView.passwordTextField.currentText()

                self.postSignIn(email: email, password: password)
            }
            .disposed(by: disposeBag)

        signInView.signUpTapped
            .bind { [weak self] in
                self?.presentSignUp()
            }
            .disposed(by: disposeBag)
    }

    private func postSignIn(email: String, password: String) {
        self.viewModel.postSignIn(email: email,
                                  password: password)
    }

    private func presentSignUp() {
        onPresentSignUp?()
    }

    private func bindTransition() {
        viewModel.onSignInSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.onLoginSuccess?()
            }
        }

        viewModel.onSignInFailure = { [weak self] message in
            DispatchQueue.main.async {
                self?.showFailureAlert(message: message)
            }
        }
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    public override func setupViewProperty() {
        view.backgroundColor = CommonUIAssets.LMWhite
    }

    public override func setupHierarchy() {
        [navigationBar, signInView]
            .forEach { view.addSubview($0) }
    }

    public override func setupDelegate() {
    }

    public override func setupLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.centerX.equalToSuperview()
        }

        signInView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }

    private func showFailureAlert(message: String) {
        let alertView = LMAlert(title: message,
                                cancelTitle: "",
                                confirmTitle: "확인")
        alertView.show(in: view)
    }
}
