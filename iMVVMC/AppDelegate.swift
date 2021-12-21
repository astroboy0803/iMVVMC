//
//  AppDelegate.swift
//  iMVVMC
//
//  Created by astroboy0803 on 2021/12/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    var appRootCoordinatorInfo: AppRootCoordinatorInfo?
    
    struct AppDependency: Codable {
        var name: String
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        
        let homeCoordinator = HomeCoordinator(coordinatorStyle: .root(isWrapperNav: false), dependency: AppDependency(name: "Testing..."))
        window?.rootViewController = homeCoordinator.rootViewController
        self.appRootCoordinatorInfo = AppRootCoordinatorInfo(rootCoordinator: homeCoordinator)
        
        return true
    }
}

