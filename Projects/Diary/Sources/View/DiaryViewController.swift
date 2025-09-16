//
//  DiaryViewController.swift
//  Diary
//
//  Created by 박지윤 on 7/1/25.
//

import UIKit
import CommonUI
import RxSwift
import Domain

public class DiaryViewController: BaseViewController {
    let viewModel: DiaryViewModel
    let diaryView = DiaryView()
    
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
        viewModel.getDiaryCalendar(year: 2025, month: 9)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CommonUIAssets.LMOrange4
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
        view.addSubview(diaryView)
    }
    
    public override func setupDelegate() {
    }
    
    public override func setupLayout() {
        diaryView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bindData() {
    }
    
    private func bindEvents() {
        diaryView.onAddButtonTapped = { [weak self] in
            self?.presentNewDiaryView()
        }
    }

    private func presentNewDiaryView() {
        let diaryAddViewController = DiaryAddViewController(diaryViewModel: viewModel)
        self.navigationController?.pushViewController(diaryAddViewController, animated: true)
    }
}
