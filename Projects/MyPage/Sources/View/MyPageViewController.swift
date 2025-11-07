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
    let myPageView = MyPageView()
    let navigationBar = DefaultNavigationBar(leftImage: nil,
                                             rightImage: nil,
                                             title: "마이페이지")

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
        view.backgroundColor = CommonUIAssets.LMOrange4
        bindActions()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 마이페이지 진입 시 사용자 정보 로드
        viewModel.getUser()
    }
    
    public override func setupViewProperty() {
        view.backgroundColor = .systemBackground
    }
    
    public override func setupHierarchy() {
        [navigationBar, myPageView]
            .forEach { view.addSubview($0) }
    }
    
    public override func setupDelegate() {
    }
    
    public override func setupLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.centerX.equalToSuperview()
        }

        myPageView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    public override func setupBind() {
        // User data binding
        viewModel.userSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] user in
                print("📱 사용자 정보 로드 성공: \(user)")
                self?.myPageView.updateUserName(user.name, user.userId)
            })
            .disposed(by: disposeBag)
        
        viewModel.userErrorSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { error in
                print("❌ 사용자 정보 로드 실패: \(error)")
            })
            .disposed(by: disposeBag)
        
        // Logout binding
        viewModel.logoutSuccessSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                print("📱 로그아웃 성공")
                // 토큰 지우기
                self?.viewModel.clearTokens()
                // 로그인 화면으로 이동
                self?.onLogout?()
            })
            .disposed(by: disposeBag)
        
        viewModel.logoutErrorSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { error in
                print("❌ 로그아웃 실패: \(error)")
                // 에러 처리 로직 추가
            })
            .disposed(by: disposeBag)
        
        // Delete user binding
        viewModel.deleteUserSuccessSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                print("📱 회원탈퇴 성공")
                // 토큰 지우기
                self?.viewModel.clearTokens()
                // 로그인 화면으로 이동
                self?.onLogout?()
            })
            .disposed(by: disposeBag)
        
        viewModel.deleteUserErrorSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { error in
                print("❌ 회원탈퇴 실패: \(error)")
                // 에러 처리 로직 추가
            })
            .disposed(by: disposeBag)
    }
    
    private func bindActions() {
        myPageView.onGetUser = { [weak self] in
            self?.viewModel.getUser()
        }
        
        myPageView.onPostLogout = { [weak self] in
            self?.viewModel.logout()
        }
        
        myPageView.onDeleteUser = { [weak self] in
            self?.viewModel.deleteUser()
        }
    }
    
}
