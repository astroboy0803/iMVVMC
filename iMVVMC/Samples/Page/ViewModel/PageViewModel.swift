//
//  PageViewModel.swift
//  CathayLifeATMI
//
//  Created by astroboy0803 on 2020/8/17.
//  Copyright © 2020 CathayLife. All rights reserved.
//

import Foundation

protocol RecPageViewModelInputs {
    func previousAction()
}

protocol RecPageViewModelOutputs {
    
}

protocol PageType {
    var inputs: RecPageViewModelInputs { get }
    var outputs: RecPageViewModelOutputs { get }
}

protocol RecPageCoordinatorDelegate: AnyObject {
    func backToPreviousPage()
    func openUploadingPage()
}

final class PageViewModel: PageType, ViewModeler {
        
    private (set) var interactor: PageInteracting

    weak var coordinatorDelegate: RecPageCoordinatorDelegate?
    
    // for in/out
    var inputs: RecPageViewModelInputs {
        return self
    }
    
    var outputs: RecPageViewModelOutputs {
        return self
    }
    
    init(dataProvider: PageInitialProvider, interactor: PageInteracting) {        
        self.interactor = interactor
    }
}

// MARK: - Inputs
extension PageViewModel: RecPageViewModelInputs {
    func previousAction() {
        self.coordinatorDelegate?.backToPreviousPage()
    }
}

// MARK: - Outputs
extension PageViewModel: RecPageViewModelOutputs {
    
}
