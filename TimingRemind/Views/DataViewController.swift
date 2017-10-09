//
//  DataViewController.swift
//  TimingRemind
//
//  Created by Channing Kuo on 2017/10/3.
//  Copyright © 2017年 Channing Kuo. All rights reserved.
//

import UIKit
import TenClock

class DataViewController: UIViewController, TenClockDelegate {
    
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var clock: TenClock!
    
    var leftTime, rightTime: UILabel?
    var timerData: TimerData = TimerData(title: "", repeatDays: Repeat(daysLine: "[]"))
    
    // Clock UI
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()
    func timesChanged(_ clock: TenClock, startDate: Date, endDate: Date) -> () {
        print("start at: \(startDate), end at: \(endDate)")
    }
    func timesUpdated(_ clock: TenClock, startDate: Date, endDate: Date) -> () {
        self.leftTime!.text = dateFormatter.string(from: startDate)
        self.rightTime!.text = dateFormatter.string(from: endDate)
        
        self.timerData.leftTime = startDate
        self.timerData.rightTime = endDate
        
        // TODO 更新数据库
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        clock.startDate = self.timerData.leftTime
        clock.endDate = self.timerData.rightTime
        clock.update()
        clock.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let navigationBorder = UIView(frame: CGRect(x: 0, y: 63, width: self.view.bounds.width, height: 1))
        navigationBorder.backgroundColor = UIColor.init(red: 49 / 255, green: 49 / 255, blue: 49 / 255, alpha: 1)
        self.view.addSubview(navigationBorder)
        
        // 时间选择模块
        let timerSpanView = UIView(frame: CGRect(x: 0, y: 64, width: self.view.bounds.width, height: 115))
        timerSpanView.backgroundColor = .clear
        self.view.addSubview(timerSpanView)
        
        // TODO 高度20的icon
        self.leftTime = UILabel(frame: CGRect(x: 0, y: 40, width: self.view.bounds.width / 2, height: 55))
        self.rightTime = UILabel(frame: CGRect(x: self.view.bounds.width / 2, y: 40, width: self.view.bounds.width / 2, height: 55))
        timerSpanView.addSubview(leftTime!)
        timerSpanView.addSubview(rightTime!)
        leftTime!.text = self.timerData.leftTimeSpan
        leftTime!.textColor = .white
        leftTime!.textAlignment = .center
        leftTime!.font = UIFont.systemFont(ofSize: 45)
        
        rightTime!.text = self.timerData.rightTimeSpan
        rightTime!.textColor = .white
        rightTime!.textAlignment = .center
        rightTime!.font = UIFont.systemFont(ofSize: 45)
        
        // UI控制模块
        let uiController = UIView(frame: CGRect(x: 0, y: 180, width: self.view.bounds.width, height: 310))
        uiController.backgroundColor = .clear
        self.view.addSubview(uiController)
        
        clock.frame.origin.y = -12
        uiController.addSubview(clock)
        
        let dividerBorder = UIView(frame: CGRect(x: 0, y: 490, width: self.view.bounds.width, height: 1))
        dividerBorder.backgroundColor = UIColor.init(red: 49 / 255, green: 49 / 255, blue: 49 / 255, alpha: 1)
        self.view.addSubview(dividerBorder)
        
        // 逻辑控制模块
        let logicController = UIView(frame: CGRect(x: 0, y: 491, width: self.view.bounds.width, height: 200))
        logicController.backgroundColor = .clear
        self.view.addSubview(logicController)
        
        let repeatController = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        repeatController.backgroundColor = .clear
        logicController.addSubview(repeatController)
        let labelName = UILabel(frame: CGRect(x: 20, y: 0, width: 100, height: 50))
        labelName.backgroundColor = .clear
        labelName.text = "重复"
        labelName.textColor = .white
        labelName.textAlignment = .left
        repeatController.addSubview(labelName)
        // Label + icon
        
        let rowBorder = UIView(frame: CGRect(x: 20, y: 542, width: self.view.bounds.width, height: 1))
        rowBorder.backgroundColor = UIColor.init(red: 49 / 255, green: 49 / 255, blue: 49 / 255, alpha: 1)
        self.view.addSubview(rowBorder)
        
        let switchController = UIView(frame: CGRect(x: 0, y: 51, width: self.view.bounds.width, height: 50))
        switchController.backgroundColor = .clear
        logicController.addSubview(switchController)
        let switchName = UILabel(frame: CGRect(x: 20, y: 0, width: 100, height: 50))
        switchName.backgroundColor = .clear
        switchName.text = "启用"
        switchName.textColor = .white
        switchName.textAlignment = .left
        switchController.addSubview(switchName)
        let switchButton = UISwitch()
        switchButton.center = CGPoint(x: self.view.bounds.width - 40, y: 26)
        // switch开关打开————检查数据项并存入数据库 + 添加local notification
        switchButton.setOn(false, animated: true)
        switchController.addSubview(switchButton)
        
        let rowBorder1 = UIView(frame: CGRect(x: 0, y: 593, width: self.view.bounds.width, height: 1))
        rowBorder1.backgroundColor = UIColor.init(red: 49 / 255, green: 49 / 255, blue: 49 / 255, alpha: 1)
        self.view.addSubview(rowBorder1)
        
        self.dataLabel!.text = timerData.title
    }


}

