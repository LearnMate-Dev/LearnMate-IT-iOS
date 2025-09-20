//
//  MyPageViewController.swift
//  MyPage
//
//  Created by 박지윤 on 7/1/25.
//

import CommonUI
import UIKit
import SnapKit
import RxSwift

public class MyPageViewController: BaseViewController {
    let viewModel: MyPageViewModel
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let myPageView = MyPageView()
    
    public var onLogout: (() -> Void)?
    
    public init(myPageViewModel: MyPageViewModel) {
        self.viewModel = myPageViewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        bindActions()
    }
    
    public override func setupViewProperty() {
        view.backgroundColor = .systemBackground
        
        scrollView.do {
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
        }
    }
    
    public override func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(myPageView)
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
        
        myPageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    public override func setupBind() {
        viewModel.onLogoutSuccess = { [weak self] in
            self?.onLogout?()
        }
    }
    
    private func bindActions() {
        myPageView.logoutButton.rx.tap
            .bind { [weak self] in
                self?.showLogoutAlert()
            }
            .disposed(by: disposeBag)
    }
    
    private func showLogoutAlert() {
        let alert = UIAlertController(title: "로그아웃", message: "정말 로그아웃 하시겠습니까?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "로그아웃", style: .destructive) { [weak self] _ in
            self?.viewModel.logout()
        })
        
        present(alert, animated: true)
    }
}