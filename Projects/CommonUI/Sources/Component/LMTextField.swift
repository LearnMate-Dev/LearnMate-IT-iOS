//
//  LMTextField.swift
//  CommonUI
//
//  Created by 박지윤 on 8/25/25.
//

import UIKit

public class LMTextField: UITextField {

    private let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setProperties()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setProperties()
    }
 
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    public func setProperties() {
        self.textColor = CommonUIAssets.LMBlack
        self.font = UIFont.systemFont(ofSize: 16)

        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = CommonUIAssets.LMGray4?.cgColor

        if let placeholder = self.placeholder {
            self.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [.foregroundColor: CommonUIAssets.LMGray4 ?? UIColor.gray]
            )
        }

        self.snp.makeConstraints {
            $0.height.equalTo(55)
        }
    }
}
