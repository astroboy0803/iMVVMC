//
//  DetailViewModel.swift
//  MyMVVMC
//
//  Created by astroboy0803 on 2020/9/2.
//  Copyright © 2020 BruceHuang. All rights reserved.
//

import UIKit

protocol DetailViewModelInputs {
    func previousAction()
    func goToPageAction()
}

protocol DetailViewModelOutputs {
    
}

protocol DetailViewModelType {
    var inputs: DetailViewModelInputs { get }
    var outputs: DetailViewModelOutputs { get }
}

protocol DetailCoordinatorDelegate: AnyObject {
    func backToPreviousPage()
    func goToPage()
}

class DetailViewModel: DetailViewModelType, ViewModeling {
    
    // for in/out
    var inputs: DetailViewModelInputs {
        return self
    }
    
    var outputs: DetailViewModelOutputs {
        return self
    }
    
    weak var coordinatorDelegate: DetailCoordinatorDelegate?
}

extension DetailViewModel: DetailViewModelInputs {
    final func previousAction() {
        self.coordinatorDelegate?.backToPreviousPage()
    }
    
    final func goToPageAction() {
        self.coordinatorDelegate?.goToPage()
    }
}

extension DetailViewModel: DetailViewModelOutputs {
    
}
