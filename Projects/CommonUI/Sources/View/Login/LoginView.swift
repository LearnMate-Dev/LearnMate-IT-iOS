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
import AuthenticationServices

open class LoginView: UIView, SFSafariViewControllerDelegate {
    let logoLabel = UILabel().then {
        $0.text = "경계선 지능인을 위한 케어 서비스,"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }

    let logoView = UIImageView().then {
        $0.image = CommonUIAssets.logo
        $0.contentMode = .scaleAspectFit
    }

    var googleLoginButton = UIButton()
    var appleLoginButton = ASAuthorizationAppleIDButton(type: .default, style: .black)

    public let googleLoginTapped = PublishRelay<Void>()
    public let appleLoginTapped = PublishRelay<Void>()

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

        appleLoginButton.rx.controlEvent(.touchUpInside)
            .bind(to: appleLoginTapped)
            .disposed(by: disposeBag)
    }

    func initAttribute() {
        self.backgroundColor = .white

        googleLoginButton = googleLoginButton.then {
            $0.setTitle("Google로 시작하기", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.setImage(CommonUIAssets.google?
                .resize(to: CGSize(width: 25, height: 25)), for: .normal)
            $0.backgroundColor = .white
            $0.layer.borderColor = CommonUIAssets.LMGray3?.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 5
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            $0.semanticContentAttribute = .forceLeftToRight
            $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
        }
    }

    func initUI() {
        [logoLabel, logoView, googleLoginButton, appleLoginButton]
            .forEach { self.addSubview($0) }

        logoLabel.snp.makeConstraints {
            $0.bottom.equalTo(logoView.snp.top).offset(-15)
            $0.leading.equalTo(logoView.snp.leading)
        }

        logoView.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.centerY.equalToSuperview().offset(-50)
            $0.centerX.equalToSuperview()
        }

        googleLoginButton.snp.makeConstraints {
            $0.bottom.equalTo(appleLoginButton.snp.top).offset(-20)
            $0.height.equalTo(50)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        appleLoginButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(60)
            $0.height.equalTo(50)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
