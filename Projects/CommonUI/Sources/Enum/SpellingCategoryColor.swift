//
//  SpellingCategoryColor.swift
//  CommonUI
//
//  Created by 박지윤 on 9/24/25.
//

import UIKit

public enum SpellingCategoryColor {
    case spelling      // 맞춤법 - 주황색
    case spacing       // 띄어쓰기 - 파란색
    case standard      // 표준어 위반 - 녹색
    case other         // 기타 - 분홍색
    
    public var color: UIColor? {
        switch self {
        case .spelling:
            return CommonUIAssets.LMOrange0
        case .spacing:
            return CommonUIAssets.LMBlue
        case .standard:
            return CommonUIAssets.LMGreen
        case .other:
            return CommonUIAssets.LMPink
        }
    }
    
    public var lightColor: UIColor? {
        return color?.withAlphaComponent(0.3)
    }
    
    public var borderColor: UIColor? {
        return color?.withAlphaComponent(0.5)
    }
    
    public static func color(for category: String) -> SpellingCategoryColor {
        switch category {
        case "맞춤법":
            return .spelling
        case "띄어쓰기":
            return .spacing
        case "표준어 위반":
            return .standard
        default:
            return .other
        }
    }
}
