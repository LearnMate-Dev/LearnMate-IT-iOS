//
//  SignUpViewController.swift
//  Login
//
//  Created by 박지윤 on 8/25/25.
//

import CommonUI
import UIKit
import SnapKit
import RxSwift

public class SignUpViewController: BaseViewController {
    let viewModel: SignViewModel
    public weak var signUpViewCoordinator: SignUpCoordinator?

    let navigationBar = DefaultNavigationBar(leftImage: CommonUIAssets.IconBack ?? nil,
                                             rightImage: nil,
                                             title: "회원가입")
    
    let scrollView = UIScrollView()
    let signUpView = SignUpView()
    let signUpButtonView = UIView()
    let signUpButton = LMButton(textColor: CommonUIAssets.LMBlack,
                                bgColor: CommonUIAssets.LMOrange1).then {
        $0.setTitle("회원가입", for: .normal)
    }
    private var email: String = ""

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
        setupKeyboardDismissGesture()

        viewModel.onEmailSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.signUpView.emailInputField.disableButton(buttonTitle: "전송 완료")
            }
        }

        viewModel.onConfirmSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.signUpView.confirmInputField.hideWarning()
                self?.signUpView.confirmInputField.disableButton(buttonTitle: "인증 완료")
            }
        }

        viewModel.onConfirmFailure = { [weak self] in
            DispatchQueue.main.async {
                self?.signUpView.confirmInputField.showWarning()
            }
        }

        viewModel.onSignUpSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.showSignUpSuccessModal()
            }
        }

        viewModel.onSignUpFailure = { [weak self] message in
            DispatchQueue.main.async {
                self?.showFailureAlert(message: message)
            }
        }
    }

    private func bindActions() {
        signUpView.emailInputField.onEmailButtonTapped = { [weak self] email in
            guard let self = self else { return }

            if self.isValidEmail(email) {
                print("유효한 이메일: \(email)")
                self.email = email
                self.viewModel.postEmail(email: email)
                self.signUpView.emailInputField.disableButton(buttonTitle: "전송중..")
                self.signUpView.emailInputField.hideWarning()
            } else {
                print("유효하지 않은 이메일: \(email)")
                self.signUpView.emailInputField.showWarning()
            }
        }

        signUpView.confirmInputField.onEmailButtonTapped = { [weak self] code in
            guard let self = self else { return }

            self.viewModel.postConfirm(email: email, code: code)
        }

        signUpButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }

                let name = self.signUpView.nameInputField.currentText()
                let email = self.signUpView.emailInputField.currentText()
                let password = self.signUpView.passwordInputField.currentText()
                let confirm = self.signUpView.passwordCheckInputField.currentText()

                print("회원가입 버튼 탭 - name: \(name), email: \(email), password: \(password), confirm: \(confirm)")

                // 조건 체크
                let isNameValid = !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                let isEmailVerified = !self.email.isEmpty // 이메일 인증 완료 여부
                let isPasswordValid = self.isValidPassword(password)
                let isConfirmValid = !password.isEmpty && password == confirm

                if isNameValid && isEmailVerified && isPasswordValid && isConfirmValid {
                    self.postSignUp(username: name, email: email, password: password)
                } else {
                    print("회원가입 조건 미충족")
                }
            })
            .disposed(by: disposeBag)
    }

    private func postSignUp(username: String, email: String, password: String) {
        self.viewModel.postSignUp(username: username, email: email, password: password)
    }

    private func bindTransition() {
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    public override func setupViewProperty() {
        view.backgroundColor = CommonUIAssets.LMWhite
    }

    public override func setupHierarchy() {
        [navigationBar, scrollView, signUpButtonView]
            .forEach { view.addSubview($0) }

        scrollView.addSubview(signUpView)
        signUpButtonView.addSubview(signUpButton)
    }

    public override func setupDelegate() {
    }
    
    private func setupKeyboardDismissGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
        validateOnKeyboardDismiss()
    }

    private func validateOnKeyboardDismiss() {
        let name = signUpView.nameInputField.currentText()
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            signUpView.nameInputField.showWarning()
        } else {
            signUpView.nameInputField.hideWarning()
        }

        let password = signUpView.passwordInputField.currentText()
        if isValidPassword(password) {
            signUpView.passwordInputField.hideWarning()
        } else {
            signUpView.passwordInputField.showWarning()
        }

        let confirm = signUpView.passwordCheckInputField.currentText()
        if !password.isEmpty && password == confirm {
            signUpView.passwordCheckInputField.hideWarning()
        } else {
            signUpView.passwordCheckInputField.showWarning()
        }
    }

    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*\\d)(?=.*[!@#$%^&*(),.?\":{}|<>])[A-Za-z\\d!@#$%^&*(),.?\":{}|<>]{8,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return predicate.evaluate(with: password)
    }

    public override func setupLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.centerX.equalToSuperview()
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(signUpButtonView.snp.top)
        }

        signUpView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }

        signUpButtonView.snp.makeConstraints {
            $0.height.equalTo(55)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        signUpButton.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
    }
    
    private func showSignUpSuccessModal() {
        let alertView = LMAlert(title: "회원가입이 완료되었습니다!", 
                               cancelTitle: "", 
                               confirmTitle: "확인")
        alertView.setConfirmAction { [weak self] in
            self?.navigateToSignIn()
        }
        alertView.show(in: view)
    }
    
    private func navigateToSignIn() {
        navigationController?.popViewController(animated: true)
    }

    private func showFailureAlert(message: String) {
        let alertView = LMAlert(title: message,
                                cancelTitle: "",
                                confirmTitle: "확인")
        alertView.show(in: view)
    }
}
