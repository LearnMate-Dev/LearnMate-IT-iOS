//
//  QuizCompleteAlertView.swift
//  CommonUI
//
//  Created by 박지윤 on 7/16/25.
//

import UIKit
import SnapKit
import Then

public final class QuizCompleteAlertView: UIView {

    private let backgroundView = UIView().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        $0.alpha = 0.0
    }

    private let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
    }

    private let titleLabel = UILabel().then {
        $0.text = "퀴즈 완료!"
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 20)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    private let messageLabel = UILabel().then {
        $0.text = "모든 질문에 잘 답변했어요 👏"
        $0.textColor = .darkGray
        $0.font = .systemFont(ofSize: 16)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    private let confirmButton = UIButton(type: .system).then {
        $0.setTitle("확인", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 8
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
        confirmButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.addSubview(backgroundView)
        self.addSubview(containerView)

        [titleLabel, messageLabel, confirmButton].forEach {
            containerView.addSubview($0)
        }
    }

    private func setupLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        confirmButton.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(20)
            $0.bottom.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(40)
        }
    }

    public func show(in parentView: UIView) {
        parentView.addSubview(self)
        self.snp.makeConstraints { $0.edges.equalToSuperview() }

        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 1.0
        }
    }

    @objc private func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = 0.0
        }) { _ in
            self.removeFromSuperview()
            if let viewController = self.findViewController() {
                if let navigationController = viewController.navigationController {
                    navigationController.popViewController(animated: true)
                } else {
                    viewController.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    private func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            if let vc = responder as? UIViewController {
                return vc
            }
            responder = responder?.next
        }
        return nil
    }
}
