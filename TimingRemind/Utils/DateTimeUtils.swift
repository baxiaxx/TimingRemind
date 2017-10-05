//
//  DateTimeUtils.swift
//  PasswordKeeper-swift
//
//  Created by Channing on 2017/1/5.
//  Copyright © 2017年 Channing Kuo. All rights reserved.
//

import Foundation

class DateTimeUtils {
    
    // 把NSDate时间转换成昨天、前天、星期几、等格式
    class func dateTimeFormatter(dateTime: NSDate, isShowTime: Bool) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let now = NSDate()
        let date = dateFormatter.string(from: dateTime as Date)
        let yestoday_now = NSDate(timeInterval: -24 * 60 * 60, since: now as Date)
        let yestoday_yestoday_now = NSDate(timeInterval: -24 * 60 * 60, since: yestoday_now as Date)
        let now_date = dateFormatter.string(from: now as Date)
        if date == now_date {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: dateTime as Date)
        }
        else if date == dateFormatter.string(from: yestoday_now as Date) {
            dateFormatter.dateFormat = "HH:mm"
            return "昨天" + (isShowTime ? " " + dateFormatter.string(from: dateTime as Date) : "")
        }
        else if date == dateFormatter.string(from: yestoday_yestoday_now as Date) {
            dateFormatter.dateFormat = "HH:mm"
            return "前天" + (isShowTime ? " " + dateFormatter.string(from: dateTime as Date) : "")
        }
        else if now.timeIntervalSince(dateTime as Date) < 7 * 24 {
            return dateTime.dayOfWeek() + (isShowTime ? " " + dateFormatter.string(from: dateTime as Date) : "")
        }
        else {
            dateFormatter.dateFormat = "HH:mm"
            return date + (isShowTime ? " " + dateFormatter.string(from: dateTime as Date) : "")
        }
    }
    
    // 把日期型的字符串("2017-01-23 13:55:20")转换成NSDate格式
    class func dateFromString(dateString: String) -> NSDate {
        var separated = dateString.components(separatedBy: "-")
        if separated.count < 3 {
            separated = dateString.components(separatedBy: "/")
            if separated.count < 3 {
                // 日期字符串日期部分有问题，直接返回1970年的时间
                return NSDate.init(timeIntervalSince1970: 0)
            }
        }
        let year = Int(separated[0])
        let month = Int(separated[1])
        let dayString = separated[2]
        
        let separated_depth_1 = dayString.components(separatedBy: "T")
        if separated_depth_1.count < 2 {
            let day = Int(separated[2])
            let components = DateComponents.init(calendar: nil, timeZone: nil, era: nil, year: year, month: month, day: day, hour: 0, minute: 0, second: 0, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
            let calendar = Calendar.current
            let date = calendar.date(from: components)
            let timeIntervalSince1970 = date?.timeIntervalSince1970
            // 日期字符串只有年月日
            return NSDate.init(timeIntervalSince1970: timeIntervalSince1970!)
        }else{
            let day = Int(separated_depth_1[0])
            let timeString = separated_depth_1[1]
            
            let separated_depth_2 = timeString.components(separatedBy: ":")
            if separated_depth_2.count == 2 {
                let hour = Int(separated_depth_2[0])
                let minute = Int(separated_depth_2[1])
                
                let components = DateComponents.init(calendar: nil, timeZone: nil, era: nil, year: year, month: month, day: day, hour: hour, minute: minute, second: 0, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
                let calendar = Calendar.current
                let date = calendar.date(from: components)
                let timeIntervalSince1970 = date?.timeIntervalSince1970
                // 日期字符串有年月日 小时、分钟
                return NSDate.init(timeIntervalSince1970: timeIntervalSince1970!)
            }
            else if separated_depth_2.count == 3 {
                let hour = Int(separated_depth_2[0])
                let minute = Int(separated_depth_2[1])
                let second = Int(separated_depth_2[2])
                
                let components = DateComponents.init(calendar: nil, timeZone: nil, era: nil, year: year, month: month, day: day, hour: hour, minute: minute, second: second, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
                let calendar = Calendar.current
                let date = calendar.date(from: components)
                let timeIntervalSince1970 = date?.timeIntervalSince1970
                // 日期字符串有年月日 小时、分钟、秒
                return NSDate.init(timeIntervalSince1970: timeIntervalSince1970!)
            }
            else {
                // 日期字符串时间部分有问题，直接返回1970年的时间
                return NSDate.init(timeIntervalSince1970: 0)
            }
        }
    }
}

