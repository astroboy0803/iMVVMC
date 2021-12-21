//
//  DetailCoordinator.swift
//  MyMVVMC
//
//  Created by astroboy0803 on 2020/9/2.
//  Copyright © 2020 BruceHuang. All rights reserved.
//

import UIKit

protocol DetailDelegate: AnyObject {
    
}

class DetailCoordinator: Coordinator {
    
    weak var parent: Coordinating?
    
    var children: [Coordinating] = []
    
    var navDelegateProxy: NavigationControllerDelegateProxy?
    
    private (set) var rootViewController: UIViewController
    
    private (set) var viewController: DetailViewController
    
    private (set) var viewModel: DetailViewModel
    
    var dependency: Codable?
    
    weak var delegate: DetailDelegate?
    
    required init(coordinatorStyle: CoordinatorStyle, dependency: Codable? = nil) {
        self.dependency = dependency
        let viewModel = DetailViewModel()
        self.viewModel = viewModel
        self.viewController = DetailViewController(viewModel: viewModel)
        
        self.rootViewController = Self.getRootViewController(style: coordinatorStyle, viewController: self.viewController)
        
        self.viewModel.coordinatorDelegate = self
        self.setupNavDelegategProxy(coordinatorStyle: coordinatorStyle)
    }
}

extension DetailCoordinator: DetailCoordinatorDelegate {
    final func backToPreviousPage() {
        self.close(closeWay: .pop())
    }
    
    final func goToPage() {
        let pageCoordinator = PageCoordinator(coordinatorStyle: .node(rootViewController: self.viewController))
        self.openChild(openWay: .push(), coordinator: pageCoordinator)
    }
}
