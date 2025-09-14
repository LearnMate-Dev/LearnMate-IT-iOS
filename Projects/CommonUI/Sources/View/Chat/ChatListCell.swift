//
//  ChatListCell.swift
//  CommonUI
//
//  Created by 박지윤 on 9/10/25.
//

import UIKit

class ChatListCell: UITableViewCell {

    private let profileIconView = UIImageView().then {
        $0.image = CommonUIAssets.IconBubble
    }

    private let labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 5
    }

    private let titleLabel = UILabel().then {
        $0.textColor = CommonUIAssets.LMGray1
        $0.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }

    private let dateLabel = UILabel().then {
        $0.textColor = CommonUIAssets.LMGray4
        $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0))
        backgroundColor = CommonUIAssets.LMWhite
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = CommonUIAssets.LMGray4?.cgColor
        selectionStyle = .none
        
        [profileIconView, labelStackView].forEach { addSubview($0) }
        [titleLabel, dateLabel].forEach { labelStackView.addArrangedSubview($0) }

        profileIconView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(25)
        }

        labelStackView.snp.makeConstraints {
            $0.leading.equalTo(profileIconView.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
        }
    }

    func configure(title: String, date: String) {
        titleLabel.text = title
        dateLabel.text = date
    }
}
