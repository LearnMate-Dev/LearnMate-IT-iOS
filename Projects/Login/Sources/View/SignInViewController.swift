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
//    let viewModel: LoginViewModel
    let navigationBar = DefaultNavigationBar(leftImage: CommonUIAssets.IconBack ?? nil,
                                             rightImage: nil,
                                             title: nil,
                                             isRightButtonHidden: true)

    let signInView = SignInView()

    public override init() {
//        self.viewModel = loginViewModel
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(, animated: false)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        bindActions()
        bindTransition()
    }

    private func bindActions() {
    }

    private func bindTransition() {
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
}
