//
//  HomeView.swift
//  CommonUI
//
//  Created by 박지윤 on 7/1/25.
//

import Domain
import UIKit
import SnapKit
import RxSwift
import Then

open class HomeView: UIView {
    let logoImageView = UIImageView()
    var profileView = UIImageView()
    var titleLabelStackView = UIStackView()
    var titleLabel = UILabel()
    var subtitleLabel = UILabel()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initAttribute()
        initUI()
    }

    public func bind(course: CourseVO) {
    }

    func initAttribute() {
        self.backgroundColor = .clear

        profileView = profileView.then {
            $0.image = CommonUIAssets.IconProfile
        }

        titleLabelStackView = titleLabelStackView.then {
            $0.axis = .vertical
            $0.spacing = 4
            $0.distribution = .fill
        }

        titleLabel = titleLabel.then {
            $0.text = "안녕하세요!"
            $0.textColor = CommonUIAssets.LMBlack
            $0.font = .systemFont(ofSize: 19, weight: .semibold)
        }

        subtitleLabel = subtitleLabel.then {
            $0.text = "오늘의 학습을 시작해볼까요?"
            $0.textColor = CommonUIAssets.LMGray1
            $0.font = .systemFont(ofSize: 13, weight: .regular)
        }
    }

    func initUI() {
        self.snp.makeConstraints {
            $0.height.equalTo(113)
        }

        [titleLabel, subtitleLabel]
            .forEach { titleLabelStackView.addArrangedSubview($0) }

        [profileView, titleLabelStackView]
            .forEach { self.addSubview($0) }

        profileView.snp.makeConstraints {
            $0.height.width.equalTo(56)
            $0.leading.equalTo(self.safeAreaInsets).inset(24)
            $0.top.equalToSuperview().inset(25)
        }

        titleLabelStackView.snp.makeConstraints {
            $0.leading.equalTo(profileView.snp.trailing).offset(10)
            $0.centerY.equalTo(profileView)
            $0.height.equalTo(49)
            $0.trailing.equalToSuperview().inset(20)
        }
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
