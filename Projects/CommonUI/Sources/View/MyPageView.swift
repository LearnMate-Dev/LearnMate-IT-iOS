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
    
    // MARK: UI Components    
    private let tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.register(MyPageTableViewCell.self, forCellReuseIdentifier: MyPageTableViewCell.identifier)
    }
    
    // MARK: Properties
    private var sections: [MyPageSection] = []
    
    // MARK: Public Properties
    public var onGetUser: (() -> Void)?
    public var onPostLogout: (() -> Void)?
    public var onDeleteUser: (() -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupData()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = CommonUIAssets.LMWhite

        self.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self

        setupConstraints()
    }

    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupData() {
        sections = [
            MyPageSection(
                title: "내 정보",
                items: [
                    MyPageItem(title: "내 정보", icon: "person.fill", hasChevron: false),
                    MyPageItem(title: "사용자 이름", subtitle: "", hasChevron: false)
                ]
            ),
            MyPageSection(
                title: "앱 정보",
                items: [
                    MyPageItem(title: "앱 정보", icon: "info.circle.fill", hasChevron: false),
                    MyPageItem(title: "앱 버전", subtitle: "v 1.0.0", hasChevron: false)
                ]
            ),
            MyPageSection(
                title: "계정 관리",
                items: [
                    MyPageItem(title: "로그아웃", hasChevron: true),
                    MyPageItem(title: "회원탈퇴", hasChevron: true)
                ]
            )
        ]
        
        tableView.reloadData()
    }
    
    // MARK: - Public Methods
    public func updateUserName(_ name: String) {
        // "내 정보" 섹션의 두 번째 아이템(사용자 이름) 업데이트
        if sections.count > 0 && sections[0].items.count > 1 {
            var updatedItems = sections[0].items
            updatedItems[1] = MyPageItem(title: "사용자 이름", subtitle: name, hasChevron: false)
            sections[0] = MyPageSection(title: sections[0].title, items: updatedItems)
            tableView.reloadData()
        }
    }
    
    // MARK: - Modal Methods
    private func showLogoutConfirmation() {
        let alert = LMAlert(
            title: "정말로 로그아웃하시겠습니까?",
            cancelTitle: "취소",
            confirmTitle: "확인"
        )
        
        alert.setCancelAction { [weak self] in
            // 취소 액션 - 아무것도 하지 않음
        }
        
        alert.setConfirmAction { [weak self] in
            self?.onPostLogout?()
        }
        
        // 현재 뷰 컨트롤러 찾기
        if let topViewController = findTopViewController() {
            alert.show(in: topViewController.view)
        }
    }
    
    private func showWithdrawalConfirmation() {
        let alert = LMAlert(
            title: "정말로 회원탈퇴하시겠습니까?\n탈퇴 후에는 모든 데이터가 삭제되며 복구할 수 없습니다.",
            cancelTitle: "취소",
            confirmTitle: "확인"
        )
        
        alert.setCancelAction { [weak self] in
            // 취소 액션 - 아무것도 하지 않음
        }
        
        alert.setConfirmAction { [weak self] in
            self?.onDeleteUser?()
        }
        
        // 현재 뷰 컨트롤러 찾기
        if let topViewController = findTopViewController() {
            alert.show(in: topViewController.view)
        }
    }
    
    private func findTopViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return nil
        }
        
        var topViewController = window.rootViewController
        
        while let presentedViewController = topViewController?.presentedViewController {
            topViewController = presentedViewController
        }
        
        return topViewController
    }
}

// MARK: - UITableViewDataSource
extension MyPageView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.identifier, for: indexPath) as! MyPageTableViewCell
        let item = sections[indexPath.section].items[indexPath.row]
        
        // 마지막 섹션의 마지막 셀이거나, 섹션의 마지막 셀이 아닌 경우 디바이더 숨김
        let isLastSection = indexPath.section == sections.count - 1
        let isLastRowInSection = indexPath.row == sections[indexPath.section].items.count - 1
        let shouldHideDivider = isLastSection || !isLastRowInSection
        
        cell.configure(with: item, isLastCell: shouldHideDivider)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MyPageView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = sections[indexPath.section].items[indexPath.row]
        
        switch item.title {
        case "내 정보":
            onGetUser?()
        case "로그아웃":
            showLogoutConfirmation()
        case "회원탈퇴":
            showWithdrawalConfirmation()
        default:
            break
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let separatorView = UIView().then {
            $0.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        }
        
        headerView.addSubview(separatorView)
        separatorView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - Data Models
private struct MyPageSection {
    let title: String
    let items: [MyPageItem]
}

private struct MyPageItem {
    let title: String
    let subtitle: String?
    let icon: String?
    let hasChevron: Bool
    
    init(title: String, subtitle: String? = nil, icon: String? = nil, hasChevron: Bool = false) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.hasChevron = hasChevron
    }
}

// MARK: - Custom Cell
private class MyPageTableViewCell: UITableViewCell {
    static let identifier = "MyPageTableViewCell"
    
    private let iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = CommonUIAssets.LMOrange1
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textColor = CommonUIAssets.LMBlack
    }
    
    private let subtitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textColor = CommonUIAssets.LMBlack
    }
    
    private let chevronImageView = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.right")
        $0.tintColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        $0.contentMode = .scaleAspectFit
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = CommonUIAssets.LMGray5
    }
    
    private let containerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        contentView.addSubview(dividerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(chevronImageView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
        }
        
        iconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.trailing.equalTo(chevronImageView.snp.leading).offset(-8)
            $0.centerY.equalToSuperview()
        }
        
        chevronImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(12)
        }
        
        dividerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
    
    func configure(with item: MyPageItem, isLastCell: Bool = false) {
        titleLabel.text = item.title
        
        if let icon = item.icon {
            iconImageView.image = UIImage(systemName: icon)
            iconImageView.isHidden = false
            titleLabel.snp.updateConstraints {
                $0.leading.equalTo(iconImageView.snp.trailing).offset(12)
            }
        } else {
            iconImageView.isHidden = true
            titleLabel.snp.updateConstraints {
                $0.leading.equalTo(iconImageView.snp.trailing).offset(0)
            }
        }
        
        if let subtitle = item.subtitle {
            subtitleLabel.text = subtitle
            subtitleLabel.isHidden = false
        } else {
            subtitleLabel.isHidden = true
        }
        
        chevronImageView.isHidden = !item.hasChevron
        dividerView.isHidden = isLastCell
    }
}
