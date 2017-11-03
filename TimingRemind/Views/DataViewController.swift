//
//  DataViewController.swift
//  TimingRemind
//
//  Created by Channing Kuo on 2017/10/3.
//  Copyright © 2017年 Channing Kuo. All rights reserved.
//

import UIKit
import TenClock
import UserNotifications

class DataViewController: UIViewController, TenClockDelegate {
    
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var clock: TenClock!
    
    var repeatView: UIView?
    var leftTime, rightTime: UILabel?
    var cellView: TableViewCell?
    var switchButton: UISwitch?
    var timerData: TimerData = TimerData(title: "", repeatDays: Repeat(daysLine: "[]"))
    var selectedDays: [Int] = []
    
    // Clock UI
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()
//    func timesChanged(_ clock: TenClock, startDate: Date, endDate: Date) -> () {
//        print("start at: \(startDate), end at: \(endDate)")
//    }
    func timesUpdated(_ clock: TenClock, startDate: Date, endDate: Date) -> () {
        self.leftTime!.text = dateFormatter.string(from: startDate)
        self.rightTime!.text = dateFormatter.string(from: endDate)
        
        self.timerData.LeftTime = startDate
        self.timerData.RightTime = endDate
        
        // 更新数据库
        if saveTheDate() > 0 && self.timerData.status {
            // 更新通知
            let localNotification = LocalUserNotification(timerData: self.timerData)
            localNotification.setupNotification()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 询问通知权限
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (success, error) in
            if success {
                print("Notification request succeed!")
            } else {
                print("Notification request failed!")
            }
        }
        
        clock.delegate = self
        
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
        leftTime!.textColor = .white
        leftTime!.textAlignment = .center
        leftTime!.font = UIFont.systemFont(ofSize: 45)
        
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
        cellView = TableViewCell(style: .default, reuseIdentifier: "repeat")
        cellView!.frame = repeatController.frame
        repeatController.addSubview(cellView!)
        
        let rowBorder = UIView(frame: CGRect(x: 20, y: 542, width: self.view.bounds.width - 20, height: 1))
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
        switchButton = UISwitch()
        switchButton!.center = CGPoint(x: self.view.bounds.width - 35, y: 26)
        switchController.addSubview(switchButton!)
        
        let rowBorder1 = UIView(frame: CGRect(x: 0, y: 593, width: self.view.bounds.width, height: 1))
        rowBorder1.backgroundColor = UIColor.init(red: 49 / 255, green: 49 / 255, blue: 49 / 255, alpha: 1)
        self.view.addSubview(rowBorder1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.dataLabel!.text = timerData.title
        
        clock.startDate = self.timerData.LeftTime
        clock.endDate = self.timerData.RightTime
        clock.update()
        
        leftTime!.text = self.timerData.leftTimeSpan
        rightTime!.text = self.timerData.rightTimeSpan
        
        cellView!.updateUIString(name: "重复", value: timerData.repeatDays.repeatDaysSpan)
        cellView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectTheRepeat(_: ))))
        
        
        switchButton!.setOn(self.timerData.status, animated: true)
        
        switchButton!.addTarget(self, action: #selector(openNotification), for: UIControlEvents.touchUpInside)
    }
    
    // 本地通知处理方法 witch开关控制————检查数据项并存入数据库 + 添加local notification
    @objc func openNotification() {
        self.timerData.status = switchButton!.isOn
        // 存储数据
        _ = saveTheDate()
        
        let localNotification = LocalUserNotification(timerData: self.timerData)
        
        if switchButton!.isOn {
            // 开启通知
            localNotification.setupNotification()
        } else {
            // 关闭通知
            localNotification.shutdownNotification()
        }
    }

    
    /// 选择周期重复选项
    ///
    /// - Parameter recognizer: Tap click
    @objc func selectTheRepeat(_ recognizer: UITapGestureRecognizer) {
        repeatView = UIView(frame: self.view.frame)
        repeatView!.backgroundColor = UIColor.init(red: 13 / 255, green: 13 / 255, blue: 13 / 255, alpha: 1)
        
        let navigationView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 63))
        navigationView.backgroundColor = UIColor.init(red: 24 / 255, green: 24 / 255, blue: 24 / 255, alpha: 1)
        repeatView!.addSubview(navigationView)
        let close = UIButton(frame: CGRect(x: self.view.bounds.width - 20 - 38, y: 20, width: 43, height: 43))
        close.setTitle("完成", for: .normal)
        close.setTitleColor(UIColor.init(red: 1, green: 149 / 255, blue: 0, alpha: 1), for: .normal)
        close.setTitleColor(UIColor.init(red: 1, green: 100 / 255, blue: 0, alpha: 1), for: .selected)
        close.backgroundColor = .clear
        close.addTarget(self, action: #selector(closeTheView), for: .touchUpInside)
        navigationView.addSubview(close)
        
        self.view.addSubview(repeatView!)
        repeatView!.frame.origin.y = self.view.bounds.height
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeIn){
            self.repeatView!.frame.origin.y = 0
        }
        animator.startAnimation()
        
        // 多选cell
        let sunday = UIButton()
        sunday.frame = CGRect(x: 0, y: 63, width: self.view.bounds.width, height: 50)
        sunday.setTitle("星期日", for: .normal)
        sunday.tag = 1
        let monday = UIButton()
        monday.frame = CGRect(x: 0, y: 115, width: self.view.bounds.width, height: 50)
        monday.setTitle("星期一", for: .normal)
        monday.tag = 2
        let tuesday = UIButton()
        tuesday.frame = CGRect(x: 0, y: 167, width: self.view.bounds.width, height: 50)
        tuesday.setTitle("星期二", for: .normal)
        tuesday.tag = 3
        let wednesday = UIButton()
        wednesday.frame = CGRect(x: 0, y: 219, width: self.view.bounds.width, height: 50)
        wednesday.setTitle("星期三", for: .normal)
        wednesday.tag = 4
        let thursday = UIButton()
        thursday.frame = CGRect(x: 0, y: 271, width: self.view.bounds.width, height: 50)
        thursday.setTitle("星期四", for: .normal)
        thursday.tag = 5
        let friday = UIButton()
        friday.frame = CGRect(x: 0, y: 323, width: self.view.bounds.width, height: 50)
        friday.setTitle("星期五", for: .normal)
        friday.tag = 6
        let staturday = UIButton()
        staturday.frame = CGRect(x: 0, y: 375, width: self.view.bounds.width, height: 50)
        staturday.setTitle("星期六", for: .normal)
        staturday.tag = 7
        
        let rowBorder0 = UIView(frame: CGRect(x: 20, y: 114, width: self.view.bounds.width - 20, height: 1))
        rowBorder0.backgroundColor = UIColor.init(red: 49 / 255, green: 49 / 255, blue: 49 / 255, alpha: 1)
        self.view.addSubview(rowBorder0)
        let rowBorder1 = UIView(frame: CGRect(x: 20, y: 166, width: self.view.bounds.width - 20, height: 1))
        rowBorder1.backgroundColor = UIColor.init(red: 49 / 255, green: 49 / 255, blue: 49 / 255, alpha: 1)
        self.view.addSubview(rowBorder1)
        let rowBorder2 = UIView(frame: CGRect(x: 20, y: 218, width: self.view.bounds.width - 20, height: 1))
        rowBorder2.backgroundColor = UIColor.init(red: 49 / 255, green: 49 / 255, blue: 49 / 255, alpha: 1)
        self.view.addSubview(rowBorder2)
        let rowBorder3 = UIView(frame: CGRect(x: 20, y: 270, width: self.view.bounds.width - 20, height: 1))
        rowBorder3.backgroundColor = UIColor.init(red: 49 / 255, green: 49 / 255, blue: 49 / 255, alpha: 1)
        self.view.addSubview(rowBorder3)
        let rowBorder4 = UIView(frame: CGRect(x: 20, y: 322, width: self.view.bounds.width - 20, height: 1))
        rowBorder4.backgroundColor = UIColor.init(red: 49 / 255, green: 49 / 255, blue: 49 / 255, alpha: 1)
        self.view.addSubview(rowBorder4)
        let rowBorder5 = UIView(frame: CGRect(x: 20, y: 374, width: self.view.bounds.width - 20, height: 1))
        rowBorder5.backgroundColor = UIColor.init(red: 49 / 255, green: 49 / 255, blue: 49 / 255, alpha: 1)
        self.view.addSubview(rowBorder5)
        let rowBorder6 = UIView(frame: CGRect(x: 20, y: 426, width: self.view.bounds.width - 20, height: 1))
        rowBorder6.backgroundColor = UIColor.init(red: 49 / 255, green: 49 / 255, blue: 49 / 255, alpha: 1)
        self.view.addSubview(rowBorder6)
        
        repeatView!.addSubview(sunday)
        repeatView!.addSubview(monday)
        repeatView!.addSubview(tuesday)
        repeatView!.addSubview(wednesday)
        repeatView!.addSubview(thursday)
        repeatView!.addSubview(friday)
        repeatView!.addSubview(staturday)
        repeatView!.addSubview(rowBorder0)
        repeatView!.addSubview(rowBorder1)
        repeatView!.addSubview(rowBorder2)
        repeatView!.addSubview(rowBorder3)
        repeatView!.addSubview(rowBorder4)
        repeatView!.addSubview(rowBorder5)
        repeatView!.addSubview(rowBorder6)
        let buttonGroup = [sunday, monday, tuesday, wednesday, thursday, friday, staturday]
        
        for button in buttonGroup {
            setButtonAttribute(button: button)
            setButtonImage(button: button)
            setButtonAction(button: button)
        }
    }
    
    /// 设置选择重复规则的点击事件
    ///
    /// - Parameter buttons: buttons
    func setButtonAction(button: UIButton) {
        button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
    }
    
    
    /// 设置按钮的属性
    ///
    /// - Parameter button: UIButton
    func setButtonAttribute(button: UIButton) {
        button.setTitleColor(.lightGray, for: .highlighted)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0)
    }
    
    
    /// click implement
    //
    /// - Parameter sender: UIButton
    @objc func buttonClick(_ sender: UIButton) {
        if !self.timerData.repeatDays.daysLine.contains(sender.tag) {
            self.timerData.repeatDays.daysLine.append(sender.tag)
        } else {
            self.timerData.repeatDays.daysLine.remove(at: self.timerData.repeatDays.daysLine.index(of: sender.tag)!)
        }
        setButtonImage(button: sender)
    }
    
    
    /// 给按钮添加选中图片
    ///
    /// - Parameter button: UIButton
    func setButtonImage(button: UIButton) {
        if !self.timerData.repeatDays.daysLine.contains(button.tag) {
            button.setImage(nil, for: .normal)
            // fix因为添加图片后导致文字位置发生变化
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0)
        } else {
            button.setImage(UIImage.init(named: "checked.png"), for: .normal)
            button.imageEdgeInsets = UIEdgeInsetsMake(0, self.view.bounds.width - 48, 0, 0)
            // fix因为添加图片后导致文字位置发生变化
            button.titleEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 0)
        }
    }
    
    /// 关闭选择页面
    @objc func closeTheView() {
        cellView!.updateUIString(name: "重复", value: timerData.repeatDays.repeatDaysSpan)
        // 保存到数据库
        if saveTheDate() > 0 && self.timerData.status {
            // 更新通知
            let localNotification = LocalUserNotification(timerData: self.timerData)
            localNotification.setupNotification()
        }
        
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut){
            self.repeatView!.frame.origin.y = self.view.bounds.height
        }
        animator.addCompletion { (position) in
            self.repeatView!.removeFromSuperview()
        }
        animator.startAnimation()
    }
    
    
    /// 存数据库
    func saveTheDate() -> CInt {
        var info = [ColumnType]()
        let col0 = ColumnType(colName: "title", colType: nil, colValue: self.timerData.title)
        
        let jsonData = try? JSONSerialization.data(withJSONObject: self.timerData.repeatDays.daysLine, options: [])
        let jsonStr = String(data: jsonData!, encoding: String.Encoding.utf8)
        let col1 = ColumnType(colName: "repeatDays", colType: nil, colValue: jsonStr)
        
        let col2 = ColumnType(colName: "leftTime", colType: nil, colValue: self.timerData.LeftTime)
        let col3 = ColumnType(colName: "rightTime", colType: nil, colValue: self.timerData.RightTime)
        let col4 = ColumnType(colName: "status", colType: nil, colValue: self.timerData.status)
        let col5 = ColumnType(colName: "identity", colType: nil, colValue: self.timerData.identity)
        let col6 = ColumnType(colName: "TIMERREMINDId", colType: nil, colValue: self.timerData.pk)
        info += [col0, col1, col2, col3, col4, col5, col6]
        return SQliteRepository.addOrUpdate(tableName: "TIMERREMIND", colValue: info)
    }
}

