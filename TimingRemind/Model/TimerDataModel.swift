//
//  TimerDataModel.swift
//  TimingRemind
//
//  Created by Channing Kuo on 2017/10/5.
//  Copyright © 2017年 Channing Kuo. All rights reserved.
//

import Foundation

struct TimeSpan {
    var upper: Int = 0
    var lower:Int = 0
    
    init(upper: Int, lower: Int) {
        self.upper = upper
        self.lower = lower
    }
    
    func getTimeSpanString() -> String {
        var hourSpan: String = "00"
        var minuteSpan: String = "00"
        hourSpan = self.upper < 10 ? "0" + String(self.upper) : String(self.upper)
        minuteSpan = self.lower < 10 ? "0" + String(self.lower) : String(self.lower)
        return hourSpan + " : " + minuteSpan
    }
    
    var timeSpan: String {
        get{
            var hourSpan: String = "00"
            var minuteSpan: String = "00"
            hourSpan = self.upper < 10 ? "0" + String(self.upper) : String(self.upper)
            minuteSpan = self.lower < 10 ? "0" + String(self.lower) : String(self.lower)
            return hourSpan + " : " + minuteSpan
        }
    }
}

struct Repeat {
    var daysLine: [Int]
    
    init(daysLine: [Int]) {
        self.daysLine = daysLine.sorted()
    }
    
    var repeatDaysSpan: String {
        get{
            let never: [Int] = []
            let everyday = [1, 2, 3, 4, 5, 6, 7]
            let workdays = [2, 3, 4, 5, 6]
            let weekdays = [1, 7]
            if Repeat.arrayIsEqual(firstArray: self.daysLine, secondArray: never) {
                return "永不"
            }
            if Repeat.arrayIsEqual(firstArray: self.daysLine, secondArray: everyday) {
                return "工作日"
            }
            if Repeat.arrayIsEqual(firstArray: self.daysLine, secondArray: workdays) {
                return "周末"
            }
            if Repeat.arrayIsEqual(firstArray: self.daysLine, secondArray: weekdays) {
                return "每天"
            }
            
            var repeatString: String = ""
            for i in self.daysLine {
                switch i {
                    case 1:
                        repeatString += ", 星期日"
                        break
                    case 2:
                        repeatString += ", 星期一"
                        break
                    case 3:
                        repeatString += ", 星期二"
                        break
                    case 4:
                        repeatString += ", 星期三"
                        break
                    case 5:
                        repeatString += ", 星期四"
                        break
                    case 6:
                        repeatString += ", 星期五"
                        break
                    case 7:
                        repeatString += ", 星期六"
                        break
                default:
                    break
                }
            }
            repeatString = repeatString.subString(start: 1)
            return repeatString
        }
    }
    
    static func arrayIsEqual(firstArray: [Int], secondArray: [Int]) -> Bool {
        if firstArray.count != secondArray.count {
            return false
        }
        for i in firstArray {
            if !secondArray.contains(i) {
                return false
            }
        }
        return true
    }
}

struct TimerData {
    var title: String
    var status: Bool = true
    var repeatDays: Repeat
    var leftTime: TimeSpan
    var rightTime: TimeSpan
    
    init(title: String, leftTime: TimeSpan, rightTime: TimeSpan, repeatDays: Repeat) {
        self.title = title
        self.leftTime = leftTime
        self.rightTime = rightTime
        self.repeatDays = repeatDays
    }
    // get, set
}









