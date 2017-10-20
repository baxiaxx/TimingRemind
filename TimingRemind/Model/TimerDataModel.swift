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
    
    init(daysLine: String) {
        let jsonData = daysLine.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        let jsonStr = try? JSONSerialization.jsonObject(with: jsonData, options: []) as! [Int]
        self.daysLine = jsonStr!.sorted()
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
    let dateFormatter = DateFormatter()
    
    var title: String
    var status: Bool = false
    var repeatDays: Repeat
    private var leftTime: Date
    private var rightTime: Date
    
    private var id: String = ""
    
    init(title: String, repeatDays: Repeat) {
        self.dateFormatter.dateFormat = "HH:mm"
        
        self.title = title
        
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = 2017
        components.month = 10
        components.day = 09
        components.hour = 09
        components.minute = 00
        components.second = 00
        
        self.leftTime = calendar.date(from: components)!
        components.hour = 18
        self.rightTime = calendar.date(from: components)!
        
        self.repeatDays = repeatDays
    }
    
    var identity: String {
        get {
            return self.id
        }
        set {
            self.id = newValue
        }
    }
    
    var leftTimeSpan: String {
        return dateFormatter.string(from: self.leftTime)
    }
    var rightTimeSpan: String {
        return dateFormatter.string(from: self.rightTime)
    }
    var LeftTime: Date {
        get {
            return self.leftTime
        }
        set {
            self.leftTime = newValue
        }
    }
    var RightTime: Date {
        get {
            return self.rightTime
        }
        set {
            self.rightTime = newValue
        }
    }
}









