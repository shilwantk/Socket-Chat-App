//
//  AppDelegate.swift
//  NetomiAssignment
//
//  Created by Kirti on 5/5/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SocketConnectionManager.shared.connect()
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = ViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        MessageQueue.shared.retryFailedMessages()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        SocketConnectionManager.shared.disconnect()
    }
}
