//
//  LoginView.swift
//  CommonUI
//
//  Created by 박지윤 on 7/16/25.
//

import Domain
import UIKit
import SnapKit
import RxSwift
import Then
import SafariServices
import RxRelay

open class LoginView: UIView, SFSafariViewControllerDelegate {
    let logoLabel = UILabel().then {
        $0.text = "경계선 지능인을 위한 케어 서비스,"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    var logoView = UIImageView()
    var googleLoginButton = UIButton()
    var appleLoginButton = UIButton()

    public let googleLoginTapped = PublishRelay<Void>()

    let disposeBag = DisposeBag()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initAttribute()
        initUI()
        bindEvents()
    }

    public func bind(course: CourseVO) {
    }

    func bindEvents() {
        googleLoginButton.rx.tap
            .bind(to: googleLoginTapped)
            .disposed(by: disposeBag)
    }

    func initAttribute() {
        self.backgroundColor = .white

        googleLoginButton = googleLoginButton.then {
            $0.backgroundColor = .blue
            $0.layer.cornerRadius = 12
        }

        appleLoginButton = appleLoginButton.then {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 12
        }
    }

    func initUI() {
        [logoLabel, logoView, googleLoginButton, appleLoginButton]
            .forEach { self.addSubview($0) }

        logoLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(130)
            $0.centerX.equalToSuperview()
        }

        logoView.snp.makeConstraints {
            $0.top.equalTo(logoLabel.snp.bottom)
            $0.centerX.equalToSuperview()
        }

        googleLoginButton.snp.makeConstraints {
            $0.bottom.equalTo(appleLoginButton.snp.top).offset(-40)
            $0.height.equalTo(60)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        appleLoginButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(60)
            $0.height.equalTo(60)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
