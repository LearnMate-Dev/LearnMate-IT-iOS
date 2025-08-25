//
//  SignInView.swift
//  CommonUI
//
//  Created by 박지윤 on 8/24/25.
//

import Domain
import UIKit
import SnapKit
import RxSwift
import Then
import RxRelay

open class SignInView: UIView {
    let logoView = UIImageView().then {
        $0.image = CommonUIAssets.logo
        $0.contentMode = .scaleAspectFit
    }

    var textFieldStackView = UIStackView()
    var idTextField = LMTextField()
    var passwordTextField = LMTextField()
    var loginButton = LMButton(textColor: CommonUIAssets.LMBlack,
                               bgColor: CommonUIAssets.LMOrange1)
    var signUpButton = UIButton()

    public let signUpTapped = PublishRelay<Void>()
    private let disposeBag = DisposeBag()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initAttribute()
        initUI()
        bindEvents()
    }

    public func bind(course: CourseVO) {
        
    }

    func bindEvents() {
        signUpButton.rx.tap
            .bind(to: signUpTapped)
            .disposed(by: disposeBag)
    }

    func initAttribute() {
        self.backgroundColor = .clear

        textFieldStackView = textFieldStackView.then {
            $0.axis = .vertical
            $0.spacing = 20
            $0.distribution = .fillEqually
        }

        idTextField = idTextField.then {
            $0.placeholder = "아이디를 입력하세요"
        }

        passwordTextField = passwordTextField.then {
            $0.placeholder = "비밀번호를 입력하세요"
            $0.isSecureTextEntry = true
        }

        loginButton = loginButton.then {
            $0.setTitle("로그인", for: .normal)
        }

        let signUpButtonTitle = "회원가입"
        let attributedString = NSAttributedString(
            string: signUpButtonTitle,
            attributes: [
                .foregroundColor: CommonUIAssets.LMGray1,
                .font: UIFont.systemFont(ofSize: 16, weight: .regular),
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        )

        signUpButton = signUpButton.then {
            $0.setAttributedTitle(attributedString, for: .normal)
            $0.backgroundColor = .clear
        }
    }

    func initUI() {
        [logoView, textFieldStackView, loginButton, signUpButton]
            .forEach { addSubview($0) }

        [idTextField, passwordTextField]
            .forEach { textFieldStackView.addArrangedSubview($0) }

        logoView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(160)
        }

        textFieldStackView.snp.makeConstraints {
            $0.top.equalTo(logoView.snp.bottom).offset(100)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(130)
        }

        loginButton.snp.makeConstraints {
            $0.top.equalTo(textFieldStackView.snp.bottom).offset(33)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        signUpButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(35)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(27)
        }
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
