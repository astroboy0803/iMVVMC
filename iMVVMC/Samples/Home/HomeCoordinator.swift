//
//  HomeCoordinator.swift
//  MyMVVMC
//
//  Created by astroboy0803 on 2020/9/2.
//  Copyright © 2020 BruceHuang. All rights reserved.
//

import UIKit

protocol HomeDelegate: AnyObject {
    
}

class HomeCoordinator: Coordinator {
    
    weak var parent: Coordinating?
    
    var children: [Coordinating] = []
    
    var navDelegateProxy: NavigationControllerDelegateProxy?
    
    private (set) var rootViewController: UIViewController
    
    private (set) var viewController: HomeViewController
    
    private (set) var viewModel: HomeViewModel
    
    var dependency: Codable?
    
    weak var delegate: HomeDelegate?
    
    required init(coordinatorStyle: CoordinatorStyle, dependency: Codable? = nil) {
        self.dependency = dependency
        let viewModel = HomeViewModel()
        self.viewModel = viewModel
        let viewController = HomeViewController(viewModel: viewModel)
        self.viewController = viewController
        self.rootViewController = Self.getRootViewController(style: coordinatorStyle, viewController: self.viewController)

        self.viewModel.coordinatorDelegate = self
        self.setupNavDelegategProxy(coordinatorStyle: coordinatorStyle)
    }
}

extension HomeCoordinator: HomeCoordinatorDelegate {
    final func presentNext() {
        self.doNext(openWay: .present(style: .full), nodeRootViewController: self.viewController)
    }
    
    final func pushNext() {
        self.doNext(openWay: .push(style: .full), nodeRootViewController: self.viewController.navigationController ?? self.viewController)
    }
    
    final private func doNext(openWay: OpenTransitionWay, nodeRootViewController: UIViewController) {
        let listCoordinator = ListCoordinator(coordinatorStyle: .node(rootViewController: nodeRootViewController))
        self.openChild(openWay: openWay, coordinator: listCoordinator)
    }
    
    final func openTab() {
        let tabCoordinator = TabCoordinator(coordinatorStyle: .node(rootViewController: self.viewController))
        self.openChild(openWay: .present(style: .full), coordinator: tabCoordinator)
    }
}
