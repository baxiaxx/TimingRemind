//
//  NSDateExtension.swift
//  PasswordKeeper-swift
//
//  Created by Channing on 2017/1/9.
//  Copyright © 2017年 Channing Kuo. All rights reserved.
//

import Foundation

// 扩展NSDate, 添加获取某个日期的星期数
extension NSDate {
    func dayOfWeek() -> String {
        let week = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
        let interval = self.timeIntervalSince1970
        let days = Int(interval / 86400)
        return week[(days - 3) % 7]
    }
}
