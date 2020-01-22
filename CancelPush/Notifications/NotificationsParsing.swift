//
//  NotificationsParsing.swift
//  CancelPush
//
//  Created by Vladislav Librecht on 22/01/2020.
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import Foundation


enum Notification {
    // Normal notification
    case message(NotificationMessage)
    // Signal to remove
    case remove(senderId: String)
}

struct NotificationMessage {
    let senderId, senderName, message: String
}

func parseSilentNotification(_ userInfo: [AnyHashable : Any]) -> Notification? {
    guard let data = userInfo["data"] as? [String: Any],
        let type = data["type"] as? String
        else { return nil }
    
    switch type {
    case "message":
        if let message = parseNotificationMessage(data) {
            return .message(message)
        }
        
    case "remove":
        if let senderId = data["sender_id"] as? String {
            return .remove(senderId: senderId)
        }
        
    default:
        return nil
    }
    return nil
}

func parseNotificationMessage(_ data: [String : Any]) -> NotificationMessage? {
    guard let senderId = data["sender_id"] as? String,
        let senderName = data["sender_name"] as? String,
        let message = data["message"] as? String
        else { return nil }
    
    return NotificationMessage(senderId: senderId, senderName: senderName, message: message)
}
