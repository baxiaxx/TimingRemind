//
//  LocalUserNotification.swift
//  TimingRemind
//
//  Created by Channing Kuo on 2017/10/18.
//  Copyright © 2017年 Channing Kuo. All rights reserved.
//

import Foundation
import UserNotifications


/// 本地通知操作类
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
    
    /// 添加通知
    func setupNotification() {
        if self.repeatDays.count <= 0 {
            // 用相同的identity创建通知可以覆盖，达到修改通知的效果
            let leftTrigger = UNCalendarNotificationTrigger(dateMatching: self.leftDate, repeats: false)
            let rightTrigger = UNCalendarNotificationTrigger(dateMatching: self.rightDate, repeats: false)
            
            let leftRequest = UNNotificationRequest(identifier: self.identity + "L", content: self.notificationContent, trigger: leftTrigger)
            let rightRequest = UNNotificationRequest(identifier: self.identity + "R", content: self.notificationContent, trigger: rightTrigger)
            
            self.notificationCenter.add(leftRequest, withCompletionHandler: {
                (Error) -> Void in
                let delay = DispatchTime.now() + DispatchTimeInterval.seconds(30)
                DispatchQueue.main.asyncAfter(deadline: delay, execute: {
                    () -> Void in
                    self.notificationCenter.removeDeliveredNotifications(withIdentifiers: [self.identity + "L"])
                })
            })
            self.notificationCenter.add(rightRequest, withCompletionHandler: {
                (Error) -> Void in
                let delay = DispatchTime.now() + DispatchTimeInterval.seconds(30)
                DispatchQueue.main.asyncAfter(deadline: delay, execute: {
                    () -> Void in
                    self.notificationCenter.removeDeliveredNotifications(withIdentifiers: [self.identity + "R"])
                })
            })
        } else {
            for (day, index) in self.repeatDays.enumerated() {
                self.leftDate.weekday = day
                self.rightDate.weekday = day
                
                let leftTrigger = UNCalendarNotificationTrigger(dateMatching: self.leftDate, repeats: true)
                let rightTrigger = UNCalendarNotificationTrigger(dateMatching: self.rightDate, repeats: true)
                
                let leftRequest = UNNotificationRequest(identifier: self.identity + "L_\(index)", content: self.notificationContent, trigger: leftTrigger)
                let rightRequest = UNNotificationRequest(identifier: self.identity + "R_\(index)", content: self.notificationContent, trigger: rightTrigger)
                
                self.notificationCenter.add(leftRequest, withCompletionHandler: {
                    (Error) -> Void in
                    let delay = DispatchTime.now() + DispatchTimeInterval.seconds(30)
                    DispatchQueue.main.asyncAfter(deadline: delay, execute: {
                        () -> Void in
                        self.notificationCenter.removeDeliveredNotifications(withIdentifiers: [self.identity + "L"])
                    })
                })
                self.notificationCenter.add(rightRequest, withCompletionHandler: {
                    (Error) -> Void in
                    let delay = DispatchTime.now() + DispatchTimeInterval.seconds(30)
                    DispatchQueue.main.asyncAfter(deadline: delay, execute: {
                        () -> Void in
                        self.notificationCenter.removeDeliveredNotifications(withIdentifiers: [self.identity + "R"])
                    })
                })
            }
        }
    }
    
    /// 注销通知
    func shutdownNotification() {
        // 计算当前页面所有通知的identifier
        var indentifiers = [String]()
        if self.repeatDays.count <= 0 {
            indentifiers.append(self.identity + "L")
            indentifiers.append(self.identity + "R")
        } else {
            for (_, index) in self.repeatDays.enumerated() {
                indentifiers.append(self.identity + "L_\(index)")
                indentifiers.append(self.identity + "R_\(index)")
            }
        }
        for identifier in indentifiers {
            self.notificationCenter.getPendingNotificationRequests { (requestArray: [UNNotificationRequest]) in
                for item in requestArray {
                    // 根据identifiers移除指定通知
                    if item.identifier == identifier {
                        self.notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
                    }
                }
            }
        }
    }
    
    /// 注销所有通知
    func shutdownAll() {
        self.notificationCenter.removeAllPendingNotificationRequests()
    }
}
