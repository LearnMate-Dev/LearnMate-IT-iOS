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
    let diaryResultView = DiaryResultView()
    let viewModel: DiaryViewModel

    let navigationBar = DefaultNavigationBar(leftImage: CommonUIAssets.IconBack ?? nil,
                                             rightImage: CommonUIAssets.IconClose ?? nil,
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
        setupActions()
        bindEvents()
        configureData()
    }
    
    public override func setupViewProperty() {
    }
    
    public override func setupHierarchy() {
        view.addSubview(navigationBar)
        view.addSubview(diaryResultView)
    }
    
    public override func setupDelegate() {
    }
    
    public override func setupLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.centerX.equalToSuperview()
        }
        
        diaryResultView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    public override func setupBind() {
    }

    public func setupActions() {
        // 기존 타겟들을 모두 제거
        navigationBar.rightButton.removeTarget(navigationBar, action: nil, for: .touchUpInside)
        // 새로운 타겟 추가
        navigationBar.rightButton.addTarget(self, action: #selector(handleRightButtonTapped), for: .touchUpInside)
    }

    @objc private func handleRightButtonTapped() {
    }

    private func bindEvents() {
    }

    private func configureData() {
        diaryResultView.configure(with: diaryData)
    }
}
