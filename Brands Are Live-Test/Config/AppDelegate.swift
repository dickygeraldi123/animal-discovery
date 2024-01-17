//
//  AppDelegate.swift
//  Brands Are Live-Test
//
//  Created by Dicky Geraldi on 16/01/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = HomeDiscoveryViewController(nibName: "HomeDiscoveryViewController", bundle: nil)
        let homeViewController = UINavigationController(rootViewController: vc)
        window!.rootViewController = homeViewController
        window!.overrideUserInterfaceStyle = .light
        window!.makeKeyAndVisible()

        return true
    }
}
