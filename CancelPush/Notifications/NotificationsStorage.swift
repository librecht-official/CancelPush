//
//  NotificationsStorage.swift
//  CancelPush
//
//  Created by Vladislav Librecht on 22/01/2020.
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import Foundation


final class NotificationsStorage {
    typealias SenderId = String
    typealias NotificationId = String
    
    // Could be Dictionary [SenderId: [NotificationId]]
    private var storage = [(SenderId, NotificationId)]()
    
    func add(notificationId: NotificationId, forSenderId senderId: SenderId) {
        storage.append((senderId, notificationId))
    }
    
    func notificationIds(forSenderId senderId: SenderId) -> [NotificationId] {
        return storage.filter { (sId, _) -> Bool in
            return sId == senderId
        }
        .map { (_, nId) -> String in
            return nId
        }
    }
    
    func removeNotificationIds(forSenderId senderId: SenderId) {
        storage.removeAll { (sId, _) -> Bool in
            return sId == senderId
        }
    }
    
    // Need to persist data between app launches
}
