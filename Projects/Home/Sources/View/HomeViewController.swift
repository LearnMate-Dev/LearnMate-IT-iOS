//
//  HomeViewController.swift
//  Home
//
//  Created by 박지윤 on 7/1/25.
//

import CommonUI
import UIKit
import SnapKit
import RxSwift

public class HomeViewController: BaseViewController {
    let viewModel: HomeViewModel
    let scrollView = UIScrollView()
    let contentView = UIView()
    let homeView = HomeView()
    let homeProgressView = HomeProgressView()
    let homeQuizView = HomeQuizView()

    public init(homeViewModel: HomeViewModel) {
        self.viewModel = homeViewModel
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
    }

    public override func setupViewProperty() {
        view.backgroundColor = CommonUIAssets.LMOrange4

        scrollView.do {
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
        }
    }

    public override func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [homeView, homeProgressView, homeQuizView].forEach { contentView.addSubview($0) }
    }

    public override func setupDelegate() {
    }

    public override func setupLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        homeView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }

        homeProgressView.snp.makeConstraints {
            $0.top.equalTo(homeView.snp.bottom)
            $0.centerX.equalToSuperview()
        }

        homeQuizView.snp.makeConstraints {
            $0.top.equalTo(homeProgressView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(330)
            $0.width.bottom.equalToSuperview().inset(20)
        }
    }
}
