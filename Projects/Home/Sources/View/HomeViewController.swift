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
    let homeView = HomeView()
    let homeProgressView = HomeProgressView()
    var courseLabel = UILabel()

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

        courseLabel = courseLabel.then {
            $0.text = "1단계 퀴즈"
            $0.textColor = CommonUIAssets.LMBlack
            $0.font = .systemFont(ofSize: 16, weight: .regular)
        }
    }

    public override func setupHierarchy() {
        [homeView, homeProgressView, courseLabel].forEach { view.addSubview($0) }
    }

    public override func setupDelegate() {
    }

    public override func setupLayout() {
        homeView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }

        homeProgressView.snp.makeConstraints {
            $0.top.equalTo(homeView.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }

        courseLabel.snp.makeConstraints {
            $0.top.equalTo(homeProgressView.snp.bottom).offset(30)
            $0.leading.equalTo(30)
        }
    }

    public override func setupBind() {
//        courseLabel.text = "" + "단계 퀴즈"
    }
}
