//
//  UIView+Extension.swift
//  Domain
//
//  Created by 박지윤 on 7/16/25.
//

import UIKit

extension UIView {
    public func parentViewController() -> UIViewController? {
        var parentResponder: UIResponder? = self
        while let responder = parentResponder {
            if let vc = responder as? UIViewController {
                return vc
            }
            parentResponder = responder.next
        }
        return nil
    }
}
