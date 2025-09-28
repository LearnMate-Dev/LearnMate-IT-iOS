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
        self.tabBarController?.tabBar.isHidden = true
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
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
        print("🔄 일기 분석 시작")
        
        // 로딩 화면 표시
        loadingView.isHidden = false
        loadingView.alpha = 0
        navigationBar.isHidden = true
        
        UIView.animate(withDuration: 0.3) {
            self.loadingView.alpha = 1
        }
    }

    private func hideAnalysisLoading() {
        UIView.animate(withDuration: 0.3, animations: {
            self.loadingView.alpha = 0
        }) { _ in
            self.loadingView.isHidden = true
            self.navigationBar.isHidden = false
        }
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

    private func navigateToAnalysisResult(diaryData: DiaryVO) {
        print("📊 분석 결과 화면으로 이동")
        
        let diaryResultViewController = DiaryResultViewController(diaryViewModel: viewModel, diaryData: diaryData)
        diaryResultViewController.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(diaryResultViewController, animated: true)
    }

    private func bindData() {
        viewModel.onDiaryPostSuccess = { [weak self] diaryData in
            DispatchQueue.main.async {
                self?.hideAnalysisLoading()
                self?.navigateToAnalysisResult(diaryData: diaryData)
            }
        }
        
        viewModel.onDiaryPostFailure = { [weak self] error in
            DispatchQueue.main.async {
                self?.hideAnalysisLoading()
                self?.showToast(message: "  일기 작성에 실패했습니다. 다시 시도해주세요.  ")
            }
        }
    }
    
    private func bindEvents() {
        diaryAddView.onAddButtonTapped = { [weak self] content in
            guard let self = self else { return }
            
            if content.isEmpty {
                print("❌ 일기 내용이 비어있습니다")
                return
            }
            
            print("📝 일기 작성 요청: \(content)")
            self.showAnalysisLoading()
            self.viewModel.postDiary(content: content)
        }
    }
}
