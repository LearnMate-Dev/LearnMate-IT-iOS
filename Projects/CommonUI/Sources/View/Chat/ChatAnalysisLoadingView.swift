//
//  ChatAnalysisLoadingView.swift
//  CommonUI
//
//  Created by 박지윤 on 7/2/25.
//

import UIKit
import SnapKit
import Then

open class ChatAnalysisLoadingView: UIView {
    
    private let loadingSpinner = UIActivityIndicatorView(style: .large).then {
        $0.color = CommonUIAssets.LMGray1
        $0.startAnimating()
    }
    
    private let mainLabel = UILabel().then {
        $0.text = "사용자 대화를 분석 중입니다..."
        $0.textColor = CommonUIAssets.LMGray1
        $0.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        $0.textAlignment = .center
    }
    
    private let subLabel = UILabel().then {
        $0.text = "잠시만 기다려 주세요"
        $0.textColor = CommonUIAssets.LMGray3
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textAlignment = .center
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = CommonUIAssets.LMOrange4
        
        [loadingSpinner, mainLabel, subLabel].forEach { addSubview($0) }
        
        loadingSpinner.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-40)
        }
        
        mainLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(loadingSpinner.snp.bottom).offset(20)
        }
        
        subLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(mainLabel.snp.bottom).offset(8)
        }
    }
} 