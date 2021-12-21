//
//  TabCoordinator.swift
//  MyMVVMC
//
//  Created by astroboy0803 on 2020/9/12.
//  Copyright © 2020 BruceHuang. All rights reserved.
//

import UIKit

protocol TabDelegate: AnyObject {
    
}

class TabCoordinator: Coordinator {
    weak var parent: Coordinating?
    
    var children: [Coordinating] = []
    
    var navDelegateProxy: NavigationControllerDelegateProxy?
    
    private (set) var rootViewController: UIViewController
    
    private (set) var viewController: TabViewController
    
    private (set) var viewModel: TabViewModel
    
    var dependency: Codable?
    
    weak var delegate: TabDelegate?
    
    required init(coordinatorStyle: CoordinatorStyle, dependency: Codable? = nil) {
        self.dependency = dependency
        self.viewModel = TabViewModel()
        self.viewController = TabViewController(viewModel: self.viewModel)
        self.rootViewController = Self.getRootViewController(style: coordinatorStyle, viewController: self.viewController)
        
        self.createTabs()
    }
    
    private final func createTabs() {
        let detailCoordinator = DetailCoordinator(coordinatorStyle: .node(rootViewController: self.viewController))
        let pageCoordinator = PageCoordinator(coordinatorStyle: .node(rootViewController: self.viewController))
        
        self.startChild(coordinator: detailCoordinator)
        self.startChild(coordinator: pageCoordinator)
        
        self.viewController.viewControllers = [detailCoordinator.viewController, pageCoordinator.viewController]
        detailCoordinator.viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        pageCoordinator.viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 1)
    }
}
