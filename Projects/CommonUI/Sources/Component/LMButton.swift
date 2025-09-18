//
//  LMButton.swift
//  CommonUI
//
//  Created by 박지윤 on 8/25/25.
//

import UIKit

public class LMButton: UIButton {

    private var textColor: UIColor?
    private var bgColor: UIColor?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        initAttribute()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initAttribute()
    }

    public convenience init(textColor: UIColor?, bgColor: UIColor?) {
        self.init(frame: .zero)
        self.textColor = textColor
        self.bgColor = bgColor
        initAttribute()
    }

    public func initAttribute() {
        self.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        self.setTitleColor(textColor ?? .black, for: .normal)
        self.backgroundColor = bgColor ?? .white
        self.layer.cornerRadius = 8

        self.snp.makeConstraints {
            $0.height.equalTo(55)
        }
    }
    
    public func setHeight(_ height: CGFloat) {
        self.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }
}
