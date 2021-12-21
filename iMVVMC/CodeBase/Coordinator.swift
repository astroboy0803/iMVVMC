//
//  Coordinator.swift
//  MyMVVMC
//
//  Created by astroboy0803 on 2020/9/1.
//  Copyright © 2020 BruceHuang. All rights reserved.
//

import UIKit

protocol ViewModeling: AnyObject {
    associatedtype D
    var coordinatorDelegate: D? { set get }
}

protocol ViewModeler: ViewModeling {
    associatedtype I
    associatedtype P
    
    var interactor: I { get }
    
    init(dataProvider: P, interactor: I)
}

// MARK: - Transition
enum OpenTransitionWay {
    enum PresentStyle {
        case sheet(size: CGSize?)
        case full
    }
    case present(style: PresentStyle, animated: Bool = true)
    case push(animated: Bool = true, style: PresentStyle? = nil)
}

enum CloseTransitionWay {
    case dismiss(animated: Bool = true, completion: (() -> Void)? = nil)
    case pop(animated: Bool = true, completion: (() -> Void)? = nil)
}

// MARK: - Coordinating
protocol Coordinating: AnyObject {
    var parent: Coordinating? { get set }
    var children: [Coordinating] { get set }
    var navDelegateProxy: NavigationControllerDelegateProxy? { get set }
    
    var parenetViewController: UIViewController { get }
    var subViewController: UIViewController { get }
    
    func open(openWay: OpenTransitionWay) -> Void
    func openChild(openWay: OpenTransitionWay, coordinator: Coordinating) -> Void
    func close(closeWay: CloseTransitionWay) -> Void
}

// MARK: coordinate管理
extension Coordinating {
    func startChild(coordinator: Coordinating) {
        guard !children.contains(where: { $0 === coordinator }) else {
            return
        }
        coordinator.parent = self
        children.append(coordinator)
    }
    
    func stopChildren() {
        children.forEach({ $0.stopChildren() })
        children.removeAll()
    }
}

// MARK: Transition
private extension Coordinating {
    var navController: UINavigationController? {
        return parenetViewController as? UINavigationController ?? parenetViewController.navigationController
    }
    
    func present(style: OpenTransitionWay.PresentStyle, animated: Bool = true) {
        switch style {
        case let .sheet(size):
            subViewController.modalPresentationStyle = .pageSheet
            if let size = size {
                subViewController.preferredContentSize = size
            }
        case .full:
            subViewController.modalPresentationStyle = .overFullScreen
        }
        parenetViewController.present(subViewController, animated: animated, completion: nil)
    }
    
    func dismiss(animated: Bool = true, completion: @escaping (() -> Void)) {
        guard subViewController.presentingViewController != nil else {
            if let navController = self.navController, navController.viewControllers.count > 1 {
                doPopViewController(navController: navController, animated: animated, completion: completion)
            }
            return
        }
        subViewController.dismiss(animated: animated) { [coordinating = self.parent] in
            
            completion()
            
            guard let parentCoordinating = coordinating, parentCoordinating.subViewController is UITabBarController, let superCoordinating = parentCoordinating.parent, let index = superCoordinating.children.firstIndex(where: { $0 === parentCoordinating }) else {
                return
            }
            superCoordinating.children.remove(at: index)
        }
    }
    
    func push(animated: Bool, style: OpenTransitionWay.PresentStyle?) {
        guard let navController = self.navController else {
            let navController = createNavigationController(rootViewController: subViewController)
            
            switch style {
            case .full:
                navController.modalPresentationStyle = .overFullScreen
            case let .sheet(size):
                navController.modalPresentationStyle = .pageSheet
                if let size = size {
                    navController.preferredContentSize = size
                }
            default:
                switch parenetViewController.modalPresentationStyle {
                case .formSheet, .pageSheet:
                    navController.modalPresentationStyle = .pageSheet
                    navController.preferredContentSize = parenetViewController.preferredContentSize
                default:
                    navController.modalPresentationStyle = .overFullScreen
                }
            }
            
            self.parenetViewController.present(navController, animated: animated)
            return
        }
        navController.pushViewController(self.subViewController, animated: animated)
    }
    
    func pop(animated: Bool, completion: @escaping (() -> Void)) {
        guard let navController = self.navController, navController.viewControllers.count > 1 else {
            dismiss(animated: animated, completion: completion)
            return
        }
        doPopViewController(navController: navController, animated: animated, completion: completion)
    }
    
    func doPopViewController(navController: UINavigationController, animated: Bool, completion: @escaping (() -> Void)) {
        guard animated else {
            navController.popViewController(animated: false)
            completion()
            return
        }
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        navController.popViewController(animated: animated)
        CATransaction.commit()
    }
    
    func createNavigationController(rootViewController: UIViewController) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        let delegateProxy = NavigationControllerDelegateProxy(coordinator: self)
        self.navDelegateProxy = delegateProxy
        navController.interactivePopGestureRecognizer?.delegate = delegateProxy
        navController.delegate = delegateProxy
        return navController
    }
}

// MARK: - Coordinator
enum CoordinatorStyle {
    case root(isWrapperNav: Bool)
    case node(rootViewController: UIViewController)
}

protocol Coordinator: Coordinating {
    
    associatedtype V: UIViewController
    associatedtype M: ViewModeling
    associatedtype D
    associatedtype C
    
    var viewController: V { get }
    
    var viewModel: M { get }
    
    var dependency: D? { get }
    
    var rootViewController: UIViewController { get }
    
    var delegate: C? { set get }
    
    init(coordinatorStyle: CoordinatorStyle, dependency: D?)
}

extension Coordinator {
    static func getRootViewController(style: CoordinatorStyle, viewController: UIViewController) -> UIViewController {
        switch style {
        case let .root(isWrapperNav):
            if isWrapperNav {
                return UINavigationController(rootViewController: viewController)
            } else {
                return viewController
            }
        case let .node(rootViewController):
            return rootViewController
        }
    }
    
    var parenetViewController: UIViewController {
        return rootViewController
    }
    
    var subViewController: UIViewController {
        return viewController
    }
    
    func setupNavDelegategProxy(coordinatorStyle: CoordinatorStyle) {
        guard case let .root(isWrapperNav) = coordinatorStyle, isWrapperNav, let navController = rootViewController as? UINavigationController else {
            return
        }
        let delegateProxy = NavigationControllerDelegateProxy(coordinator: self)
        self.navDelegateProxy = delegateProxy
        navController.interactivePopGestureRecognizer?.delegate = delegateProxy
        navController.delegate = delegateProxy
    }
    
    func open(openWay: OpenTransitionWay) {
        switch openWay {
        case let .push(animated, style):
            push(animated: animated, style: style)
        case let .present(style, animated):
            present(style: style, animated: animated)
        }
    }
    
    func openChild(openWay: OpenTransitionWay, coordinator: Coordinating) {
        self.startChild(coordinator: coordinator)
        coordinator.open(openWay: openWay)
    }
    
    func close(closeWay: CloseTransitionWay) {
        switch closeWay {
        case let .pop(animated, completion):
            pop(animated: animated) { [coordinating = self.parent] in
                completion?()
                coordinating?.stopChildren()
            }
        case let .dismiss(animated, completion):
            dismiss(animated: animated) { [coordinating = self.parent] in
                completion?()
                guard var parentCoordinating = coordinating else {
                    return
                }
                guard let navController = self.navController, navController.viewControllers.count > 1 else {
                    parentCoordinating.stopChildren()
                    return
                }
                let viewControllers = navController.viewControllers
                while viewControllers.contains(where: { $0 === parentCoordinating.subViewController }), let parent = parentCoordinating.parent {
                    parentCoordinating = parent
                }
                parentCoordinating.stopChildren()
            }
        }
    }
}
