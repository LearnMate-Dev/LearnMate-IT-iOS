//
//  HomeView.swift
//  CommonUI
//
//  Created by 박지윤 on 7/1/25.
//

import Domain
import UIKit
import SnapKit
import Then

open class HomeView: UIView {
    var superView = UIView()
    var courseLabel = UILabel()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initAttribute()
        initUI()
    }
    
    public func bind(course: CourseVO) {
        courseLabel.text = "bind"
    }

    func initAttribute() {
        self.backgroundColor = .yellow
        superView.backgroundColor = .green
        superView.layer.cornerRadius = 28
        superView.layer.masksToBounds = false

        courseLabel = courseLabel.then {
            $0.text = "init"
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 20, weight: .bold)
        }
    }

    func initUI() {
        self.addSubview(superView)

        superView.snp.makeConstraints {
            $0.width.height.equalTo(300)
            $0.top.equalToSuperview().inset(100)
            $0.centerX.equalToSuperview()
        }

        [courseLabel]
            .forEach { superView.addSubview($0) }

        courseLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
