//
//  LocalUserNotification.swift
//  TimingRemind
//
//  Created by Channing Kuo on 2017/10/18.
//  Copyright © 2017年 Channing Kuo. All rights reserved.
//

import Foundation
import UserNotifications

class LocalUserNotification: NSObject {
    class func test(){
        let content = UNMutableNotificationContent()
        content.title = "Notification Tutorial"
        content.body = " Notification triggered"
        // 2
        guard let imageURL = Bundle.main.url(forResource: "test", withExtension: "png")
            else {
                print("err")
                return
        }
        let attachment = try! UNNotificationAttachment(identifier: "test", url: imageURL, options: .none)
        content.attachments = [attachment]
        // 3
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        var components = DateComponents()
        components.weekday = 2
        components.hour = 8
        let trigger1 = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)
        // 4
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
