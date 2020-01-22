//
//  NotificationsSystem.swift
//  CancelPush
//
//  Created by Vladislav Librecht on 22/01/2020.
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import UIKit
import UserNotifications


final class NotificationsSystem: NSObject {
    private let center = UNUserNotificationCenter.current()
    private let storage = NotificationsStorage()
    
    func registerForRemoteNotifications() {
        center.delegate = self
        center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (granted, _) in
            guard granted else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        })
    }
    
    func handleSilentNotification(userInfo: [AnyHashable : Any]) {
        guard let notification = parseSilentNotification(userInfo) else { return }
        process(notification: notification)
    }
    
    private func process(notification: Notification) {
        switch notification {
        case let .message(message):
            scheduleNotification(message: message)
            
        case let .remove(senderId):
            removeLocalNotifications(senderId: senderId)
        }
    }
    
    private func scheduleNotification(message: NotificationMessage) {
        let content = UNMutableNotificationContent()
        content.title = message.senderName
        content.body = message.message
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        
        let notificationId = UUID().uuidString
        let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("Couldn't schedule notification. \(error)")
            } else {
                self.storage.add(notificationId: notificationId, forSenderId: message.senderId)
            }
        }
    }
    
    private func removeLocalNotifications(senderId: String) {
        let toDelete = storage.notificationIds(forSenderId: senderId)
        center.removeDeliveredNotifications(withIdentifiers: toDelete)
        storage.removeNotificationIds(forSenderId: senderId)
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension NotificationsSystem: UNUserNotificationCenterDelegate {
    // Called when notification received to give an opportunity to display a banner
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .badge, .sound])
    }
}
