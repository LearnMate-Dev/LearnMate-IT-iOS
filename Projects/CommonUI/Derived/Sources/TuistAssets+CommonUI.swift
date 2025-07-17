//// swiftlint:disable:this file_name
//// swiftlint:disable all
//// swift-format-ignore-file
//// swiftformat:disable all
//// Generated using tuist — https://github.com/tuist/tuist
//
//#if os(macOS)
//  import AppKit
//#elseif os(iOS)
//  import UIKit
//#elseif os(tvOS) || os(watchOS)
//  import UIKit
//#endif
//#if canImport(SwiftUI)
//  import SwiftUI
//#endif
//
//// MARK: - Asset Catalogs
//
//public enum CommonUIAsset: Sendable {
//  public enum Colors {
//  public static let lmBlack = CommonUIColors(name: "LMBlack")
//    public static let lmGray01 = CommonUIColors(name: "LMGray01")
//    public static let lmGray03 = CommonUIColors(name: "LMGray03")
//    public static let lmGray05 = CommonUIColors(name: "LMGray05")
//    public static let lmWhite = CommonUIColors(name: "LMWhite")
//    public static let lmOrange01 = CommonUIColors(name: "LMOrange01")
//    public static let lmOrange03 = CommonUIColors(name: "LMOrange03")
//    public static let lmOrange04 = CommonUIColors(name: "LMOrange04")
//  }
//  public enum Images {
//  public static let back = CommonUIImages(name: "back")
//    public static let play = CommonUIImages(name: "play")
//    public static let smallLogo = CommonUIImages(name: "small_logo")
//    public static let tabIconChat = CommonUIImages(name: "tab_icon_chat")
//    public static let tabIconChatSelected = CommonUIImages(name: "tab_icon_chat_selected")
//    public static let tabIconDiary = CommonUIImages(name: "tab_icon_diary")
//    public static let tabIconDiarySelected = CommonUIImages(name: "tab_icon_diary_selected")
//    public static let tabIconHome = CommonUIImages(name: "tab_icon_home")
//    public static let tabIconHomeSelected = CommonUIImages(name: "tab_icon_home_selected")
//    public static let tabIconMypage = CommonUIImages(name: "tab_icon_mypage")
//    public static let tabIconMypageSelected = CommonUIImages(name: "tab_icon_mypage_selected")
//    public static let tabIconStats = CommonUIImages(name: "tab_icon_stats")
//    public static let tabIconStatsSelected = CommonUIImages(name: "tab_icon_stats_selected")
//  }
//}
//
//// MARK: - Implementation Details
//
//public final class CommonUIColors: Sendable {
//  public let name: String
//
//  #if os(macOS)
//  public typealias Color = NSColor
//  #elseif os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
//  public typealias Color = UIColor
//  #endif
//
//  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, visionOS 1.0, *)
//  public var color: Color {
//    guard let color = Color(asset: self) else {
//      fatalError("Unable to load color asset named \(name).")
//    }
//    return color
//  }
//
//  #if canImport(SwiftUI)
//  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, visionOS 1.0, *)
//  public var swiftUIColor: SwiftUI.Color {
//      return SwiftUI.Color(asset: self)
//  }
//  #endif
//
//  fileprivate init(name: String) {
//    self.name = name
//  }
//}
//
//public extension CommonUIColors.Color {
//  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, visionOS 1.0, *)
//  convenience init?(asset: CommonUIColors) {
//    let bundle = Bundle.module
//    #if os(iOS) || os(tvOS) || os(visionOS)
//    self.init(named: asset.name, in: bundle, compatibleWith: nil)
//    #elseif os(macOS)
//    self.init(named: NSColor.Name(asset.name), bundle: bundle)
//    #elseif os(watchOS)
//    self.init(named: asset.name)
//    #endif
//  }
//}
//
//#if canImport(SwiftUI)
//@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, visionOS 1.0, *)
//public extension SwiftUI.Color {
//  init(asset: CommonUIColors) {
//    let bundle = Bundle.module
//    self.init(asset.name, bundle: bundle)
//  }
//}
//#endif
//
//public struct CommonUIImages: Sendable {
//  public let name: String
//
//  #if os(macOS)
//  public typealias Image = NSImage
//  #elseif os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
//  public typealias Image = UIImage
//  #endif
//
//  public var image: Image {
//    let bundle = Bundle.module
//    #if os(iOS) || os(tvOS) || os(visionOS)
//    let image = Image(named: name, in: bundle, compatibleWith: nil)
//    #elseif os(macOS)
//    let image = bundle.image(forResource: NSImage.Name(name))
//    #elseif os(watchOS)
//    let image = Image(named: name)
//    #endif
//    guard let result = image else {
//      fatalError("Unable to load image asset named \(name).")
//    }
//    return result
//  }
//
//  #if canImport(SwiftUI)
//  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, visionOS 1.0, *)
//  public var swiftUIImage: SwiftUI.Image {
//    SwiftUI.Image(asset: self)
//  }
//  #endif
//}
//
//#if canImport(SwiftUI)
//@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, visionOS 1.0, *)
//public extension SwiftUI.Image {
//  init(asset: CommonUIImages) {
//    let bundle = Bundle.module
//    self.init(asset.name, bundle: bundle)
//  }
//
//  init(asset: CommonUIImages, label: Text) {
//    let bundle = Bundle.module
//    self.init(asset.name, bundle: bundle, label: label)
//  }
//
//  init(decorative asset: CommonUIImages) {
//    let bundle = Bundle.module
//    self.init(decorative: asset.name, bundle: bundle)
//  }
//}
//#endif
//
//// swiftformat:enable all
//// swiftlint:enable all
