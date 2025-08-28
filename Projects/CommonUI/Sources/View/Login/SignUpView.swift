//
//  SignUpView.swift
//  CommonUI
//
//  Created by 박지윤 on 8/24/25.
//

import Domain
import UIKit
import SnapKit
import RxSwift
import Then

open class SignUpView: UIView {
    var inputFieldStackView = UIStackView()

    let nameInputField = LMInputField(inputText: "이름",
                                      inputPlaceholder: "이름을 입력하세요",
                                      warningText: " 이름은 필수입니다")
    public let emailInputField = LMInputField(inputType: .email,
                                       inputText: "이메일",
                                       inputPlaceholder: " 이메일을 입력하세요",
                                       warningText: " 이메일 형식이 올바르지 않습니다",
                                       buttonTitle: "인증 요청")
    public let confirmInputField = LMInputField(inputType: .email,
                                       inputText: "인증번호",
                                       inputPlaceholder: " 인증번호를 입력하세요",
                                       warningText: " 인증번호가 일치하지 않습니다",
                                       buttonTitle: "확인")
    let passwordInputField = LMInputField(inputType: .password,
                                          inputText: "비밀번호",
                                          inputPlaceholder: "비밀번호를 입력하세요",
                                          warningText: " 비밀번호 형식이 올바르지 않습니다")
    let passwordCheckInputField = LMInputField(inputText: "비밀번호 확인",
                                               inputPlaceholder: "비밀번호를 한번 더 입력하세요",
                                               warningText: " 비밀번호가 일치하지 않습니다")

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initAttribute()
        initUI()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func bind(course: CourseVO) {
        
    }

    func initAttribute() {
        self.backgroundColor = .clear

        inputFieldStackView = inputFieldStackView.then {
            $0.axis = .vertical
            $0.spacing = 18
        }
    }

    func initUI() {
        self.addSubview(inputFieldStackView)

        [nameInputField, emailInputField, confirmInputField, passwordInputField, passwordCheckInputField]
            .forEach { inputFieldStackView.addArrangedSubview($0) }

        inputFieldStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(10)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(698)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}
