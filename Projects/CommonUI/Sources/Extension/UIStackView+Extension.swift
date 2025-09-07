//
//  UIStackView+Extension.swift
//  CommonUI
//
//  Created by 박지윤 on 8/28/25.
//

import UIKit

extension UIStackView {
    public func getText() -> String {
        return arrangedSubviews
            .compactMap { $0 as? LMTextField }
            .map { $0.text ?? "" }
            .joined(separator: " ")
    }
}
