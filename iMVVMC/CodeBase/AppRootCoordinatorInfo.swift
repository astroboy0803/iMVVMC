//
//  AppRootCoordinatorInfo.swift
//  MyMVVMC
//
//  Created by astroboy0803 on 2020/9/6.
//  Copyright © 2020 BruceHuang. All rights reserved.
//

import UIKit

class AppRootCoordinatorInfo {
    
    private var _rootCoordinating: Coordinating
    
    init(rootCoordinator: Coordinating) {
        self._rootCoordinating = rootCoordinator
    }
    
    final func replace(rootCoordinator: Coordinating) {
        self._rootCoordinating.stopChildren()
        self._rootCoordinating = rootCoordinator
    }
}
