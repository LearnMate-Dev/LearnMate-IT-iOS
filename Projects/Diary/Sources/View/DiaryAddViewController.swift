//
//  DiaryAddViewController.swift
//  Diary
//
//  Created by 박지윤 on 9/16/25.
//

import UIKit
import CommonUI
import RxSwift
import Domain

public class DiaryAddViewController: BaseViewController {
    let viewModel: DiaryViewModel
    let diaryAddView = DiaryAddView()
    let loadingView = DiaryLoadingView()

    let navigationBar = DefaultNavigationBar(leftImage: CommonUIAssets.IconBack ?? nil,
                                             rightImage: nil,
                                             title: "일기 작성")

    public init(diaryViewModel: DiaryViewModel) {
        self.viewModel = diaryViewModel
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
        view.backgroundColor = CommonUIAssets.LMWhite
        navigationController?.navigationBar.isHidden = true
        setupViewProperty()
        setupHierarchy()
        setupLayout()
        bindData()
        bindEvents()
    }
    
    public override func setupViewProperty() {
    }
    
    public override func setupHierarchy() {
        [navigationBar, diaryAddView, loadingView]
            .forEach { view.addSubview($0) }
    }
    
    public override func setupDelegate() {
    }
    
    public override func setupLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.centerX.equalToSuperview()
        }

        diaryAddView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }

        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        navigationBar.isHidden = false
        loadingView.isHidden = true
    }

    private func showAnalysisLoading() {
        print("🔄 대화 분석 시작")
        
        // 로딩 화면 표시
        loadingView.isHidden = false
        loadingView.alpha = 0
        navigationBar.isHidden = true
        
        UIView.animate(withDuration: 0.3) {
            self.loadingView.alpha = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.hideAnalysisLoading()
        }
    }

    private func hideAnalysisLoading() {
        UIView.animate(withDuration: 0.3, animations: {
            self.loadingView.alpha = 0
        }) { _ in
            self.loadingView.isHidden = true
        }
    }

    private func navigateToAnalysisResult() {
        print("📊 분석 결과 화면으로 이동")

//        let diaryResultViewController = DiaryResultViewController(chatViewModel: viewModel)
//        diaryResultViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
//
//        present(diaryResultViewController, animated: true)
    }

    private func bindData() {
    }
    
    private func bindEvents() {
//        diaryAddView.onAddButtonTapped = { [weak self] text in
//            self?.viewModel.sendMessage(text)
//        }
    }
}
