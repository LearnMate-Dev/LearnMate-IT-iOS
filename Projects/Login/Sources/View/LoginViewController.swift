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

public class LoginViewController: BaseViewController {
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
        bindActions()
        bindTransition()
    }

    private func bindActions() {
        
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
