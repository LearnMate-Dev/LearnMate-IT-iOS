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
    let signViewModel: SignViewModel
    let navigationBar = DefaultNavigationBar(leftImage: CommonUIAssets.IconBack ?? nil,
                                             rightImage: nil,
                                             title: "회원가입",
                                             isRightButtonHidden: true)
    
    let scrollView = UIScrollView()
    let signUpView = SignUpView()
    let signUpButtonView = UIView()
    let signUpButton = LMButton(textColor: CommonUIAssets.LMBlack,
                                bgColor: CommonUIAssets.LMOrange1).then {
        $0.setTitle("회원가입", for: .normal)
    }

    public init(signViewModel: SignViewModel) {
        self.signViewModel = signViewModel
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
    }

    private func bindActions() {
        signUpView.emailInputField.onEmailButtonTapped = { email in
            self.signViewModel.postEmail(email: email)
        }
    }

    private func bindTransition() {
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
}
