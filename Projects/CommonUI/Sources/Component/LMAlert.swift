//
//  LMAlert.swift
//  CommonUI
//
//  Created by 박지윤 on 9/14/25.
//

import UIKit
import SnapKit
import Then

public class LMAlert: UIView {
    
    // MARK: - UI Components
    private let backgroundView = UIView().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        $0.alpha = 0
    }
    
    private let containerView = UIView().then {
        $0.backgroundColor = UIColor.white
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 12
    }
    
    private let cancelButton = UIButton().then {
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        $0.setTitle("아니요", for: .normal)
    }
    
    private let confirmButton = UIButton().then {
        $0.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.6, alpha: 1.0) // 연한 주황색
        $0.layer.cornerRadius = 8
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        $0.setTitle("네", for: .normal)
    }
    
    // MARK: - Properties
    private var cancelAction: (() -> Void)?
    private var confirmAction: (() -> Void)?
    
    // MARK: - Initialization
    public init(title: String, cancelTitle: String = "아니요", confirmTitle: String = "네") {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
        configure(title: title, cancelTitle: cancelTitle, confirmTitle: confirmTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        addSubview(backgroundView)
        addSubview(containerView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(confirmButton)
        
        // 버튼 액션 설정
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        
        // 배경 탭 제스처
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    private func setupLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(280)
            $0.height.greaterThanOrEqualTo(140)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.lessThanOrEqualTo(buttonStackView.snp.top).offset(-16)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(44)
            $0.top.greaterThanOrEqualTo(titleLabel.snp.bottom).offset(16)
        }
    }
    
    private func configure(title: String, cancelTitle: String, confirmTitle: String) {
        // 줄간격을 적용한 attributed string 생성
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.alignment = .center
        
        let attributedString = NSAttributedString(
            string: title,
            attributes: [
                .font: UIFont.systemFont(ofSize: 16, weight: .medium),
                .foregroundColor: UIColor.black,
                .paragraphStyle: paragraphStyle
            ]
        )

        titleLabel.attributedText = attributedString
        cancelButton.setTitle(cancelTitle, for: .normal)
        confirmButton.setTitle(confirmTitle, for: .normal)
        
        // cancelTitle이 비어있으면 취소 버튼 숨기기
        if cancelTitle.isEmpty {
            cancelButton.isHidden = true
        }
    }
    
    // MARK: - Actions
    @objc private func cancelButtonTapped() {
        hide {
            self.cancelAction?()
        }
    }
    
    @objc private func confirmButtonTapped() {
        hide {
            self.confirmAction?()
        }
    }
    
    @objc private func backgroundTapped() {
        hide {
            self.cancelAction?()
        }
    }
    
    // MARK: - Public Methods
    public func setCancelAction(_ action: @escaping () -> Void) {
        self.cancelAction = action
    }
    
    public func setConfirmAction(_ action: @escaping () -> Void) {
        self.confirmAction = action
    }
    
    public func show(in view: UIView) {
        view.addSubview(self)
        self.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // 애니메이션으로 나타나기
        containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut) {
            self.backgroundView.alpha = 1
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        }
    }
    
    private func hide(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundView.alpha = 0
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            self.removeFromSuperview()
            completion()
        }
    }
}
