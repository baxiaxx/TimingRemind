//
//  LocalUserNotification.swift
//  TimingRemind
//
//  Created by Channing Kuo on 2017/10/18.
//  Copyright © 2017年 Channing Kuo. All rights reserved.
//

import Foundation
import UserNotifications

class LocalUserNotification {
    private var notificationContent: UNMutableNotificationContent
    private var notificationCenter: UNUserNotificationCenter
    
    private var repeatDays: [Int]
    private var leftDate, rightDate: DateComponents
    
    private var identity: String
    
    private let calendarNow = Calendar.current
    
    init(timerData: TimerData) {
        self.notificationContent = UNMutableNotificationContent()
        self.notificationCenter = UNUserNotificationCenter.current()
        
        self.notificationContent.title = timerData.title
        self.repeatDays = timerData.repeatDays.daysLine
        self.identity = timerData.identity
        
        self.leftDate = self.calendarNow.dateComponents([.hour, .minute], from: timerData.LeftTime)
        self.rightDate = self.calendarNow.dateComponents([.hour, .minute], from: timerData.RightTime)
    }
    
    func setupNotification() {
        if self.repeatDays.count <= 0 {
            let leftTrigger = UNCalendarNotificationTrigger(dateMatching: self.leftDate, repeats: false)
            let rightTrigger = UNCalendarNotificationTrigger(dateMatching: self.rightDate, repeats: false)
            
            let leftRequest = UNNotificationRequest(identifier: self.identity + "L", content: self.notificationContent, trigger: leftTrigger)
            let rightRequest = UNNotificationRequest(identifier: self.identity + "R", content: self.notificationContent, trigger: rightTrigger)
            
            self.notificationCenter.add(leftRequest, withCompletionHandler: nil)
            self.notificationCenter.add(rightRequest, withCompletionHandler: nil)
        } else {
            for (day, index) in self.repeatDays.enumerated() {
                self.leftDate.weekday = day
                self.rightDate.weekday = day
                
                let leftTrigger = UNCalendarNotificationTrigger(dateMatching: self.leftDate, repeats: true)
                let rightTrigger = UNCalendarNotificationTrigger(dateMatching: self.rightDate, repeats: true)
                
                let leftRequest = UNNotificationRequest(identifier: self.identity + "L_\(index)", content: self.notificationContent, trigger: leftTrigger)
                let rightRequest = UNNotificationRequest(identifier: self.identity + "R_\(index)", content: self.notificationContent, trigger: rightTrigger)
                
                self.notificationCenter.add(leftRequest, withCompletionHandler: nil)
                self.notificationCenter.add(rightRequest, withCompletionHandler: nil)
            }
        }
    }
    
    func shutdownNotification(identifier: String) {
        self.notificationCenter.getPendingNotificationRequests { (requestArray: [UNNotificationRequest]) in
            for item in requestArray {
                // 根据identifiers移除指定通知
                if item.identifier == identifier {
                    self.notificationCenter.removeDeliveredNotifications(withIdentifiers: [identifier])
                }
            }
        }
    }
    
    func shutdownAll() {
        self.notificationCenter.removeAllPendingNotificationRequests()
    }
}
