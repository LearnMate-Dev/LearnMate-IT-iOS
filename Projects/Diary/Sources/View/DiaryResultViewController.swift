//
//  DiaryResultViewController.swift
//  Diary
//
//  Created by 박지윤 on 1/7/25.
//

import UIKit
import CommonUI
import Domain

public class DiaryResultViewController: BaseViewController {
    let diaryResultView = DiaryDetailView()
    let viewModel: DiaryViewModel

    let navigationBar = DefaultNavigationBar(leftImage: nil,
                                             rightImage: CommonUIAssets.IconClose ?? nil,
                                             title: "일기 맞춤법 검사 결과")
    
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
        navigationBar.rightButton.removeTarget(navigationBar, action: nil, for: .touchUpInside)
        navigationBar.rightButton.addTarget(self, action: #selector(handleRightButtonTapped), for: .touchUpInside)
    }

    @objc private func handleRightButtonTapped() {
        showExitConfirmationAlert()
    }

    private func showExitConfirmationAlert() {
        let lmAlert = LMAlert(title: "저장하지 않은 일기는 사라집니다.\n그래도 나가시겠습니까?")
        
        lmAlert.setCancelAction {
        }
        
        lmAlert.setConfirmAction { [weak self] in
            self?.deleteDiaryAndExit()
        }
        
        lmAlert.show(in: view)
    }

    private func deleteDiaryAndExit() {
        viewModel.deleteDiaryDetail(diaryId: diaryData.diaryId)

        dismiss(animated: true)
    }

    private func bindEvents() {
        diaryResultView.onSaveButtonTapped = { [weak self] in
            self?.handleSaveDiary()
        }
    }
    
    private func handleSaveDiary() {
        print("🔄 handleSaveDiary 호출됨")
        print("🔄 navigationController: \(String(describing: navigationController))")
        
        self.navigationController?.popToRootViewController(animated: true)
    }

    private func configureData() {
        diaryResultView.configure(with: diaryData)
    }
}
