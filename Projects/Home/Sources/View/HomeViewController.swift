//
//  HomeViewController.swift
//  Home
//
//  Created by 박지윤 on 7/1/25.
//

import UIKit

public class HomeViewController: UIViewController {
    let viewModel: HomeViewModel
    
    public init(homeViewModel: HomeViewModel) {
        self.viewModel = homeViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
}
