//
//  CommonUIAssets.swift
//  CommonUI
//
//  Created by 박지윤 on 7/2/25.
//

import UIKit

public final class CommonUIBundleHelper {
    public static func debugBundle() {
        let bundle = Bundle(for: CommonUIBundleHelper.self)
        print("🔍 CommonUI Bundle: \(bundle)")
        print("🔍 Bundle Identifier: \(bundle.bundleIdentifier ?? "nil")")
        print("🔍 Bundle Path: \(bundle.bundlePath)")
        
        if let resourcePath = bundle.resourcePath {
            print("🔍 Resource Path: \(resourcePath)")
            do {
                let contents = try FileManager.default.contentsOfDirectory(atPath: resourcePath)
                print("🔍 Bundle Contents: \(contents)")
            } catch {
                print("❌ Error reading bundle contents: \(error)")
            }
        }
    }
}

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
    public static let logo = image(named: "logo")
    public static let google = image(named: "google")
    public static let apple = image(named: "apple")

    /// * Icon
    public static let IconPlay = image(named: "play")
    public static let IconBack = image(named: "back")
    public static let IconClose = image(named: "close")
    public static let IconSend = image(named: "send")
    public static let IconEdit = image(named: "edit")
    public static let IconMessage = image(named: "message")
    public static let IconBubble = image(named: "bubble")
    public static let IconPrevious = image(named: "previous")
    public static let IconNext = image(named: "next")
    public static let IconNext2 = image(named: "next2")
    public static let IconAdd = image(named: "add")

    /// color
    public static let LMOrange0 = color(named: "LMOrange00")
    public static let LMOrange1 = color(named: "LMOrange01")
    public static let LMOrange3 = color(named: "LMOrange03")
    public static let LMOrange4 = color(named: "LMOrange04")
    public static let LMWhite = color(named: "LMWhite")
    public static let LMBlack = color(named: "LMBlack")
    public static let LMGray1 = color(named: "LMGray01")
    public static let LMGray3 = color(named: "LMGray03")
    public static let LMGray4 = color(named: "LMGray04")
    public static let LMGray5 = color(named: "LMGray05")
    public static let LMGray6 = color(named: "LMGray06")
    public static let LMBlue = color(named: "LMBlue01")
    public static let LMBlue2 = color(named: "LMBlue02")
    public static let LMGreen = color(named: "LMGreen01")
    public static let LMGreen2 = color(named: "LMGreen02")
    public static let LMRed = color(named: "LMRed")
    public static let LMRed2 = color(named: "LMRed02")
    public static let LMPink = color(named: "LMPink")
}

private func image(named name: String) -> UIImage? {
    let bundle = Bundle(for: CommonUIBundleHelper.self)
    return UIImage(named: name, in: bundle, compatibleWith: nil)
}

private func color(named name: String) -> UIColor? {
    let bundle = Bundle(for: CommonUIBundleHelper.self)
    return UIColor(named: name, in: bundle, compatibleWith: nil)
}

extension UIImage {
    public var original: UIImage {
        return self.withRenderingMode(.alwaysOriginal)
    }
}
