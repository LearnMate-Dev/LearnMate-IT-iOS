//
//  MyPageView.swift
//  CommonUI
//
//  Created by 박지윤 on 7/1/25.
//

import UIKit
import SnapKit
import Then

open class MyPageView: UIView {
    public let logoutButton = UIButton().then {
        $0.setTitle("로그아웃", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemRed
        $0.layer.cornerRadius = 8
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        backgroundColor = .systemBackground
        
        addSubview(logoutButton)
        
        logoutButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
    }
}
