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
import RxRelay

open class LoginView: UIView {
    let logoLabel = UILabel().then {
        $0.text = "경계선 지능인을 위한 케어 서비스,"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }

    let logoView = UIImageView().then {
        $0.image = CommonUIAssets.logo
        $0.contentMode = .scaleAspectFit
    }

    var loginButtonStackView = UIStackView()

    var lmLoginButton = LMButton(textColor: CommonUIAssets.LMBlack,
                                 bgColor: CommonUIAssets.LMOrange1)
    var googleLoginButton = LMButton(textColor: CommonUIAssets.LMBlack,
                                     bgColor: CommonUIAssets.LMWhite)
    var appleLoginButton = LMButton(textColor: CommonUIAssets.LMWhite,
                                    bgColor: CommonUIAssets.LMBlack)

    public let lmLoginTapped = PublishRelay<Void>()
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

        lmLoginButton.rx.tap
            .bind(to: lmLoginTapped)
            .disposed(by: disposeBag)
    }

    func initAttribute() {
        self.backgroundColor = .white

        loginButtonStackView = loginButtonStackView.then {
            $0.axis = .vertical
            $0.spacing = 20
            $0.distribution = .fillEqually
        }

        lmLoginButton = lmLoginButton.then {
            $0.setTitle("이메일로 로그인", for: .normal)
        }

        googleLoginButton = googleLoginButton.then {
            $0.setTitle("Google로 로그인", for: .normal)
            $0.setImage(CommonUIAssets.google?
                .resize(to: CGSize(width: 27, height: 27)), for: .normal)
            $0.layer.borderColor = CommonUIAssets.LMGray3?.cgColor
            $0.layer.borderWidth = 1
            $0.semanticContentAttribute = .forceLeftToRight
            $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
        }

        appleLoginButton = appleLoginButton.then {
            $0.setTitle("Apple로 로그인", for: .normal)
            $0.setImage(CommonUIAssets.apple?
                .resize(to: CGSize(width: 20, height: 20)), for: .normal)
            $0.semanticContentAttribute = .forceLeftToRight
            $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
        }
    }

    func initUI() {
        [logoLabel, logoView, loginButtonStackView]
            .forEach { self.addSubview($0) }

        [lmLoginButton]
            .forEach { loginButtonStackView.addArrangedSubview($0)}

        logoLabel.snp.makeConstraints {
            $0.bottom.equalTo(logoView.snp.top).offset(-15)
            $0.leading.equalTo(logoView.snp.leading)
        }

        logoView.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.centerY.equalToSuperview().offset(-50)
            $0.centerX.equalToSuperview()
        }

        loginButtonStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(55) // 205
            $0.bottom.equalToSuperview().inset(85) // 70
        }
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
