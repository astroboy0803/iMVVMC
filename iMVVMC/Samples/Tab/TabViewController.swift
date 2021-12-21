//
//  TabViewController.swift
//  MyMVVMC
//
//  Created by astroboy0803 on 2020/9/12.
//  Copyright © 2020 BruceHuang. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {
    
    private var viewModel: TabViewModel
    
    init(viewModel: TabViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
