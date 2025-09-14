//
//  DefaultNavigationBar.swift
//  CommonUI
//
//  Created by 박지윤 on 7/13/25.
//

import UIKit
import SnapKit
import Then

public final class DefaultNavigationBar: UIView {
    public let leftButton = UIButton()
    public let rightButton = UIButton()
    public let titleLabel = UILabel()

    public init(leftImage: UIImage?,
                rightImage: UIImage?,
                title: String?) {
        super.init(frame: .zero)
        setupUI()
        setupLayout()

        leftButton.setImage(leftImage, for: .normal)
        rightButton.setImage(rightImage, for: .normal)
        titleLabel.text = title

        leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear

        leftButton.setTitle(nil, for: .normal)
        rightButton.setTitle(nil, for: .normal)

        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center

        addSubview(leftButton)
        addSubview(rightButton)
        addSubview(titleLabel)
    }

    private func setupLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(45)
        }

        leftButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(44)
        }

        rightButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(44)
        }

        titleLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }

    public func setupViewProperty(title: String) {
        titleLabel.text = title
    }

    @objc public func leftButtonTapped() {
        if let viewController = findViewController() {
            viewController.navigationController?.popViewController(animated: true)
        }
    }

    @objc public func rightButtonTapped() {
        if let viewController = findViewController() {
            viewController.navigationController?.popToRootViewController(animated: true)
        }
    }

    private func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }
}

