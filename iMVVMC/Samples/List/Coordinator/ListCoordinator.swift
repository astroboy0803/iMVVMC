//
//  ListCoordinator.swift
//  MyMVVMC
//
//  Created by astroboy0803 on 2020/8/20.
//  Copyright © 2020 BruceHuang. All rights reserved.
//

import UIKit

protocol ListDelegate: AnyObject {
    
}

class ListCoordinator: Coordinator {
    
    weak var parent: Coordinating?
    
    var children: [Coordinating] = []
    
    var navDelegateProxy: NavigationControllerDelegateProxy?
    
    private (set) var dependency: Codable?
    
    private (set) var rootViewController: UIViewController
    
    private (set) var viewController: ListViewController
    
    private (set) var viewModel: ListViewModel
    
    weak var delegate: ListDelegate?
    
    required init(coordinatorStyle: CoordinatorStyle, dependency: Codable? = nil) {
        
        self.dependency = dependency
        
        let recListViewModel = ListViewModel()
        self.viewModel = recListViewModel
        
        let recListViewController = ListViewController(viewModel: recListViewModel)
        self.viewController = recListViewController
        
        self.rootViewController = Self.getRootViewController(style: coordinatorStyle, viewController: self.viewController)
        
        self.viewModel.coordinatorDelegate = self
        self.setupNavDelegategProxy(coordinatorStyle: coordinatorStyle)
    }    
}

extension ListCoordinator: RecListCoordinatorDelegate {
    final func closePage() {
        self.close(closeWay: .pop())
    }
    
    final func goDetail(classfication: DetailClassfication) {
        let detailCoordinator = DetailCoordinator(coordinatorStyle: .node(rootViewController: self.viewController))
        self.openChild(openWay: .push(), coordinator: detailCoordinator)
    }
}
