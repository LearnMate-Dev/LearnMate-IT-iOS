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
    /// * tab icon
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

    /// * logo
    public static let smallLogo = image(named: "small_logo")

    /// color
    public static let LMOrange1 = color(named: "LMOrange01")
    public static let LMOrange3 = color(named: "LMOrange03")
    public static let LMOrange4 = color(named: "LMOrange04")
    public static let LMWhite = color(named: "LMWhite")
    public static let LMBlack = color(named: "LMBlack")
    public static let LMGray1 = color(named: "LMGray01")
    public static let LMGray3 = color(named: "LMGray03")
    public static let LMGray5 = color(named: "LMGray05")
}

private func image(named name: String) -> UIImage? {
    return UIImage(named: name, in: Bundle(for: CommonUIBundleHelper.self), compatibleWith: nil)
}

private func color(named name: String) -> UIColor? {
    return UIColor(named: name, in: Bundle(for: CommonUIBundleHelper.self), compatibleWith: nil)
}

extension UIImage {
    public var original: UIImage {
        return self.withRenderingMode(.alwaysOriginal)
    }
}
