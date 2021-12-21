//
//  ListViewModel.swift
//  MyMVVMC
//
//  Created by astroboy0803 on 2020/8/20.
//  Copyright © 2020 BruceHuang. All rights reserved.
//

import Foundation

enum DetailClassfication {
    case new
    case old(caseNo: String)
}

protocol ListViewModelInputs {
    func closeAction()
    func createAction()
    func reviewerAction(caseNo: String)
}

protocol ListViewModelOutputs {
    
}

protocol ListViewModelType {
    var inputs: ListViewModelInputs { get }
    var outputs: ListViewModelOutputs { get }
}

protocol RecListCoordinatorDelegate: AnyObject {
    func closePage()
    func goDetail(classfication: DetailClassfication)
}

class ListViewModel: ListViewModelType, ViewModeling {
    
    weak var coordinatorDelegate: RecListCoordinatorDelegate?
    
    // for in/out
    var inputs: ListViewModelInputs {
        return self
    }
    
    var outputs: ListViewModelOutputs {
        return self
    }
}

extension ListViewModel: ListViewModelInputs {
    final func closeAction() {
        self.coordinatorDelegate?.closePage()
    }
    final func createAction() {
        self.coordinatorDelegate?.goDetail(classfication: .new)
    }
    final func reviewerAction(caseNo: String) {
        // TODO:
        self.coordinatorDelegate?.goDetail(classfication: .old(caseNo: ""))
    }
}

extension ListViewModel: ListViewModelOutputs {
    
}
