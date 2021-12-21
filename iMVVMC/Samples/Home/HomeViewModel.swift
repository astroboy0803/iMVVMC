//
//  HomeViewModel.swift
//  MyMVVMC
//
//  Created by astroboy0803 on 2020/9/2.
//  Copyright © 2020 BruceHuang. All rights reserved.
//

import Foundation

protocol HomeViewModelInputs {
    func presentAction()
    func pushAction()
    func tabAction()
}

protocol HomeViewModelOutputs {
    
}

protocol HomeViewModelType {
    var inputs: HomeViewModelInputs { get }
    var outputs: HomeViewModelOutputs { get }
}

protocol HomeCoordinatorDelegate: AnyObject {
    func presentNext()
    func pushNext()
    func openTab()
}

class HomeViewModel: HomeViewModelType, ViewModeling {
    
    // for in/out
    var inputs: HomeViewModelInputs {
        return self
    }
    
    var outputs: HomeViewModelOutputs {
        return self
    }
        
    weak var coordinatorDelegate: HomeCoordinatorDelegate?
}

extension HomeViewModel: HomeViewModelInputs {
    final func presentAction() {
        self.coordinatorDelegate?.presentNext()
    }
    
    final func pushAction() {
        self.coordinatorDelegate?.pushNext()
    }
    
    final func tabAction() {
        self.coordinatorDelegate?.openTab()
    }
}

extension HomeViewModel: HomeViewModelOutputs {
    
}
