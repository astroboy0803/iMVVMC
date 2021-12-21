//
//  TabViewModel.swift
//  MyMVVMC
//
//  Created by astroboy0803 on 2020/9/12.
//  Copyright © 2020 BruceHuang. All rights reserved.
//

import UIKit

protocol TabCoordinatorDelegate: AnyObject {
    
}

class TabViewModel: ViewModeling {
    weak var coordinatorDelegate: TabCoordinatorDelegate?
}
