//
//  AppDelegate.swift
//  video-player
//
//  Created by SHI-BO LIN on 2024/9/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - Properties

    public static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    var window: UIWindow?

    let navigationController = UINavigationController()

    lazy var rootCoordinator: RootCoordinator = .init(navigationController: navigationController)

    // MARK: - Delegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Window Setup
        window = UIWindow(frame: UIScreen.main.bounds)

        window?.rootViewController = navigationController

        window?.makeKeyAndVisible()

        rootCoordinator.start()

        return true
    }
}
