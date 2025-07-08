//
//  CommonUIAssets.swift
//  CommonUI
//
//  Created by 박지윤 on 7/2/25.
//

import UIKit

public final class CommonUIBundleHelper {}

public enum CommonUIAssets {
    /// image
    public static let tabIconHome = image(named: "tab_icon_home")
    public static let tabIconHomeSelected = image(named: "tab_icon_home_selected")
    public static let tabIconChat = image(named: "tab_icon_chat")
    public static let tabIconChatSelected = image(named: "tab_icon_chat_selected")
    public static let tabIconDiary = image(named: "tab_icon_diary")
    public static let tabIconDiarySelected = image(named: "tab_icon_diary_selected")
    public static let tabIconStats = image(named: "tab_icon_stats")
    public static let tabIconStatsSelected = image(named: "tab_icon_stats_selected")
    public static let tabIconMypage = image(named: "tab_icon_mypage")
    public static let tabIconMypageSelected = image(named: "tab_icon_mypage_selected")

    /// color
    public static let searchViewTitleBackGroundColor = UIColor(red: 225/255, green: 225/255, blue: 245/255, alpha: 0.7)
}

private func image(named name: String) -> UIImage? {
    return UIImage(named: name, in: Bundle(for: CommonUIBundleHelper.self), compatibleWith: nil)
}

extension UIImage {
    public var original: UIImage {
        return self.withRenderingMode(.alwaysOriginal)
    }
}
