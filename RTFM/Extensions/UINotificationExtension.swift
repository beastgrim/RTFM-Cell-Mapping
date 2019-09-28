//
//  UINotificationExtension.swift
//  RTFM
//
//  Created by Евгений Богомолов on 28/09/2019.
//  Copyright © 2019 be. All rights reserved.
//

import Foundation
import UserNotifications

extension UNNotification {
    
    static func send(title: String, body: String = "", subtitle: String = "") {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.attachments = []
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "instant", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
