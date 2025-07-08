//
//  BaseViewController.swift
//  CommonUI
//
//  Created by 박지윤 on 7/1/25.
//

import UIKit
import RxSwift

public protocol BaseViewItemProtocol: AnyObject {
    func setupViewProperty()
    func setupHierarchy()
    func setupLayout()
}

public protocol BaseViewControllerProtocol: AnyObject, BaseViewItemProtocol {
    func setupDelegate()
    func setupBind()
}

open class BaseViewController: UIViewController, BaseViewControllerProtocol {
    public let disposeBag = DisposeBag()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable, message: "remove required init")
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViewProperty()
        setupDelegate()
        setupHierarchy()
        setupLayout()
        setupBind()
    }

    open func setupViewProperty() { }
    open func setupDelegate() { }
    open func setupHierarchy() { }
    open func setupLayout() { }
    open func setupBind() { }
}
