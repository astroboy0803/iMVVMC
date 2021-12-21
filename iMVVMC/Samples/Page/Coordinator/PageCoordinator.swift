//
//  PageCoordinator.swift
//  CathayLifeATMI
//
//  Created by astroboy0803 on 2020/8/17.
//  Copyright © 2020 CathayLife. All rights reserved.
//

import UIKit

protocol PageDelegate: AnyObject {
    
}

final class PageCoordinator: Coordinator {

    weak var parent: Coordinating?
    
    var children: [Coordinating] = []
    
    var navDelegateProxy: NavigationControllerDelegateProxy?
    
    private (set) var rootViewController: UIViewController
    
    private (set) var viewController: PageViewController
    
    private (set) var viewModel: PageViewModel
    
    var dependency: Codable?
    
    weak var delegate: PageDelegate?
    
    init(rootViewController: UIViewController, viewController: PageViewController, viewModel: PageViewModel, dependency: (Decodable & Encodable)?) {
        self.rootViewController = rootViewController
        self.viewController = viewController
        self.viewModel = viewModel
        self.dependency = dependency
    }
    
    init(coordinatorStyle: CoordinatorStyle, dependency: Codable? = nil) {
        let dataProvider = PageInitialProvider()
        let interactor = PageInteractor()
        let recPageViewModel = PageViewModel(dataProvider: dataProvider, interactor: interactor)
        
        self.viewModel = recPageViewModel
        let recPageViewController = PageViewController(viewModel: recPageViewModel)
        self.viewController = recPageViewController

        self.rootViewController = Self.getRootViewController(style: coordinatorStyle, viewController: self.viewController)
        
        self.viewModel.coordinatorDelegate = self
    }
}

extension PageCoordinator: RecPageCoordinatorDelegate {
    func backToPreviousPage() {
        self.close(closeWay: .pop())
    }
    
    func openUploadingPage() {
        self.close(closeWay: .dismiss())
    }
}
