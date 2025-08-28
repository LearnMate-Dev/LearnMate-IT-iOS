//
//  LMInputField.swift
//  CommonUI
//
//  Created by 박지윤 on 8/25/25.
//

import UIKit

public class LMInputField: UIStackView {

    public var onEmailButtonTapped: ((String) -> Void)?

    public enum InputType {
        case email
        case password
    }

    private var inputTextLabel = UILabel()
    private var inputTextField = LMTextField()
    private var warningLabel = UILabel()
    private var inputText: String?
    private var inputPlaceholder: String?
    private var waringText: String?
    private var inputType: InputType?
    private var buttonTitle: String?

    public init(inputType: InputType? = nil,
                inputText: String?,
                inputPlaceholder: String?,
                warningText: String?,
                buttonTitle: String? = ""
    ) {
        self.inputType = inputType
        self.inputText = inputText
        self.inputPlaceholder = inputPlaceholder
        self.waringText = warningText
        self.buttonTitle = buttonTitle
        super.init(frame: .zero)
        initUI()
        initAttribute()
    }

    public required init(coder: NSCoder) {
        super.init(coder: coder)
        initUI()
        initAttribute()
    }

    private func initAttribute() {
        self.axis = .vertical
        self.spacing = 10
        self.alignment = .leading

        inputTextLabel = inputTextLabel.then {
            $0.text = inputText
            $0.textColor = CommonUIAssets.LMBlack
            $0.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        }

        inputTextField = inputTextField.then {
            $0.placeholder = inputPlaceholder
        }

        warningLabel = warningLabel.then {
            $0.text = waringText
            $0.textColor = .clear
            $0.font = UIFont.systemFont(ofSize: 13, weight: .light)
        }
    }

    private func initUI() {
        switch inputType {
        case .email:
            setEmailUI(buttonTitle: buttonTitle ?? "")
        case .password:
            setPasswordUI()
        case nil:
            setDefaultUI()
        }
    }

    private func setEmailUI(buttonTitle: String) {
        let emailStackView = UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = 12
            $0.distribution = .fill
        }

        let emailButton = LMButton(textColor: CommonUIAssets.LMBlack,
                                   bgColor: CommonUIAssets.LMOrange1).then {
            $0.setTitle(buttonTitle, for: .normal)
            $0.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        }

        [inputTextField, emailButton]
            .forEach { emailStackView.addArrangedSubview($0) }

        [inputTextLabel, emailStackView, warningLabel]
            .forEach { self.addArrangedSubview($0) }

        self.snp.makeConstraints {
            $0.height.equalTo(122)
        }

        emailStackView.snp.makeConstraints {
            $0.height.equalTo(55)
            $0.width.equalToSuperview()
        }

        emailButton.snp.makeConstraints {
            $0.width.equalTo(95)
        }
    }

    private func setPasswordUI() {
        let descriptionLabel = UILabel().then {
            $0.text = "영문 소문자, 숫자, 특수문자를 포함해 8자 이상 입력해주세요"
            $0.textColor = CommonUIAssets.LMGray4
            $0.font = UIFont.systemFont(ofSize: 12, weight: .light)
        }

        [inputTextLabel, descriptionLabel, inputTextField, warningLabel]
            .forEach { self.addArrangedSubview($0) }

        self.setCustomSpacing(8, after: descriptionLabel)

        self.snp.makeConstraints {
            $0.height.equalTo(138)
        }

        self.inputTextField.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
    }

    private func setDefaultUI() {
        [inputTextLabel, inputTextField, warningLabel]
            .forEach { self.addArrangedSubview($0) }

        self.snp.makeConstraints {
            $0.height.equalTo(122)
        }

        self.inputTextField.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
    }

    @objc private func emailButtonTapped() {
        onEmailButtonTapped?(inputTextField.text ?? "")
    }

    public func showWarning() {
        warningLabel.textColor = CommonUIAssets.LMRed2
    }

        public func hideWarning() {
        warningLabel.textColor = .clear
    }
    
    public func currentText() -> String {
        return inputTextField.text ?? ""
    }
    
    public func disableButton(buttonTitle: String) {
        for subview in self.arrangedSubviews {
            if let stackView = subview as? UIStackView {
                for stackSubview in stackView.arrangedSubviews {
                    if let textField = stackSubview as? LMTextField {
                        textField.isEnabled = false
                    }

                    if let button = stackSubview as? LMButton {
                        button.setTitle(buttonTitle, for: .normal)
                        button.isEnabled = false
                        button.backgroundColor = CommonUIAssets.LMGray5
                        button.setTitleColor(CommonUIAssets.LMWhite, for: .normal)
                    }
                }
            }
        }
    }
}
