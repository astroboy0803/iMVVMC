//
//  NavigationControllerDelegateProxy.swift
//  MyMVVMC
//
//  Created by astroboy0803 on 2020/9/6.
//  Copyright © 2020 BruceHuang. All rights reserved.
//

import UIKit

class NavigationControllerDelegateProxy: NSObject, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    unowned var rootCoordinator: Coordinating
    
    required init(coordinator: Coordinating) {
        self.rootCoordinator = coordinator
    }
    
    final func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard
            let previousViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(previousViewController) else {
                return
        }
        
        let coordinators = self.getAllCoordinators(coordinator: rootCoordinator)
        
        guard let theCoordinator = coordinators.first(where: { $0.subViewController === viewController }) else {
            return
        }
        theCoordinator.stopChildren()
    }
    
    private func getAllCoordinators(coordinator: Coordinating) -> [Coordinating] {
        var results = [Coordinating]()
        coordinator.children.forEach({
            results.append(contentsOf: getAllCoordinators(coordinator: $0))
        })
        results.append(coordinator)
        return results
    }
}
