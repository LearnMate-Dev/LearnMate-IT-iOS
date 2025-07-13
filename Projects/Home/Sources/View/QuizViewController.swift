//
//  QuizViewController.swift
//  Home
//
//  Created by 박지윤 on 7/12/25.
//

import CommonUI
import UIKit
import SnapKit
import RxSwift

public class QuizViewController: UIViewController {
    let navigationBar = DefaultNavigationBar(leftImage: CommonUIAssets.IconBack ?? nil,
                                             rightImage: nil,
                                             isRightButtonHidden: true)
    let scrollView = UIScrollView()
    let contentView = UIView()
    let logoImageView = UIImageView().then {
        $0.image = CommonUIAssets.smallLogo
        $0.contentMode = .scaleAspectFit
    }
    let homeView = HomeView()
    let homeProgressView = HomeProgressView()
    let homeQuizView = HomeQuizView()

//    public init(homeViewModel: HomeViewModel) {
//        self.viewModel = homeViewModel
//        super.init()
//    }
    init() {
        super.init(nibName: nil, bundle: nil)
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
        setupViewProperty()
        setupHierarchy()
        setupLayout()
        bindDatas()
    }

    public func setupViewProperty() {
        view.backgroundColor = CommonUIAssets.LMOrange4

        scrollView.do {
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
        }
    }

    public func setupHierarchy() {
        view.addSubview(navigationBar)
    }

    public func setupDelegate() {
    }

    public func setupLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.centerX.equalToSuperview()
        }
    }

    func bindDatas() {
        navigationBar.setupViewProperty(title: "처음 보는 사람과 인사하기")
    }
}
