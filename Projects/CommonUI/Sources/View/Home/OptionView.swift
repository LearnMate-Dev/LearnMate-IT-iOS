//
//  OptionView.swift
//  CommonUI
//
//  Created by 박지윤 on 7/15/25.
//

import Domain
import UIKit
import SnapKit
import RxSwift
import Then

open class OptionView: UIView {
    var optionView = UIView()
    var optionLabel = UILabel()

    private let options = [
        "응. 너는 누구야?",
        "네, 안녕하세요. 처음 뵙겠습니다.",
        "왜요?"
    ]

    public init(text: String) {
        super.init(frame: .zero)
        initAttribute()
        initUI()
        bindDatas(text: text)
    }

    public func bindDatas(text: String) {
        optionLabel.text = text
    }

    public func bind(course: CourseVO) {
    }

    func initAttribute() {
        optionView = optionView.then {
            $0.layer.borderColor = CommonUIAssets.LMOrange1?.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 12
            $0.backgroundColor = .white
        }

        optionLabel = optionLabel.then {
            $0.textColor = CommonUIAssets.LMGray1
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 13, weight: .regular)
            $0.numberOfLines = 0
            $0.setContentHuggingPriority(.required, for: .vertical)
            $0.setContentCompressionResistancePriority(.required, for: .vertical)
        }
    }

    func initUI() {
        self.addSubview(optionView)
        optionView.addSubview(optionLabel)

        optionView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(100)
            $0.trailing.equalToSuperview().inset(20)
        }

        optionLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.verticalEdges.equalToSuperview().inset(12)
        }
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
