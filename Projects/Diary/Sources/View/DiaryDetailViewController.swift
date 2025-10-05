//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 박지윤 on 9/18/25.
//

import UIKit
import CommonUI
import Domain

public class DiaryDetailViewController: BaseViewController {
    let diaryDetailView = DiaryDetailView(isResult: false)
    let viewModel: DiaryViewModel

    let navigationBar = DefaultNavigationBar(leftImage: CommonUIAssets.IconBack ?? nil,
                                             rightImage: nil,
                                             title: "일기 상세")
    
    private let diaryData: DiaryVO
    
    public init(diaryViewModel: DiaryViewModel, diaryData: DiaryVO) {
        self.viewModel = diaryViewModel
        self.diaryData = diaryData
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViewProperty()
        setupHierarchy()
        setupLayout()
        bindEvents()
        configureData()
    }
    
    public override func setupViewProperty() {
    }
    
    public override func setupHierarchy() {
        view.addSubview(navigationBar)
        view.addSubview(diaryDetailView)
    }
    
    public override func setupDelegate() {
    }
    
    public override func setupLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.centerX.equalToSuperview()
        }

        diaryDetailView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    public override func setupBind() {
    }

    @objc private func handleRightButtonTapped() {
    }

    private func bindEvents() {
    }

    private func configureData() {
        diaryDetailView.configure(with: diaryData)
    }
}
