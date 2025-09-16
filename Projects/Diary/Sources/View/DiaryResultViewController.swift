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
    let diaryResultView = DiaryResultView()
    let viewModel: DiaryViewModel

    let navigationBar = DefaultNavigationBar(leftImage: nil,
                                             rightImage: CommonUIAssets.IconClose ?? nil,
                                             title: "일기 분석 결과")
    
    private let diaryData: DiaryVO
    
    public init(diaryViewModel: DiaryViewModel, diaryData: DiaryVO) {
        self.viewModel = diaryViewModel
        self.diaryData = diaryData
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
        view.backgroundColor = CommonUIAssets.LMOrange4
        navigationController?.navigationBar.isHidden = true
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

        // 모달 닫기
        dismiss(animated: true)
    }

    private func bindEvents() {
        // leftButton이 nil이므로 이벤트 바인딩 제거
        // navigationBar.leftButton.rx.tap
        //     .subscribe(onNext: { [weak self] in
        //         self?.navigationController?.popViewController(animated: true)
        //     })
        //     .disposed(by: disposeBag)
        
        diaryResultView.onSaveButtonTapped = { [weak self] in
            self?.handleSaveDiary()
        }
    }
    
    private func handleSaveDiary() {
        self.navigationController?.popViewController(animated: true)

    }
    
    private func showToast(message: String) {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 16)
        toastLabel.text = message
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 8
        toastLabel.clipsToBounds = true
        
        view.addSubview(toastLabel)
        
        toastLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(100)
            $0.width.lessThanOrEqualToSuperview().inset(40)
            $0.height.greaterThanOrEqualTo(50)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 2.0, animations: {
                toastLabel.alpha = 0.0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
    
    private func configureData() {
        diaryResultView.configure(with: diaryData)
    }
}
