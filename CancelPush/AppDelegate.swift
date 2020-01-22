//
//  AppDelegate.swift
//  CancelPush
//
//  Created by Vladislav Librecht on 22/01/2020.
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let notificationsSystem = NotificationsSystem()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = ViewController()
        window.makeKeyAndVisible()
        self.window = window
        
        notificationsSystem.registerForRemoteNotifications()
        
        return true
    }
    
    // MARK: Remote Notifications
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let token = deviceToken.map { data in String(format: "%02.2hhx", data) }.joined()
        print("didRegisterForRemoteNotificationsWithDeviceToken:\n\(token)")
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("didFailToRegisterForRemoteNotificationsWithError: \(error)")
    }
    
    // Silent push
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("didReceiveRemoteNotification: \(userInfo)")
        
        notificationsSystem.handleSilentNotification(userInfo: userInfo)
        completionHandler(.noData)
    }
}

final class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
}
