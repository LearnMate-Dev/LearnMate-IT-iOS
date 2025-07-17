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
                isRightButtonHidden: Bool) {
        super.init(frame: .zero)
        setupUI()
        setupLayout()

        leftButton.setImage(leftImage, for: .normal)
        rightButton.setImage(leftImage, for: .normal)
        rightButton.isHidden = isRightButtonHidden
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
}

