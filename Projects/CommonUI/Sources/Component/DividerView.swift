//
//  DividerView.swift
//  CommonUI
//
//  Created by 박지윤 on 9/14/25.
//

import UIKit

enum Divider {
    case thin
    case thick

    var height: CGFloat {
        switch self {
        case .thin:
            return 1.0
        case .thick:
            return 8.0
        }
    }

    var color: UIColor {
        return CommonUIAssets.LMGray5 ?? .lightGray
    }
}

class DividerView: UIView {

    // MARK: UI Component
    private let dividerView = UIView()
 
    // MARK: Properties
    private var dividerType: Divider

    // MARK: Initializer
    init(dividerType: Divider) {
        self.dividerType = dividerType
        super.init(frame: .zero)

        configureSubviews()
        makeConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Configuration
    func configureSubviews() {
        dividerView.backgroundColor = dividerType.color

        addSubview(dividerView)
    }

    // MARK: Layout
    func makeConstraints() {
        dividerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(dividerType.height)
        }
    }
}
